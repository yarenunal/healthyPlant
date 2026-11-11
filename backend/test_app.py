import io
from unittest.mock import MagicMock, patch

import pytest
import requests

import app as app_module

JPEG = b"\xff\xd8\xff\xe0" + b"0" * 100


@pytest.fixture
def client(monkeypatch):
    monkeypatch.setenv("PLANTNET_API_KEY", "test-key")
    monkeypatch.setenv("IDENTIFY_DAILY_LIMIT_PER_IP", "100")
    flask_app = app_module.create_app()
    flask_app.config["TESTING"] = True
    return flask_app.test_client()


def _post(client, data=None, **extra):
    body = {"image": (io.BytesIO(JPEG), "p.jpg")} if data is None else data
    return client.post("/identify", data=body, content_type="multipart/form-data", **extra)


def _upstream(status=200, payload=None):
    resp = MagicMock()
    resp.status_code = status
    resp.json.return_value = payload or {}
    return resp


def test_health(client):
    assert client.get("/health").get_json() == {"status": "ok"}


def test_missing_image(client):
    res = _post(client, data={})
    assert res.status_code == 400
    assert res.get_json()["error"]["code"] == "missing_image"


def test_rejects_non_image(client):
    res = _post(client, data={"image": (io.BytesIO(b"hello"), "x.jpg")})
    assert res.status_code == 400
    assert res.get_json()["error"]["code"] == "unsupported_image"


def test_rejects_too_large(client):
    big = JPEG + b"0" * (app_module.MAX_IMAGE_BYTES + 10)
    res = _post(client, data={"image": (io.BytesIO(big), "big.jpg")})
    assert res.status_code == 413


def test_invalid_organ(client):
    res = _post(
        client,
        data={"image": (io.BytesIO(JPEG), "p.jpg"), "organ": "nope"},
    )
    assert res.status_code == 400


def test_success_is_simplified(client):
    payload = {
        "results": [
            {
                "score": 0.91234567,
                "species": {
                    "scientificNameWithoutAuthor": "Monstera deliciosa",
                    "commonNames": ["Swiss cheese plant", "Monstera"],
                    "family": {"scientificNameWithoutAuthor": "Araceae"},
                },
                "gbif": {"id": "1"},
            }
        ]
    }
    with patch("app.requests.post", return_value=_upstream(200, payload)) as post:
        res = _post(client)
    assert res.status_code == 200
    assert res.get_json() == {
        "results": [
            {
                "scientificName": "Monstera deliciosa",
                "commonNames": ["Swiss cheese plant", "Monstera"],
                "family": "Araceae",
                "score": 0.9123,
            }
        ]
    }
    assert post.call_args.kwargs["params"]["api-key"] == "test-key"


def test_no_match_returns_empty(client):
    with patch("app.requests.post", return_value=_upstream(404)):
        res = _post(client)
    assert res.status_code == 200
    assert res.get_json() == {"results": []}


def test_upstream_unreachable(client):
    with patch("app.requests.post", side_effect=requests.ConnectionError("boom")):
        res = _post(client)
    assert res.status_code == 502


def test_missing_api_key(client, monkeypatch):
    monkeypatch.delenv("PLANTNET_API_KEY")
    assert _post(client).status_code == 503


def test_rate_limit_per_minute(client):
    with patch("app.requests.post", return_value=_upstream(200, {"results": []})):
        codes = [_post(client).status_code for _ in range(6)]
    assert codes[:5] == [200] * 5
    assert codes[5] == 429

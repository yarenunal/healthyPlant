"""Healthy Plant identification proxy.

Receives a plant photo from the mobile app, forwards it to the Pl@ntNet API
using a server-side API key, and returns a small, simplified result.

Photos are processed in memory only and are never written to disk.
"""

import logging
import os

import requests
from dotenv import load_dotenv
from flask import Flask, jsonify, request
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

load_dotenv()

PLANTNET_URL = "https://my-api.plantnet.org/v2/identify/all"
MAX_IMAGE_BYTES = 5 * 1024 * 1024
MAX_RESULTS = 3
REQUEST_TIMEOUT_SECONDS = 20
ALLOWED_ORGANS = {"auto", "leaf", "flower", "fruit", "bark", "habit", "other"}
ALLOWED_LANGS = {"tr", "en"}

log = logging.getLogger("healthy_plant")


def _detect_image_type(data: bytes) -> str | None:
    """Detects the image type from file signature, not from client headers."""
    if data.startswith(b"\xff\xd8\xff"):
        return "image/jpeg"
    if data.startswith(b"\x89PNG\r\n\x1a\n"):
        return "image/png"
    if data[:4] == b"RIFF" and data[8:12] == b"WEBP":
        return "image/webp"
    return None


def _error(status: int, code: str, message: str):
    return jsonify({"error": {"code": code, "message": message}}), status


def _simplify(payload: dict) -> list[dict]:
    """Reduces the Pl@ntNet response to the fields the app needs."""
    results = []
    for item in (payload.get("results") or [])[:MAX_RESULTS]:
        species = item.get("species") or {}
        family = species.get("family") or {}
        results.append(
            {
                "scientificName": species.get("scientificNameWithoutAuthor"),
                "commonNames": (species.get("commonNames") or [])[:3],
                "family": family.get("scientificNameWithoutAuthor"),
                "score": round(float(item.get("score") or 0.0), 4),
            }
        )
    return results


def create_app() -> Flask:
    app = Flask(__name__)
    # Allow small overhead for multipart framing around the image.
    app.config["MAX_CONTENT_LENGTH"] = MAX_IMAGE_BYTES + 64 * 1024

    daily_limit = os.environ.get("IDENTIFY_DAILY_LIMIT_PER_IP", "20")
    limiter = Limiter(
        key_func=get_remote_address,
        app=app,
        storage_uri="memory://",
    )

    @app.get("/health")
    def health():
        return jsonify({"status": "ok"})

    @app.post("/identify")
    @limiter.limit(lambda: f"{daily_limit} per day")
    @limiter.limit("5 per minute")
    def identify():
        api_key = os.environ.get("PLANTNET_API_KEY")
        if not api_key:
            return _error(503, "not_configured", "Identification is unavailable.")

        upload = request.files.get("image")
        if upload is None:
            return _error(400, "missing_image", "Send the photo in the 'image' field.")

        data = upload.stream.read(MAX_IMAGE_BYTES + 1)
        if not data:
            return _error(400, "empty_image", "The image is empty.")
        if len(data) > MAX_IMAGE_BYTES:
            return _error(413, "image_too_large", "The image must be under 5 MB.")

        mime = _detect_image_type(data)
        if mime is None:
            return _error(400, "unsupported_image", "Use a JPEG, PNG or WebP image.")

        organ = request.form.get("organ", "auto")
        if organ not in ALLOWED_ORGANS:
            return _error(400, "invalid_organ", "Unknown organ value.")

        params = {"api-key": api_key}
        lang = request.form.get("lang")
        if lang in ALLOWED_LANGS:
            params["lang"] = lang

        try:
            upstream = requests.post(
                PLANTNET_URL,
                params=params,
                files=[("images", ("photo", data, mime))],
                data={"organs": organ},
                timeout=REQUEST_TIMEOUT_SECONDS,
            )
        except requests.RequestException as exc:
            # Log only the exception type: the message can contain the URL
            # and therefore the API key.
            log.warning("Pl@ntNet request failed: %s", type(exc).__name__)
            return _error(502, "upstream_unreachable", "Identification service is unreachable.")

        if upstream.status_code == 404:
            # Pl@ntNet answers 404 when it finds no matching species.
            return jsonify({"results": []})
        if upstream.status_code == 429:
            return _error(503, "upstream_quota", "Identification is busy. Try again later.")
        if upstream.status_code != 200:
            log.warning("Pl@ntNet returned status %s", upstream.status_code)
            return _error(502, "upstream_error", "Identification service failed.")

        try:
            payload = upstream.json()
        except ValueError:
            return _error(502, "upstream_invalid", "Identification service returned bad data.")

        return jsonify({"results": _simplify(payload)})

    @app.errorhandler(413)
    def too_large(_):
        return _error(413, "image_too_large", "The image must be under 5 MB.")

    @app.errorhandler(429)
    def rate_limited(_):
        return _error(429, "rate_limited", "Too many scans. Try again later.")

    return app


app = create_app()

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=int(os.environ.get("PORT", "8080")))

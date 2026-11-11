# 🌿 healthyPlant

Local-first bitki bakım takipçisi: bitkini fotoğrafla tanı, "Bitkilerim"e ekle, sulamayı bir daha unutma.

Ev ya da sera, fark etmez. healthyPlant bitkilerinin su ve bakım ihtiyaçlarını tek yerden takip etmeni sağlar.

## Özellikler

- 📸 **Tara ve tanı:** Kamera ya da galeriden bitki fotoğrafı seç, uygulama bitkiyi tanısın. Sonuç yanlışsa manuel düzeltebilirsin.
- 🪴 **Bitkilerim:** Eklediğin bitkiler, su ve bakım ihtiyaçlarıyla birlikte listelenir.
- 🔔 **Sulama hatırlatmaları:** Sulama sıklığına göre yerel bildirim gelir. "Sulandı" butonuna basınca sayaç yeniden başlar, basmazsan kart kırmızı uyarı verir.
- 💾 **Local-first:** Bitki verilerin cihazında saklanır, hesap açmana gerek yok.
- 🌍 **Türkçe / İngilizce** dil desteği.
- 🎨 Yeşil pastel tonlarda, eğlenceli bir karşılama ekranı ve arayüz.

## Ekran Görüntüleri

<!-- screenshots/ klasörüne koyup buraya ekle -->

## Teknolojiler

| Katman | Kullanılanlar |
| --- | --- |
| Mobil | Flutter (Dart 3.9+), iOS ve Android |
| Yerel veri | `sqflite`, `shared_preferences` |
| Bildirimler | `flutter_local_notifications`, `timezone`, `flutter_timezone` |
| Kamera / galeri | `image_picker` |
| Ağ | `http` |
| Yerelleştirme | `flutter_localizations`, `intl` (ARB dosyaları) |
| Backend | Python, [Pl@ntNet API](https://my.plantnet.org/) |

## Proje Yapısı

```
lib/
  data/        # modeller, repository, store, bildirim servisi, tarama kotası
  features/    # onboarding, home, scan, my_plants
  l10n/        # TR/EN çeviriler (ARB)
  theme/       # renkler ve tema
  widgets/     # ortak bileşenler
backend/       # bitki tanıma isteklerini Pl@ntNet'e ileten Python servisi
android/ ios/  # platform projeleri
test/          # Flutter testleri
```

## Kurulum

### Gereksinimler

- Flutter SDK (Dart ^3.9.0)
- Python 3
- [Pl@ntNet API anahtarı](https://my.plantnet.org/)

### 1. Backend

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

cp .env.example .env
# .env içine PLANTNET_API_KEY değerini yaz

# Servisi başlat (kendi komutunla değiştir)
```

Testler:

```bash
pytest
```

### 2. Mobil uygulama

```bash
flutter pub get
flutter run
```

> Uygulama tanıma için backend'e istek atar. Gerçek cihazda test ediyorsan backend adresini cihazın erişebileceği bir adrese ayarla.

## Yol Haritası

- [ ] Sera kullanıcıları için özel bakım ayarları
- [ ] Daha geniş bitki bakım kataloğu

## Lisans

Henüz belirlenmedi.

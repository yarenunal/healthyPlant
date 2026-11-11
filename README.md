
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
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 - 2026-11-11 at 15 33 40" src="https://github.com/user-attachments/assets/d7d19eb4-3a5a-4c74-8885-7575e056901d" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 - 2026-11-11 at 15 32 34" src="https://github.com/user-attachments/assets/dc93df8b-34f2-4b97-9319-ffab943b1824" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 - 2026-11-11 at 15 32 25" src="https://github.com/user-attachments/assets/64c3290e-f789-458f-b102-7f292c3725a8" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 - 2026-11-11 at 15 32 00" src="https://github.com/user-attachments/assets/fa498cb1-dbc4-4db9-85dd-40f5fa52f4df" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 - 2026-11-11 at 15 31 50" src="https://github.com/user-attachments/assets/f18e6fcd-09c7-44f4-b327-b069f2616543" />

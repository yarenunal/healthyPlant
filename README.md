
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
<p align="center">
  <img src="https://github.com/user-attachments/assets/ccb05bff-6fcb-458d-9957-544f558fd6b2" width="220" alt="Ekran 1" />
  <img src="https://github.com/user-attachments/assets/7e03ab6f-a0ab-4ccc-ab33-a5a9c8997fd0" width="220" alt="Ekran 2" />
  <img src="https://github.com/user-attachments/assets/2b2a125d-5158-4c5f-a32d-49b99be6d879" width="220" alt="Ekran 3" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/605028e4-da77-4eb8-91fe-486097d73dc3" width="220" alt="Ekran 4" />
  <img src="https://github.com/user-attachments/assets/108f0980-bf10-499b-a80e-95c9b73e4914" width="220" alt="Ekran 5" />
</p>

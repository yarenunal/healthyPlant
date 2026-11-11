import 'models.dart';

/// Small starter catalog written for this app (not scraped from other apps).
abstract final class PlantCatalog {
  static const plants = <CatalogPlant>[
    CatalogPlant(
      id: 'monstera',
      nameTr: 'Deve Tabanı',
      nameEn: 'Monstera',
      scientificName: 'Monstera deliciosa',
      wateringDays: 7,
      light: 'Bright indirect',
      careTipTr: 'Toprağın üstü kuruyunca sula. Yaprakları ara sıra sil.',
      careTipEn: 'Water when the top soil is dry. Wipe leaves now and then.',
      emoji: '🪴',
    ),
    CatalogPlant(
      id: 'pothos',
      nameTr: 'Salon Sarmaşığı',
      nameEn: 'Pothos',
      scientificName: 'Epipremnum aureum',
      wateringDays: 7,
      light: 'Low to bright',
      careTipTr: 'Az ışığa dayanır. Toprak hafif kuruyunca sula.',
      careTipEn: 'Tolerates low light. Water when soil is lightly dry.',
      emoji: '🌿',
    ),
    CatalogPlant(
      id: 'snake',
      nameTr: 'Paşa Kılıcı',
      nameEn: 'Snake Plant',
      scientificName: 'Dracaena trifasciata',
      wateringDays: 14,
      light: 'Low to bright',
      careTipTr: 'Az sula. Kök çürümesine dikkat et.',
      careTipEn: 'Water sparingly. Watch for root rot.',
      emoji: '🌵',
    ),
    CatalogPlant(
      id: 'aloe',
      nameTr: 'Aloe Vera',
      nameEn: 'Aloe Vera',
      scientificName: 'Aloe vera',
      wateringDays: 14,
      light: 'Bright',
      careTipTr: 'Güneş sever. Toprak tamamen kuruyunca sula.',
      careTipEn: 'Loves sun. Water only when soil is fully dry.',
      emoji: '🌱',
    ),
    CatalogPlant(
      id: 'fiddle',
      nameTr: 'Fiddle Leaf Fig',
      nameEn: 'Fiddle Leaf Fig',
      scientificName: 'Ficus lyrata',
      wateringDays: 7,
      light: 'Bright indirect',
      careTipTr: 'Düzenli ışık ister. Ani yer değiştirmeyi sevmez.',
      careTipEn: 'Needs steady light. Dislikes sudden moves.',
      emoji: '🌳',
    ),
    CatalogPlant(
      id: 'peace',
      nameTr: 'Barış Çiçeği',
      nameEn: 'Peace Lily',
      scientificName: 'Spathiphyllum',
      wateringDays: 5,
      light: 'Medium',
      careTipTr: 'Toprağı nemli tut. Yapraklar sarkarsa susamıştır.',
      careTipEn: 'Keep soil lightly moist. Droopy leaves mean thirst.',
      emoji: '🤍',
    ),
    CatalogPlant(
      id: 'succulent',
      nameTr: 'Sukulent',
      nameEn: 'Succulent',
      scientificName: 'Various',
      wateringDays: 14,
      light: 'Bright',
      careTipTr: 'Az ve seyrek sula. İyi drenaj şart.',
      careTipEn: 'Water rarely. Good drainage is a must.',
      emoji: '💚',
    ),
    CatalogPlant(
      id: 'basil',
      nameTr: 'Fesleğen',
      nameEn: 'Basil',
      scientificName: 'Ocimum basilicum',
      wateringDays: 3,
      light: 'Full sun',
      careTipTr: 'Sık sula ama gövdeyi ıslatma. Bol ışık ver.',
      careTipEn: 'Water often but keep stems dry. Give lots of light.',
      emoji: '🍃',
    ),
  ];

  static CatalogPlant? byId(String id) {
    for (final plant in plants) {
      if (plant.id == id) return plant;
    }
    return null;
  }

  static List<CatalogPlant> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return plants;
    return plants.where((p) {
      return p.nameTr.toLowerCase().contains(q) ||
          p.nameEn.toLowerCase().contains(q) ||
          p.scientificName.toLowerCase().contains(q);
    }).toList();
  }

  /// Temporary “guess” until a real on-device/API identifier is plugged in.
  static List<CatalogPlant> suggestFromScan() {
    final shuffled = [...plants]..shuffle();
    return shuffled.take(3).toList();
  }
}

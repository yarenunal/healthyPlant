class CatalogPlant {
  const CatalogPlant({
    required this.id,
    required this.nameTr,
    required this.nameEn,
    required this.scientificName,
    required this.wateringDays,
    required this.light,
    required this.careTipTr,
    required this.careTipEn,
    required this.emoji,
  });

  final String id;
  final String nameTr;
  final String nameEn;
  final String scientificName;
  final int wateringDays;
  final String light;
  final String careTipTr;
  final String careTipEn;
  final String emoji;

  String displayName({required bool turkish}) => turkish ? nameTr : nameEn;

  String careTip({required bool turkish}) => turkish ? careTipTr : careTipEn;
}

class UserPlant {
  UserPlant({
    required this.id,
    required this.catalogId,
    required this.nickname,
    required this.photoPath,
    required this.wateringDays,
    required this.lastWateredAt,
    required this.createdAt,
  });

  final String id;
  final String catalogId;
  String nickname;
  final String? photoPath;
  int wateringDays;
  DateTime lastWateredAt;
  final DateTime createdAt;

  DateTime get nextWateringAt =>
      lastWateredAt.add(Duration(days: wateringDays));

  bool get isOverdue {
    final now = DateTime.now();
    final next = DateTime(
      nextWateringAt.year,
      nextWateringAt.month,
      nextWateringAt.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    return today.isAfter(next);
  }

  bool get needsWaterToday {
    final now = DateTime.now();
    final next = DateTime(
      nextWateringAt.year,
      nextWateringAt.month,
      nextWateringAt.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    return !today.isBefore(next);
  }

  int get daysUntilWater {
    final now = DateTime.now();
    final next = DateTime(
      nextWateringAt.year,
      nextWateringAt.month,
      nextWateringAt.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    return next.difference(today).inDays;
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'catalogId': catalogId,
        'nickname': nickname,
        'photoPath': photoPath,
        'wateringDays': wateringDays,
        'lastWateredAt': lastWateredAt.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserPlant.fromMap(Map<String, Object?> map) => UserPlant(
        id: map['id']! as String,
        catalogId: map['catalogId']! as String,
        nickname: map['nickname']! as String,
        photoPath: map['photoPath'] as String?,
        wateringDays: map['wateringDays']! as int,
        lastWateredAt: DateTime.parse(map['lastWateredAt']! as String),
        createdAt: DateTime.parse(map['createdAt']! as String),
      );

  UserPlant copyWith({
    String? nickname,
    String? photoPath,
    int? wateringDays,
    DateTime? lastWateredAt,
  }) {
    return UserPlant(
      id: id,
      catalogId: catalogId,
      nickname: nickname ?? this.nickname,
      photoPath: photoPath ?? this.photoPath,
      wateringDays: wateringDays ?? this.wateringDays,
      lastWateredAt: lastWateredAt ?? this.lastWateredAt,
      createdAt: createdAt,
    );
  }
}

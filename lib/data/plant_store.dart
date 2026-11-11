import 'package:flutter/foundation.dart';

import 'models.dart';
import 'notification_service.dart';
import 'plant_repository.dart';

class PlantStore extends ChangeNotifier {
  PlantStore({
    PlantRepository? repository,
    NotificationService? notifications,
  })  : _repository = repository ?? PlantRepository.instance,
        _notifications = notifications ?? NotificationService.instance;

  final PlantRepository _repository;
  final NotificationService _notifications;
  List<UserPlant> _plants = [];
  bool _loading = true;

  List<UserPlant> get plants => List.unmodifiable(_plants);
  bool get loading => _loading;

  int get thirstyCount =>
      _plants.where((p) => p.needsWaterToday || p.isOverdue).length;

  int get overdueCount => _plants.where((p) => p.isOverdue).length;

  List<UserPlant> get overduePlants =>
      _plants.where((p) => p.isOverdue).toList();

  List<UserPlant> get needsAttentionPlants =>
      _plants.where((p) => p.needsWaterToday || p.isOverdue).toList();

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _plants = await _repository.getAll();
    _loading = false;
    notifyListeners();
    await _notifications.rescheduleAll(_plants);
  }

  Future<UserPlant> addPlant({
    required String catalogId,
    required String nickname,
    required int wateringDays,
    String? photoPath,
  }) async {
    final plant = await _repository.add(
      catalogId: catalogId,
      nickname: nickname,
      wateringDays: wateringDays,
      photoPath: photoPath,
    );
    _plants = [plant, ..._plants];
    notifyListeners();
    await _notifications.rescheduleAll(_plants);
    return plant;
  }

  Future<void> markWatered(String id) async {
    await _repository.markWatered(id);
    final index = _plants.indexWhere((p) => p.id == id);
    if (index == -1) return;
    _plants[index] = _plants[index].copyWith(lastWateredAt: DateTime.now());
    notifyListeners();
    await _notifications.rescheduleAll(_plants);
  }

  Future<void> remove(String id) async {
    await _repository.delete(id);
    _plants = _plants.where((p) => p.id != id).toList();
    notifyListeners();
    await _notifications.rescheduleAll(_plants);
  }
}

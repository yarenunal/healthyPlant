import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';

class PlantRepository {
  PlantRepository._();
  static final PlantRepository instance = PlantRepository._();

  Database? _db;
  final _uuid = const Uuid();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'healthy_plant.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_plants (
            id TEXT PRIMARY KEY,
            catalogId TEXT NOT NULL,
            nickname TEXT NOT NULL,
            photoPath TEXT,
            wateringDays INTEGER NOT NULL,
            lastWateredAt TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<UserPlant>> getAll() async {
    final db = await database;
    final rows = await db.query('user_plants', orderBy: 'createdAt DESC');
    return rows.map(UserPlant.fromMap).toList();
  }

  Future<UserPlant> add({
    required String catalogId,
    required String nickname,
    required int wateringDays,
    String? photoPath,
  }) async {
    final plant = UserPlant(
      id: _uuid.v4(),
      catalogId: catalogId,
      nickname: nickname,
      photoPath: photoPath,
      wateringDays: wateringDays,
      lastWateredAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
    final db = await database;
    await db.insert('user_plants', plant.toMap());
    return plant;
  }

  Future<void> markWatered(String id) async {
    final db = await database;
    await db.update(
      'user_plants',
      {'lastWateredAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete('user_plants', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateNickname(String id, String nickname) async {
    final db = await database;
    await db.update(
      'user_plants',
      {'nickname': nickname},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

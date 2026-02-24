import '../db/app_db.dart';
import '../models/water_entry.dart';

class WaterRepo {
  final _db = AppDb.instance;

  Future<int> insertEntry(WaterEntry entry) async {
    final database = await _db.db;
    return database.insert('water_entries', entry.toMap());
  }

  Future<int> deleteEntry(int id) async {
    final database = await _db.db;
    return database.delete(
      'water_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> todayTotal(String dayKey) async {
    final database = await _db.db;

    final rows = await database.rawQuery(
      '''
      SELECT COALESCE(SUM(amount_ml), 0) as total
      FROM water_entries
      WHERE day_key = ?
      ''',
      [dayKey],
    );

    return (rows.first['total'] as int?) ?? 0;
  }

  Future<List<WaterEntry>> entriesByDay(String dayKey) async {
    final database = await _db.db;

    final rows = await database.query(
      'water_entries',
      where: 'day_key = ?',
      whereArgs: [dayKey],
      orderBy: 'timestamp DESC',
    );

    return rows.map(WaterEntry.fromMap).toList();
  }

  Future<List<Map<String, Object?>>> dailyTotalsBetween(
      List<String> dayKeys) async {
    if (dayKeys.isEmpty) return [];

    final database = await _db.db;
    final inClause = List.filled(dayKeys.length, '?').join(',');

    return database.rawQuery('''
      SELECT day_key, COALESCE(SUM(amount_ml), 0) as total
      FROM water_entries
      WHERE day_key IN ($inClause)
      GROUP BY day_key
      ORDER BY day_key DESC
    ''', dayKeys);
  }
}
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDb {
  AppDb._();
  static final AppDb instance = AppDb._();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'water_tracker.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE water_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount_ml INTEGER NOT NULL,
            timestamp INTEGER NOT NULL,
            day_key TEXT NOT NULL
          );
        ''');
        await database.execute('CREATE INDEX idx_day_key ON water_entries(day_key);');
      },
    );
  }
}
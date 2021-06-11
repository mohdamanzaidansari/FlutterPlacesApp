import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBController {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(join(dbPath, 'great_places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE places (id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lon REAL, address TEXT )');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBController.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBController.database();
    return db.query(table);
  }
}

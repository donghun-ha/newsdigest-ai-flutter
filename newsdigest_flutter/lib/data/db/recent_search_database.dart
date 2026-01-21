import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/recent_search.dart';

class RecentSearchDatabase {
  RecentSearchDatabase._();

  static final RecentSearchDatabase instance = RecentSearchDatabase._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'newsdigest.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await _createRecentTable(db);
      },
      onOpen: (Database db) async {
        await _createRecentTable(db);
      },
    );
  }

  Future<void> _createRecentTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS recent_searches (
        term TEXT PRIMARY KEY,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  Future<List<RecentSearch>> getRecentSearches({int limit = 8}) async {
    final Database db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      'recent_searches',
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return rows.map(RecentSearch.fromDbMap).toList();
  }

  Future<void> upsertSearch(RecentSearch search) async {
    final Database db = await database;
    await db.insert(
      'recent_searches',
      search.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteSearch(String term) async {
    final Database db = await database;
    await db.delete(
      'recent_searches',
      where: 'term = ?',
      whereArgs: <Object>[term],
    );
  }

  Future<void> clearAll() async {
    final Database db = await database;
    await db.delete('recent_searches');
  }
}

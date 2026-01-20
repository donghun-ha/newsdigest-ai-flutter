import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/bookmark_item.dart';

class BookmarkDatabase {
  BookmarkDatabase._();

  static final BookmarkDatabase instance = BookmarkDatabase._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'newsdigest.db');
    // DB 파일 경로 확인용 로그
    print('Bookmark DB path: $path');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE bookmarks (
            url TEXT PRIMARY KEY,
            news_id INTEGER,
            title TEXT NOT NULL,
            summary TEXT NOT NULL,
            published_at TEXT,
            source TEXT,
            image_url TEXT,
            query TEXT,
            created_at INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<BookmarkItem>> getBookmarks() async {
    final Database db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      'bookmarks',
      orderBy: 'created_at DESC',
    );
    return rows.map(BookmarkItem.fromDbMap).toList();
  }

  Future<void> upsertBookmark(BookmarkItem item) async {
    final Database db = await database;
    await db.insert(
      'bookmarks',
      item.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBookmark(String url) async {
    final Database db = await database;
    await db.delete(
      'bookmarks',
      where: 'url = ?',
      whereArgs: <Object>[url],
    );
  }

  Future<void> deleteAll() async {
    final Database db = await database;
    await db.delete('bookmarks');
  }
}

import '../db/bookmark_database.dart';
import '../models/bookmark_item.dart';

class BookmarkRepository {
  final BookmarkDatabase _database;

  BookmarkRepository({BookmarkDatabase? database})
      : _database = database ?? BookmarkDatabase.instance;

  Future<List<BookmarkItem>> fetchBookmarks() async {
    return _database.getBookmarks();
  }

  Future<void> saveBookmark(BookmarkItem item) async {
    await _database.upsertBookmark(item);
  }

  Future<void> removeBookmark(String url) async {
    await _database.deleteBookmark(url);
  }

  Future<void> clearBookmarks() async {
    await _database.deleteAll();
  }
}

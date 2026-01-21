import '../db/recent_search_database.dart';
import '../models/recent_search.dart';

class RecentSearchRepository {
  final RecentSearchDatabase _database;

  RecentSearchRepository({RecentSearchDatabase? database})
      : _database = database ?? RecentSearchDatabase.instance;

  Future<List<RecentSearch>> fetchRecentSearches({int limit = 8}) async {
    return _database.getRecentSearches(limit: limit);
  }

  Future<void> saveSearch(String term) async {
    await _database.upsertSearch(
      RecentSearch(
        term: term,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Future<void> removeSearch(String term) async {
    await _database.deleteSearch(term);
  }

  Future<void> clearAll() async {
    await _database.clearAll();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsdigest_flutter/data/models/recent_search.dart';
import 'package:newsdigest_flutter/data/repository/recent_search_repository.dart';

import 'recent_search_state.dart';

class RecentSearchNotifier extends StateNotifier<RecentSearchState> {
  final RecentSearchRepository _repository;

  RecentSearchNotifier(this._repository)
      : super(const RecentSearchState());

  Future<void> loadRecent({int limit = 8}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final List<RecentSearch> items =
          await _repository.fetchRecentSearches(limit: limit);
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '최근 검색어 로딩 실패: $e',
      );
    }
  }

  Future<void> addSearch(String term) async {
    final String trimmed = term.trim();
    if (trimmed.isEmpty) return;
    await _repository.saveSearch(trimmed);
    await loadRecent();
  }

  Future<void> removeSearch(String term) async {
    await _repository.removeSearch(term);
    await loadRecent();
  }

  Future<void> clearAll() async {
    await _repository.clearAll();
    await loadRecent();
  }
}

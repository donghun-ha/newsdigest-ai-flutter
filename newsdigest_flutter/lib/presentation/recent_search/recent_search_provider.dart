import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsdigest_flutter/data/repository/recent_search_repository.dart';

import 'recent_search_notifier.dart';
import 'recent_search_state.dart';

final Provider<RecentSearchRepository> recentSearchRepositoryProvider =
    Provider<RecentSearchRepository>((Ref ref) {
  return RecentSearchRepository();
});

final StateNotifierProvider<RecentSearchNotifier, RecentSearchState>
    recentSearchNotifierProvider =
    StateNotifierProvider<RecentSearchNotifier, RecentSearchState>((Ref ref) {
  final RecentSearchRepository repository =
      ref.watch(recentSearchRepositoryProvider);
  return RecentSearchNotifier(repository);
});

import 'package:newsdigest_flutter/data/models/recent_search.dart';

class RecentSearchState {
  final List<RecentSearch> items;
  final bool isLoading;
  final String? errorMessage;

  const RecentSearchState({
    this.items = const <RecentSearch>[],
    this.isLoading = false,
    this.errorMessage,
  });

  RecentSearchState copyWith({
    List<RecentSearch>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RecentSearchState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

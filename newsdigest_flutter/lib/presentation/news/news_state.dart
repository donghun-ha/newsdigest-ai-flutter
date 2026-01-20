import 'package:newsdigest_flutter/data/models/news_item.dart';

class NewsState {
  final List<NewsItem> items;
  final bool isLoading;
  final Map<int, String> summaries;
  final Set<int> summarizingIds;
  final String? errorMessage;

  const NewsState({
    this.items = const <NewsItem>[],
    this.isLoading = false,
    this.summaries = const <int, String>{},
    this.summarizingIds = const <int>{},
    this.errorMessage,
  });

  NewsState copyWith({
    List<NewsItem>? items,
    bool? isLoading,
    Map<int, String>? summaries,
    Set<int>? summarizingIds,
    String? errorMessage,
  }) {
    return NewsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      summaries: summaries ?? this.summaries,
      summarizingIds: summarizingIds ?? this.summarizingIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

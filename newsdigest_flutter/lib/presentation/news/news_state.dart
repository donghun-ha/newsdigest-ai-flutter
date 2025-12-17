import 'package:newsdigest_flutter/data/models/news_item.dart';

class NewsState {
  final List<NewsItem> items;
  final bool isLoading;
  final bool isSummarizing;
  final String? lastSummary;
  final String? errorMessage;

  const NewsState({
    this.items = const <NewsItem>[],
    this.isLoading = false,
    this.isSummarizing = false,
    this.lastSummary,
    this.errorMessage,
  });

  NewsState copyWith({
    List<NewsItem>? items,
    bool? isLoading,
    bool? isSummarizing,
    String? lastSummary,
    String? errorMessage,
  }) {
    return NewsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isSummarizing: isSummarizing ?? this.isSummarizing,
      lastSummary: lastSummary ?? this.lastSummary,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

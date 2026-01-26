import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsdigest_flutter/data/repository/news_repository.dart';
import 'package:newsdigest_flutter/presentation/news/news_notifier.dart';
import 'package:newsdigest_flutter/presentation/news/news_state.dart';

// NewsRepository를 제공하는 Provider
final Provider<NewsRepository> newsRepositoryProvider =
    Provider<NewsRepository>((Ref ref) {
  return NewsRepository();
});

// NewsNotifier + NewsState를 제공하는 Provider
final StateNotifierProvider<NewsNotifier, NewsState> newsNotifierProvider =
    StateNotifierProvider<NewsNotifier, NewsState>((Ref ref) {
  final NewsRepository repo = ref.watch(newsRepositoryProvider);
  return NewsNotifier(repo);
});

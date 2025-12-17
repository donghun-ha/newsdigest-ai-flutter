import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsdigest_flutter/data/repository/news_repository.dart';
import 'package:newsdigest_flutter/presentation/news/news_notifier.dart';
import 'package:newsdigest_flutter/presentation/news/news_state.dart';

// NewsRepository를 제공하는 Provider
final Provider<NewsRepository> newsRepositoryProvider =
    Provider<NewsRepository>((ref) {
  return NewsRepository();
});

// NewsNotifier + NewsState를 제공하는 Provider
final newsNotifierProvider =
    StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  final repo = ref.watch(newsRepositoryProvider);
  return NewsNotifier(repo);
});

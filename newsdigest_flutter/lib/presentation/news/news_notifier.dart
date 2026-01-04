import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsdigest_flutter/data/repository/news_repository.dart';
import '../../data/models/news_item.dart';
import '../../data/models/news_search_response.dart';
import 'package:newsdigest_flutter/presentation/news/news_state.dart';

class NewsNotifier extends StateNotifier<NewsState> {
  final NewsRepository _repository;

  NewsNotifier(this._repository) : super(const NewsState());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final NewsSearchResponse res = await _repository.searchNews(query: query);
      state = state.copyWith(
        items: res.items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '뉴스 검색 실패: $e',
      );
    }
  }

  Future<void> summarize(NewsItem item, {int maxSentences = 3}) async {
    state = state.copyWith(isSummarizing: true, errorMessage: null);
    try {
      final String summary = await _repository.summarize(
          text: item.summary, maxSentences: maxSentences);
      state = state.copyWith(
        isSummarizing: false,
        lastSummary: summary,
      );
    } catch (e) {
      state = state.copyWith(
        isSummarizing: false,
        errorMessage: '요약 실패: $e',
      );
    }
  }

  Future<Map<String, dynamic>> getNewsDetail(int newsId, String query) async {
    print("NewsNotifier: detail API 호출 newsId=$newsId, query=$query");
    try {
      final detail = await _repository.getNewsDetail(newsId, query);
      print("detail 응답: ${detail['image_url']}");
      return detail;
    } catch (e) {
      print("detail API 에러: $e");
      rethrow;
    }
  }

  void clearSummary() {
    state = state.copyWith(lastSummary: null);
  }
}

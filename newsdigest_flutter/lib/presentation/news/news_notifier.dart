import 'dart:math';
import 'package:flutter/material.dart';
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

  Future<void> loadTrending({String? seedQuery}) async {
    final List<String> seeds = <String>[
      'AI',
      '테크',
      '경제',
      '금리',
      '증시',
      '산업',
      '정책',
    ];
    final String query =
        seedQuery ?? seeds[Random().nextInt(seeds.length)];
    await search(query);
  }

  Future<void> summarize(NewsItem item, {int maxSentences = 3}) async {
    debugPrint("summarize() 진입");
    try {
      // 상세 API 먼저 호출해서 본문 가져오기
      final detail = await _repository.getNewsDetail(
          item.id, item.title); // title을 query로 사용

      // 상세 본문 우선, 없으면 검색 요약 사용
      final String textToSummarize = detail['article_text'] ?? item.summary;
      await summarizeText(item.id, textToSummarize, maxSentences: maxSentences);
    } catch (e) {
      debugPrint("요약 에러: $e");
      final Set<int> updatedSummarizing =
          Set<int>.from(state.summarizingIds)..remove(item.id);
      state = state.copyWith(
        summarizingIds: updatedSummarizing,
        errorMessage: '요약 실패: $e',
      );
    }
  }

  Future<void> summarizeText(int newsId, String text,
      {int maxSentences = 3}) async {
    final Set<int> updatedSummarizing =
        Set<int>.from(state.summarizingIds)..add(newsId);
    final Map<int, String> updatedSummaries =
        Map<int, String>.from(state.summaries)..remove(newsId);
    state = state.copyWith(
      summarizingIds: updatedSummarizing,
      summaries: updatedSummaries,
      errorMessage: null,
    );

    if (text.trim().isEmpty) {
      updatedSummarizing.remove(newsId);
      updatedSummaries[newsId] = '';
      state = state.copyWith(
        summarizingIds: updatedSummarizing,
        summaries: updatedSummaries,
      );
      return;
    }

    try {
      debugPrint("요약 입력 길이: ${text.length}자");

      final String summary = await _repository.summarize(
        text: text,
        maxSentences: maxSentences,
      );

      final Set<int> doneSummarizing =
          Set<int>.from(state.summarizingIds)..remove(newsId);
      final Map<int, String> doneSummaries =
          Map<int, String>.from(state.summaries);
      doneSummaries[newsId] = summary;
      state = state.copyWith(
        summarizingIds: doneSummarizing,
        summaries: doneSummaries,
      );
    } catch (e) {
      debugPrint("요약 에러: $e");
      final Set<int> doneSummarizing =
          Set<int>.from(state.summarizingIds)..remove(newsId);
      state = state.copyWith(
        summarizingIds: doneSummarizing,
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

  void clearSummary(int newsId) {
    final Map<int, String> updatedSummaries =
        Map<int, String>.from(state.summaries)..remove(newsId);
    state = state.copyWith(summaries: updatedSummaries);
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/news_search_response.dart';

class NewsRepository {
  final http.Client _client;

  NewsRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<NewsSearchResponse> searchNews({
    required String query,
    int page = 1,
    int pageSize = 10,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/news/search');
    final http.Response resp = await _client.post(
      uri,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, Object>{
        'query': query,
        'page': page,
        'page_size': pageSize,
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception('뉴스 검색 실패: ${resp.statusCode} ${resp.body}');
    }

    final Map<String, dynamic> data =
        jsonDecode(resp.body) as Map<String, dynamic>;
    return NewsSearchResponse.fromJson(data);
  }

  Future<String> summarize({
    required String text,
    int maxSentences = 3,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/summarize');
    final http.Response resp = await _client.post(
      uri,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, Object>{
        'text': text,
        'max_sentences': maxSentences,
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception('요약 실패: ${resp.statusCode} ${resp.body}');
    }

    final Map<String, dynamic> data =
        jsonDecode(resp.body) as Map<String, dynamic>;
    return data['summary'] as String? ?? '';
  }
}

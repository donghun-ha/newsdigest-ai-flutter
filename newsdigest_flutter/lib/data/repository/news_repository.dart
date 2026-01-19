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
    final Uri uri = Uri.parse(
      '$baseUrl/summarize?max_sentences=$maxSentences',
    );

    final http.Response resp = await _client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'text/plain; charset=utf-8',
      },
      body: text,
    );

    if (resp.statusCode != 200) {
      throw Exception('요약 실패: ${resp.statusCode} ${resp.body}');
    }

    final Map<String, dynamic> data =
        jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;

    return data['summary'] as String? ?? '';
  }

  Future<Map<String, dynamic>> getNewsDetail(int newsId, String query) async {
    print("Repository: detail API 호출 newsId=$newsId, query=$query");
    final Uri uri = Uri.parse('$baseUrl/news/search/$newsId/detail')
        .replace(queryParameters: <String, String>{
      'query': query,
    });
    final http.Response resp = await _client.get(
      uri,
      headers: <String, String>{'Content-Type': 'application/json'},
    );
    if (resp.statusCode != 200) {
      throw Exception('뉴스 상세정보 조회 실패: ${resp.statusCode} ${resp.body}');
    }
    print("Response: detail 응답 성공: ${resp.body}");
    final Map<String, dynamic> data =
        jsonDecode(resp.body) as Map<String, dynamic>;
    return data;
  }

  Future<String?> fetchThumbnailForNews(String title) async {
    final Uri uri = Uri.parse('$baseUrl/news/images').replace(
        queryParameters: <String, String>{'query': title, 'count': '1'});

    final http.Response resp = await _client.get(uri);

    if (resp.statusCode != 200) {
      print("이미지 검색 실패: ${resp.statusCode} ${resp.body}");
      return null;
    }

    final Map<String, dynamic> data =
        jsonDecode(resp.body) as Map<String, dynamic>;
    final List images = data['images'] as List ?? [];
    if (images.isEmpty) return null;

    return images.first['thumbnail'] as String?;
  }
}

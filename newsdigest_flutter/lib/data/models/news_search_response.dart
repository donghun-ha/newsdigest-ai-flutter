import 'news_item.dart';

class NewsSearchResponse {
  final int total;
  final List<NewsItem> items;

  NewsSearchResponse({
    required this.total,
    required this.items,
  });

  factory NewsSearchResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> itemsJson =
        (json['items'] as List<dynamic>?) ?? <dynamic>[];
    final List<NewsItem> items = itemsJson
        .map((dynamic e) => NewsItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return NewsSearchResponse(
      total: json['total'] as int? ?? itemsJson.length,
      items: items,
    );
  }
}

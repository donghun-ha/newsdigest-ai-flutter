import 'news_item.dart';

class NewsSearchResponse {
  final int total;
  final List<NewsItem> items;

  NewsSearchResponse({
    required this.total,
    required this.items,
  });

  factory NewsSearchResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return NewsSearchResponse(
      total: json['total'] as int? ?? itemsJson.length,
      items: itemsJson
          .map((e) => NewsItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

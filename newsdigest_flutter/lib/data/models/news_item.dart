class NewsItem {
  final int id;
  final String title;
  final String summary;
  final String url;
  final String? publishedAt;
  final String? source;
  final String? imageUrl;

  NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.url,
    this.publishedAt,
    this.source,
    this.imageUrl,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      url: json['url'] as String? ?? '',
      publishedAt: json['published_at'] as String?,
      source: json['source'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
}

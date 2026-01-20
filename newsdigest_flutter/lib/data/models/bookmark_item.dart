class BookmarkItem {
  final String url;
  final int? newsId;
  final String title;
  final String summary;
  final String? publishedAt;
  final String? source;
  final String? imageUrl;
  final String? query;
  final int createdAt;

  BookmarkItem({
    required this.url,
    required this.title,
    required this.summary,
    required this.createdAt,
    this.newsId,
    this.publishedAt,
    this.source,
    this.imageUrl,
    this.query,
  });

  Map<String, dynamic> toDbMap() {
    return <String, dynamic>{
      'url': url,
      'news_id': newsId,
      'title': title,
      'summary': summary,
      'published_at': publishedAt,
      'source': source,
      'image_url': imageUrl,
      'query': query,
      'created_at': createdAt,
    };
  }

  factory BookmarkItem.fromDbMap(Map<String, dynamic> map) {
    return BookmarkItem(
      url: map['url'] as String? ?? '',
      newsId: map['news_id'] as int?,
      title: map['title'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      publishedAt: map['published_at'] as String?,
      source: map['source'] as String?,
      imageUrl: map['image_url'] as String?,
      query: map['query'] as String?,
      createdAt: map['created_at'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toUiMap() {
    return <String, dynamic>{
      'id': newsId,
      'title': title,
      'summary': summary,
      'image': imageUrl,
      'date': publishedAt ?? '',
      'url': url,
      'source': source,
      'query': query ?? '',
    };
  }
}

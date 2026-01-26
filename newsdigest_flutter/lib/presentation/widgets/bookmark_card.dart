import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsdigest_flutter/presentation/screens/newsdetail_screen.dart';
import 'package:newsdigest_flutter/data/models/bookmark_item.dart';

class BookmarkCard extends StatelessWidget {
  final BookmarkItem item;
  final VoidCallback? onRemove; // X 버튼 눌렀을때

  const BookmarkCard({
    super.key,
    required this.item,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Card(
      elevation: 0.5,
      color: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          final Map<String, dynamic> newsMap = item.toUiMap();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewsDetailScreen(
                news: newsMap,
                searchQuery: item.query ?? '',
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 뉴스 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl ?? '',
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) => Container(
                    height: 80,
                    width: 80,
                    color: scheme.surfaceContainerHighest,
                  ),
                  errorWidget:
                      (BuildContext context, String url, dynamic error) =>
                          Container(
                    height: 80,
                    width: 80,
                    color: scheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 뉴스 제목 및 요약
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 제목 + X 버튼 줄
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurface,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: onRemove, // 지금은 null 유지 가능
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // 날짜
                    Text(
                      item.publishedAt ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

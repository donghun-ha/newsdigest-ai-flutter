import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newsdigest_flutter/presentation/screens/news_webview_screen.dart';

class NewsCard extends StatelessWidget {
  final Map<String, dynamic> news;
  final VoidCallback? onTap;
  final VoidCallback? onToggleBookmark;
  final bool isBookmarked;
  final EdgeInsetsGeometry? margin;

  const NewsCard({
    super.key,
    required this.news,
    this.onTap,
    this.onToggleBookmark,
    this.isBookmarked = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = news['image'] as String?;
    final String? url = news['url'] as String?;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0.8,
        color: scheme.surface,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 전체 왼쪽 정렬
              children: <Widget>[
                // 뉴스 이미지
                if (imageUrl != null && imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (BuildContext context, String url) =>
                          Container(
                        height: 160,
                        color: scheme.surfaceContainerHighest,
                      ),
                      errorWidget:
                          (BuildContext context, String url, Object error) =>
                              Container(
                        height: 160,
                        color: scheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      color: scheme.onSurfaceVariant,
                      size: 40,
                    ),
                  ),

                const SizedBox(height: 12),

                // 제목
                Text(
                  news['title'],
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 6),

                // 요약(3줄)
                Text(
                  news['summary'],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),

                // 하단 영역: 원문 보기 링크 + 하트
                Row(
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        if (url == null || url.isEmpty) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                NewsWebViewScreen(url: url),
                          ),
                        );
                      },
                      child: Text(
                        '원문 보기',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        isBookmarked ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: scheme.primary,
                      ),
                      onPressed: () {
                        // 즐겨찾기 토글
                        onToggleBookmark?.call();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

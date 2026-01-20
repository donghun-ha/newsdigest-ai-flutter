import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsdigest_flutter/core/constants/colors.dart';
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
    return Card(
      elevation: 0.5,
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
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
                    color: AppColors.imagePlaceholder,
                  ),
                  errorWidget:
                      (BuildContext context, String url, dynamic error) =>
                          Container(
                    height: 80,
                    width: 80,
                    color: AppColors.imageError,
                    child: const Icon(
                      Icons.broken_image_outlined,
                      color: AppColors.textSecondary,
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
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: onRemove, // 지금은 null 유지 가능
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // 날짜
                    Text(
                      item.publishedAt ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
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

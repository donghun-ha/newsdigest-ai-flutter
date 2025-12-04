import 'package:flutter/material.dart';
import '/core/constants/colors.dart';
import '../widgets/bookmark_card.dart';
import 'home_screen.dart'; // dummyNews 재사용용

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 지금은 북마크 더미 데이터로 HomeScreen.dummyNews 재사용
    const List<Map<String, dynamic>> bookmarked = HomeScreen.dummyNews;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 상단 제목 + 전체 삭제
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '즐겨찾기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '전체 삭제',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: AppColors.border,
          ),
          const SizedBox(height: 12),

          // 리스트
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 4),
                itemCount: bookmarked.length,
                itemBuilder: (BuildContext context, int index) {
                  return BookmarkCard(
                    news: bookmarked[index],
                    onRemove: () {
                      // TODO: 나중에 즐겨찾기 제거 연동
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

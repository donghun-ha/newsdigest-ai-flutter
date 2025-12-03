import 'package:flutter/material.dart';
import '../widgets/news_card.dart';
import '/core/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  // 더미 뉴스 데이터
  static const List<Map<String, dynamic>> dummyNews = <Map<String, dynamic>>[
    <String, dynamic>{
      'title': '삼성전자, AI 칩 생산 확대…내년 2배 증설',
      'summary': '삼성전자가 미국 텍사스 공장에서 AI 칩 생산을 내년 2배로 늘린다고 발표. 엔비디아와 협력 강화.',
      'image':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=250&fit=crop',
      'date': '3시간 전',
    },
    <String, dynamic>{
      'title': '비트코인 10만달러 돌파…테슬라 재매수 루머',
      'summary': '비트코인이 2025년 최고가 10만달러 돌파. 일론 머스크 테슬라 재매수 루머 확산.',
      'image':
          'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=400&h=250&fit=crop',
      'date': '5시간 전',
    },
    <String, dynamic>{
      'title': '애플, M5 칩 공개…AI 성능 3배 향상',
      'summary': '애플이 M5 칩 공개, AI 처리 속도 3배 향상. iPhone 17에 탑재 예정.',
      'image':
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&h=250&fit=crop',
      'date': '7시간 전',
    },
    <String, dynamic>{
      'title': "카카오, AI 챗봇 '카카오 i' 출시",
      'summary': '카카오가 자체 AI 챗봇 \'카카오 i\' 출시. 네이버 클로바와 경쟁 격화.',
      'image':
          'https://images.unsplash.com/photo-1573164713988-8665fc963095?w=400&h=250&fit=crop',
      'date': '1일 전',
    },
    <String, dynamic>{
      'title': '테슬라, 로보택시 2026년 상용화 발표',
      'summary': '테슬라가 완전 자율주행 로보택시 2026년 상용화 발표. 주가 15% 급등.',
      'image':
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=250&fit=crop',
      'date': '2일 전',
    },
  ];

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 24, // 왼쪽 여백 크게
        title: const Text(
          'NewsDigest AI',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 검색창
                TextField(
                  decoration: InputDecoration(
                    hintText: 'AI, 테크, 경제 등 키워드 검색',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6), // 연한 회색 배경
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // "최근 검색어" 텍스트 (UI만, 기능 X)
                Text(
                  '최근 검색어',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Wrap(
                  spacing: 8,
                  children: <Widget>[
                    _SearchChip(label: '테크'),
                    _SearchChip(label: 'AI'),
                    _SearchChip(label: '금리'),
                    _SearchChip(label: '경제'),
                  ],
                ),
              ],
            ),
          ),

          // 뉴스 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: dummyNews.length,
              itemBuilder: (BuildContext context, int index) => NewsCard(
                news: dummyNews[index],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: '즐겨찾기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}

// 최근 검색어
class _SearchChip extends StatelessWidget {
  final String label;

  const _SearchChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      backgroundColor: const Color(0xFFE5F0FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

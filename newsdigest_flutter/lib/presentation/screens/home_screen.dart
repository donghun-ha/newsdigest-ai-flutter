import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsdigest_flutter/presentation/news/news_notifier.dart';
import 'package:newsdigest_flutter/presentation/news/news_state.dart';
import '../widgets/news_card.dart';
import '/core/constants/colors.dart';
import '../news/news_provider.dart'; // newsNotifierProvider import
import '../../data/models/news_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Riverpod 상태 & Notifier
    final NewsState state = ref.watch(newsNotifierProvider);
    final NewsNotifier notifier = ref.read(newsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 24,
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
                  controller: _searchController,
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
                    fillColor: const Color(0xFFF3F4F6),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (String value) {
                    notifier.search(value);
                  },
                ),
                const SizedBox(height: 16),

                // "최근 검색어" (일단 UI만 유지)
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

          if (state.isLoading) const LinearProgressIndicator(),

          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          // 뉴스 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: state.items.length,
              itemBuilder: (BuildContext context, int index) {
                final NewsItem item = state.items[index];

                // NewsCard 에 맞게 Map으로 변환 (일단 임시 매핑)
                final Map<String, dynamic> newsMap = <String, dynamic>{
                  'title': item.title,
                  'summary': item.summary,
                  'image': item.imageUrl, // 지금은 null 이라 placeholder 쓰게 해도 됨
                  'date': item.publishedAt ?? '', // pubDate 문자열
                };

                return GestureDetector(
                  onTap: () async {
                    print("🖱️ 카드 탭: ${item.title}"); // 로그

                    // detail 정보 먼저 가져오기
                    try {
                      final detail = await notifier.getNewsDetail(
                          item.id, _searchController.text);
                      print("detail 이미지: ${detail['image_url']}"); // 로그
                    } catch (e) {
                      print("detail 에러: $e");
                    }

                    await notifier.summarize(item);

                    final String? summary =
                        ref.read(newsNotifierProvider).lastSummary;
                    if (!mounted || summary == null) return;

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(child: Text(summary)),
                      ),
                    ).then((_) => notifier.clearSummary());
                  },
                  child: NewsCard(news: newsMap),
                );
              },
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

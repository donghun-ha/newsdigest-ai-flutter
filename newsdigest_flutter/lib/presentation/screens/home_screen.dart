import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsdigest_flutter/presentation/news/news_notifier.dart';
import 'package:newsdigest_flutter/presentation/news/news_state.dart';
import 'package:newsdigest_flutter/presentation/screens/newsdetail_screen.dart';
import 'package:newsdigest_flutter/presentation/bookmarks/bookmark_provider.dart';
import 'package:newsdigest_flutter/presentation/bookmarks/bookmark_notifier.dart';
import 'package:newsdigest_flutter/presentation/bookmarks/bookmark_state.dart';
import 'package:newsdigest_flutter/presentation/recent_search/recent_search_notifier.dart';
import 'package:newsdigest_flutter/presentation/recent_search/recent_search_provider.dart';
import 'package:newsdigest_flutter/presentation/recent_search/recent_search_state.dart';
import '../widgets/news_card.dart';
import '/core/constants/colors.dart';
import '../news/news_provider.dart'; // newsNotifierProvider import
import '../../data/models/news_item.dart';
import '../../data/models/bookmark_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _didLoadBookmarks = false;
  bool _didInitHome = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_didLoadBookmarks) {
        _didLoadBookmarks = true;
        ref.read(bookmarkNotifierProvider.notifier).loadBookmarks();
      }
      if (_didInitHome) return;
      _didInitHome = true;
      ref.read(recentSearchNotifierProvider.notifier).loadRecent();
      ref.read(newsNotifierProvider.notifier).loadTrending();
    });
  }

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
    final BookmarkState bookmarkState = ref.watch(bookmarkNotifierProvider);
    final BookmarkNotifier bookmarkNotifier =
        ref.read(bookmarkNotifierProvider.notifier);
    final RecentSearchState recentState =
        ref.watch(recentSearchNotifierProvider);
    final RecentSearchNotifier recentNotifier =
        ref.read(recentSearchNotifierProvider.notifier);

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
                    debugPrint("검색 submit: $value");
                    notifier.search(value);
                    recentNotifier.addSearch(value);
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
                if (recentState.items.isEmpty)
                  const Text(
                    '최근 검색어가 없습니다.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recentState.items.map((search) {
                      return _SearchChip(
                        label: search.term,
                        onTap: () {
                          _searchController.text = search.term;
                          notifier.search(search.term);
                        },
                        onDelete: () => recentNotifier.removeSearch(search.term),
                      );
                    }).toList(),
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
                debugPrint(
                  'HomeCard index=$index id=${item.id} title=${item.title} image=${item.imageUrl}',
                );

                // NewsCard 에 맞게 Map으로 변환 (일단 임시 매핑)
                final Map<String, dynamic> newsMap = <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'summary': item.summary,
                  'image': item.imageUrl, // 지금은 null 이라 placeholder 쓰게 해도 됨
                  'date': item.publishedAt ?? '', // pubDate 문자열
                  'url': item.url,
                  'source': item.source,
                  'query': _searchController.text,
                };
                final bool isBookmarked =
                    bookmarkState.bookmarkedUrls.contains(item.url);

                return GestureDetector(
                  onTap: () {
                    debugPrint(">>>>>카드 탭: ${item.title}"); // 로그

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => NewsDetailScreen(
                            news: newsMap,
                            searchQuery: _searchController.text,
                          ),
                        ));
                  },
                  child: NewsCard(
                    news: newsMap,
                    isBookmarked: isBookmarked,
                    onToggleBookmark: () {
                      final BookmarkItem bookmark = BookmarkItem(
                        url: item.url,
                        newsId: item.id,
                        title: item.title,
                        summary: item.summary,
                        publishedAt: item.publishedAt,
                        source: item.source,
                        imageUrl: item.imageUrl,
                        query: _searchController.text,
                        createdAt: DateTime.now().millisecondsSinceEpoch,
                      );
                      bookmarkNotifier.toggleBookmark(bookmark);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 최근 검색어
class _SearchChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const _SearchChip({
    required this.label,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
      onPressed: onTap,
      onDeleted: onDelete,
      deleteIcon: const Icon(
        Icons.close,
        size: 16,
        color: AppColors.textSecondary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      backgroundColor: const Color(0xFFE5F0FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

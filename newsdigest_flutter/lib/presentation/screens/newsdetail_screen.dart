import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsdigest_flutter/presentation/news/news_provider.dart';
import 'package:newsdigest_flutter/presentation/news/news_state.dart';
import '/core/constants/colors.dart';

class NewsDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> news;
  final String searchQuery;

  const NewsDetailScreen({
    super.key,
    required this.news,
    required this.searchQuery,
  });

  @override
  ConsumerState<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends ConsumerState<NewsDetailScreen> {
  Map<String, dynamic>? _detail;
  bool _isLoadingDetail = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetailAndSummary();
    });
  }

  Future<void> _loadDetailAndSummary() async {
    final int? newsId = widget.news['id'] as int?;
    final Object? summaryObj = widget.news['summary'];
    final String fallbackSummary = summaryObj is String ? summaryObj : '';
    final notifier = ref.read(newsNotifierProvider.notifier);

    setState(() {
      _isLoadingDetail = true;
    });

    try {
      if (newsId != null) {
        notifier.clearSummary(newsId);
        try {
          final detail = await notifier.getNewsDetail(
            newsId,
            widget.searchQuery,
          );
          if (!mounted) return;
          setState(() {
            _detail = detail;
          });

          final String textToSummarize =
              detail['article_text'] ?? fallbackSummary;
          await notifier.summarizeText(newsId, textToSummarize);
        } catch (_) {
          await notifier.summarizeText(newsId, fallbackSummary);
        }
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingDetail = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final NewsState state = ref.watch(newsNotifierProvider);
    final String? imageUrl = _detail?['image_url'] ?? widget.news['image'];
    final int? newsId = widget.news['id'] as int?;
    final bool isSummarizing =
        newsId != null && state.summarizingIds.contains(newsId);
    final String? summary =
        newsId != null ? state.summaries[newsId] : widget.news['summary'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '뉴스 상세정보',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 제목
            Text(
              widget.news['title'] ?? '',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            // 날짜
            Text(
              widget.news['date'] ?? '',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // 이미지 (있으면)
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            if (imageUrl != null) const SizedBox(height: 16),

            // 요약/본문 (지금은 summary 재사용)
            if (_isLoadingDetail || isSummarizing)
              const LinearProgressIndicator(),
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (_isLoadingDetail || isSummarizing)
              const SizedBox(height: 12),
            Text(
              (_isLoadingDetail || isSummarizing)
                  ? '요약을 불러오는 중입니다...'
                  : (summary ?? ''),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // 원문 보기 버튼 (지금은 onPressed 비워둠)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: 나중에 실제 기사 URL 열기
                },
                child: const Text(
                  '원문 보기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

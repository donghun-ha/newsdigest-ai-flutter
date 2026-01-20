import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:newsdigest_flutter/presentation/news/news_provider.dart';
import 'package:newsdigest_flutter/presentation/news/news_state.dart';
import 'package:newsdigest_flutter/presentation/screens/news_webview_screen.dart';
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
    final String title = widget.news['title'] ?? '';
    final String rawDate = widget.news['date'] ?? '';
    final String url = widget.news['url'] ?? '';
    final String formattedDate = _formatKoreanDate(rawDate);
    final List<String> summaryLines = _buildSummaryLines(
      isSummarizing ? '' : (summary ?? ''),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 제목
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 날짜
                  Row(
                    children: <Widget>[
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
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

                  // 요약 박스
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF5FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFD8E6FF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2F6BFF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'AI 요약',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        if (_isLoadingDetail || isSummarizing)
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: LinearProgressIndicator(),
                          ),
                        if (state.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 12),
                        ...summaryLines.map((String line) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  '•',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    line,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

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
                      onPressed: url.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NewsWebViewScreen(url: url),
                                ),
                              );
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
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.bookmark_border,
                        color: AppColors.textSecondary,
                      ),
                      label: const Text(
                        '북마크',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _buildSummaryLines(String text) {
    if (text.trim().isEmpty) {
      return <String>['요약을 불러오는 중입니다.'];
    }
    final List<String> rawParts = text
        .replaceAll('\r', '\n')
        .split(RegExp(r'[\n]+'))
        .map((String line) => line.trim())
        .where((String line) => line.isNotEmpty)
        .toList();
    final List<String> sentenceParts = <String>[];
    for (final String part in rawParts) {
      sentenceParts.addAll(
        part
            .split(RegExp(r'(?<=[\.\?\!])\s+'))
            .map((String s) => s.trim())
            .where((String s) => s.isNotEmpty),
      );
    }
    final List<String> filtered = <String>[];
    final Set<String> seen = <String>{};
    for (final String line in sentenceParts) {
      final String normalized = line.replaceAll(RegExp(r'\s+'), ' ');
      if (normalized.length < 8) continue;
      if (normalized.contains('NAVER') || normalized.contains('본문 바로가기')) {
        continue;
      }
      if (seen.add(normalized)) {
        filtered.add(normalized);
      }
      if (filtered.length >= 3) break;
    }
    if (filtered.isEmpty) {
      return <String>[text.trim()];
    }
    return filtered;
  }

  String _formatKoreanDate(String raw) {
    if (raw.trim().isEmpty) return raw;
    final RegExp rfcPattern = RegExp(
      r'^\w{3},\s(\d{1,2})\s(\w{3})\s(\d{4})\s(\d{2}):(\d{2})',
    );
    final Match? match = rfcPattern.firstMatch(raw);
    if (match != null) {
      final String day = match.group(1)!.padLeft(2, '0');
      final String mon = match.group(2)!.toLowerCase();
      final String year = match.group(3)!;
      final String hour = match.group(4)!;
      final String minute = match.group(5)!;
      final Map<String, String> months = <String, String>{
        'jan': '01',
        'feb': '02',
        'mar': '03',
        'apr': '04',
        'may': '05',
        'jun': '06',
        'jul': '07',
        'aug': '08',
        'sep': '09',
        'oct': '10',
        'nov': '11',
        'dec': '12',
      };
      final String month = months[mon] ?? '01';
      return '$year년 $month월 $day일 $hour:$minute';
    }

    final DateTime? parsed = DateTime.tryParse(raw);
    if (parsed != null) {
      return DateFormat('yyyy년 MM월 dd일 HH:mm', 'ko_KR').format(parsed);
    }
    return raw;
  }
}

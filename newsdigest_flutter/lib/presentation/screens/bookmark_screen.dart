import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsdigest_flutter/data/models/bookmark_item.dart';
import 'package:newsdigest_flutter/presentation/bookmarks/bookmark_notifier.dart';
import 'package:newsdigest_flutter/presentation/bookmarks/bookmark_provider.dart';
import 'package:newsdigest_flutter/presentation/bookmarks/bookmark_state.dart';
import '../widgets/bookmark_card.dart';

class BookmarkScreen extends ConsumerStatefulWidget {
  const BookmarkScreen({super.key});

  @override
  ConsumerState<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends ConsumerState<BookmarkScreen> {
  bool _didLoad = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didLoad) return;
      _didLoad = true;
      ref.read(bookmarkNotifierProvider.notifier).loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final BookmarkState state = ref.watch(bookmarkNotifierProvider);
    final BookmarkNotifier notifier =
        ref.read(bookmarkNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 상단 제목 + 전체 삭제
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '즐겨찾기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    GestureDetector(
                      onTap: state.items.isEmpty
                          ? null
                          : () async {
                              final bool confirmed =
                                  await _confirmClearAll(context);
                              if (confirmed) {
                                await notifier.clearAll();
                              }
                            },
                      child: Text(
                        '전체 삭제',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: state.items.isEmpty
                              ? scheme.onSurfaceVariant
                              : scheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: scheme.outlineVariant,
            ),
            const SizedBox(height: 12),

            // 리스트
            if (state.isLoading)
              const LinearProgressIndicator(),
            if (state.items.isEmpty && !state.isLoading)
              Expanded(
                child: Center(
                  child: Text(
                    '저장된 즐겨찾기가 없습니다.',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 4),
                    itemCount: state.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final BookmarkItem item = state.items[index];
                      return BookmarkCard(
                        item: item,
                        onRemove: () async {
                          final bool confirmed =
                              await _confirmRemove(context);
                          if (confirmed) {
                            await notifier.removeBookmark(item.url);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmClearAll(BuildContext context) async {
    return _showConfirmDialog(
      context,
      title: '전체 삭제',
      message: '모든 즐겨찾기를 삭제할까요?',
      confirmText: '삭제',
    );
  }

  Future<bool> _confirmRemove(BuildContext context) async {
    return _showConfirmDialog(
      context,
      title: '즐겨찾기 삭제',
      message: '이 항목을 삭제할까요?',
      confirmText: '삭제',
    );
  }

  Future<bool> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('취소'),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(confirmText),
                  ),
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      confirmText,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
      },
    );
    return result ?? false;
  }
}

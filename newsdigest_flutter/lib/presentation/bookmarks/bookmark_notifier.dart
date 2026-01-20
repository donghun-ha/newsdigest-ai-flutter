import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsdigest_flutter/data/models/bookmark_item.dart';
import 'package:newsdigest_flutter/data/repository/bookmark_repository.dart';

import 'bookmark_state.dart';

class BookmarkNotifier extends StateNotifier<BookmarkState> {
  final BookmarkRepository _repository;

  BookmarkNotifier(this._repository) : super(const BookmarkState());

  Future<void> loadBookmarks() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final List<BookmarkItem> items = await _repository.fetchBookmarks();
      final Set<String> urls = items.map((BookmarkItem item) => item.url).toSet();
      state = state.copyWith(
        items: items,
        bookmarkedUrls: urls,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '즐겨찾기 로딩 실패: $e',
      );
    }
  }

  bool isBookmarked(String url) {
    if (url.isEmpty) return false;
    return state.bookmarkedUrls.contains(url);
  }

  Future<void> addBookmark(BookmarkItem item) async {
    if (item.url.isEmpty) return;
    await _repository.saveBookmark(item);
    final List<BookmarkItem> updated =
        List<BookmarkItem>.from(state.items);
    updated.removeWhere((BookmarkItem existing) => existing.url == item.url);
    updated.insert(0, item);
    final Set<String> urls = Set<String>.from(state.bookmarkedUrls)
      ..add(item.url);
    state = state.copyWith(items: updated, bookmarkedUrls: urls);
  }

  Future<void> removeBookmark(String url) async {
    if (url.isEmpty) return;
    await _repository.removeBookmark(url);
    final List<BookmarkItem> updated =
        state.items.where((BookmarkItem item) => item.url != url).toList();
    final Set<String> urls = Set<String>.from(state.bookmarkedUrls)..remove(url);
    state = state.copyWith(items: updated, bookmarkedUrls: urls);
  }

  Future<void> toggleBookmark(BookmarkItem item) async {
    if (isBookmarked(item.url)) {
      await removeBookmark(item.url);
    } else {
      await addBookmark(item);
    }
  }

  Future<void> clearAll() async {
    await _repository.clearBookmarks();
    state = state.copyWith(
      items: const <BookmarkItem>[],
      bookmarkedUrls: const <String>{},
    );
  }
}

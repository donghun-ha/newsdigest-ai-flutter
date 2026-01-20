import 'package:newsdigest_flutter/data/models/bookmark_item.dart';

class BookmarkState {
  final List<BookmarkItem> items;
  final Set<String> bookmarkedUrls;
  final bool isLoading;
  final String? errorMessage;

  const BookmarkState({
    this.items = const <BookmarkItem>[],
    this.bookmarkedUrls = const <String>{},
    this.isLoading = false,
    this.errorMessage,
  });

  BookmarkState copyWith({
    List<BookmarkItem>? items,
    Set<String>? bookmarkedUrls,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BookmarkState(
      items: items ?? this.items,
      bookmarkedUrls: bookmarkedUrls ?? this.bookmarkedUrls,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

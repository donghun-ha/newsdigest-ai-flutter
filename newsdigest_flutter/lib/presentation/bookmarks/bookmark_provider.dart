import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsdigest_flutter/data/repository/bookmark_repository.dart';

import 'bookmark_notifier.dart';
import 'bookmark_state.dart';

final Provider<BookmarkRepository> bookmarkRepositoryProvider =
    Provider<BookmarkRepository>((Ref ref) {
  return BookmarkRepository();
});

final StateNotifierProvider<BookmarkNotifier, BookmarkState>
    bookmarkNotifierProvider =
    StateNotifierProvider<BookmarkNotifier, BookmarkState>((Ref ref) {
  final BookmarkRepository repository = ref.watch(bookmarkRepositoryProvider);
  return BookmarkNotifier(repository);
});

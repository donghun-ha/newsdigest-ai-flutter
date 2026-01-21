class RecentSearch {
  final String term;
  final int createdAt;

  RecentSearch({
    required this.term,
    required this.createdAt,
  });

  Map<String, dynamic> toDbMap() {
    return <String, dynamic>{
      'term': term,
      'created_at': createdAt,
    };
  }

  factory RecentSearch.fromDbMap(Map<String, dynamic> map) {
    return RecentSearch(
      term: map['term'] as String? ?? '',
      createdAt: map['created_at'] as int? ?? 0,
    );
  }
}

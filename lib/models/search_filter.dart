import '../constants/languages.dart';
import '../constants/sortings.dart';

class SearchFilter {
  SearchFilter({
    this.searchTerm,
    this.from,
    this.to,
    this.sortings,
    this.pageLength,
    this.language,
  });

  final String searchTerm;
  final DateTime from;
  final DateTime to;
  final Sortings sortings;
  final int pageLength;
  final Languages language;

  SearchFilter copyWith({
    String searchTerm,
    DateTime from,
    DateTime to,
    Sortings sortings,
    int pageLength,
    Languages language,
  }) =>
      SearchFilter(
        searchTerm: searchTerm ?? this.searchTerm,
        from: from ?? this.from,
        to: to ?? this.to,
        sortings: sortings ?? this.sortings,
        pageLength: pageLength ?? this.pageLength,
        language: language ?? this.language,
      );
}

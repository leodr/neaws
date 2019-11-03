import 'package:neaws/constants/languages.dart';
import 'package:neaws/constants/sortings.dart';

class SearchFilter {
  final String searchTerm;
  final DateTime from;
  final DateTime to;
  final Sortings sortings;
  final int pageLength;
  final Languages language;

  SearchFilter({
    this.searchTerm,
    this.from,
    this.to,
    this.sortings,
    this.pageLength,
    this.language,
  });

  SearchFilter copyWith({
    searchTerm,
    from,
    to,
    sortings,
    pageLength,
    language,
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

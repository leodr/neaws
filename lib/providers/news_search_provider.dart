import 'package:flutter/foundation.dart';
import 'package:neaws/api/news_api.dart';
import 'package:neaws/constants/api_key.dart';
import 'package:neaws/constants/languages.dart';
import 'package:neaws/constants/sortings.dart';
import 'package:neaws/models/search_filter.dart';

import '../main.dart';

class NewsSearchProvider with ChangeNotifier {
  final NewsApi api;

  List _searchList = [];
  SearchFilter _searchFilter = SearchFilter();

  NewsSearchProvider(this.api);

  get searchList => _searchList;
  SearchFilter get searchFilter => _searchFilter;

  set searchList(List newList) {
    _searchList = newList;
    notifyListeners();
  }

  set searchFilter(SearchFilter newFilter) {
    _searchFilter = newFilter;
    notifyListeners();
  }

  Future updateSearchList(
    String q, {
    Languages language,
    Sortings sortBy,
    DateTime from,
    DateTime to,
    int pageSize,
  }) async {
    final list = await fetchAPIData(
      buildEverythingRequest(
        searchTerm: q,
        language: language ?? Languages.en,
        sortBy: sortBy ?? Sortings.relevancy,
        from: from,
        to: to,
        pageSize: pageSize,
        apiKey: API_KEY,
      ),
    );

    searchList = list ?? [];
    return;
  }

  updateSearchFilter({
    searchTerm,
    from,
    to,
    sortings,
    pageLength,
    language,
  }) {
    searchFilter = searchFilter.copyWith(
      searchTerm: searchTerm,
      from: from,
      to: to,
      sortings: sortings,
      pageLength: pageLength,
      language: language,
    );
  }
}

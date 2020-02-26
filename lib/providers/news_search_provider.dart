import 'package:flutter/foundation.dart';
import 'package:neaws/api/models/article.dart';
import 'package:neaws/api/models/articles_response.dart';
import 'package:neaws/api/news_api.dart';
import 'package:neaws/constants/languages.dart';
import 'package:neaws/constants/sortings.dart';
import 'package:neaws/models/search_filter.dart';

class NewsSearchProvider with ChangeNotifier {
  NewsSearchProvider({this.api});

  final NewsApi api;

  List<Article> _searchList = <Article>[];
  SearchFilter _searchFilter = SearchFilter(
    from: DateTime.now(),
    language: Languages.en,
    pageLength: 20,
    sortings: Sortings.relevancy,
    to: DateTime.now().add(
      const Duration(days: 30),
    ),
  );

  List<Article> get searchList => _searchList;
  SearchFilter get searchFilter => _searchFilter;

  set searchList(List<Article> newList) {
    _searchList = newList;
    notifyListeners();
  }

  set searchFilter(SearchFilter newFilter) {
    _searchFilter = newFilter;
    notifyListeners();
  }

  Future<void> updateSearchList(
    String q, {
    Languages language,
    Sortings sortBy,
    DateTime from,
    DateTime to,
    int pageSize,
  }) async {
    final ArticlesResponse list = await api.getEverything(
      q: q,
      language: language ?? Languages.en,
      sortBy: sortBy ?? Sortings.relevancy,
      from: from,
      to: to,
      pageSize: pageSize,
    );

    searchList = list.articles ?? <Article>[];
    return;
  }

  void updateSearchFilter({
    String searchTerm,
    DateTime from,
    DateTime to,
    Sortings sortings,
    int pageLength,
    Languages language,
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

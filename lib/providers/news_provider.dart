import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/models/article.dart';
import '../api/models/articles_response.dart';
import '../api/models/source.dart';
import '../api/models/sources_response.dart';
import '../api/news_api.dart';
import '../constants/categories.dart';
import '../constants/countries.dart';
import '../constants/languages.dart';

class NewsProvider with ChangeNotifier {
  NewsProvider({this.api});

  final NewsApi api;

  List<Article> _listItems = <Article>[],
      _businessNews = <Article>[],
      _entertainmentNews = <Article>[],
      _generalNews = <Article>[],
      _healthNews = <Article>[],
      _scienceNews = <Article>[],
      _sportsNews = <Article>[],
      _technologyNews = <Article>[],
      _savedItems = <Article>[];

  List<Source> _sourcesList = <Source>[];

  List<Article> get listItems => _listItems;
  List<Article> get businessNews => _businessNews;
  List<Article> get entertainmentNews => _entertainmentNews;
  List<Article> get generalNews => _generalNews;
  List<Article> get healthNews => _healthNews;
  List<Article> get scienceNews => _scienceNews;
  List<Article> get sportsNews => _sportsNews;
  List<Article> get technologyNews => _technologyNews;
  List<Article> get savedItems => _savedItems;

  List<Source> get sourcesList => _sourcesList;

  set listItems(List<Article> newList) {
    _listItems = newList;
    notifyListeners();
  }

  set businessNews(List<Article> newList) {
    _businessNews = newList;
    notifyListeners();
  }

  set entertainmentNews(List<Article> newList) {
    _entertainmentNews = newList;
    notifyListeners();
  }

  set generalNews(List<Article> newList) {
    _generalNews = newList;
    notifyListeners();
  }

  set healthNews(List<Article> newList) {
    _healthNews = newList;
    notifyListeners();
  }

  set scienceNews(List<Article> newList) {
    _scienceNews = newList;
    notifyListeners();
  }

  set sportsNews(List<Article> newList) {
    _sportsNews = newList;
    notifyListeners();
  }

  set technologyNews(List<Article> newList) {
    _technologyNews = newList;
    notifyListeners();
  }

  set sourcesList(List<Source> newList) {
    _sourcesList = newList;
    notifyListeners();
  }

  set savedItems(List<Article> newList) {
    _savedItems = newList;
    notifyListeners();
  }

  Future<void> updateList({Categories category}) async {
    final ArticlesResponse list =
        await api.getHeadlines(country: Countries.gb, category: category);

    switch (category) {
      case Categories.business:
        businessNews = list.articles;
        return;
      case Categories.entertainment:
        entertainmentNews = list.articles;
        return;
      case Categories.general:
        generalNews = list.articles;
        return;
      case Categories.health:
        healthNews = list.articles;
        return;
      case Categories.science:
        scienceNews = list.articles;
        return;
      case Categories.sports:
        sportsNews = list.articles;
        return;
      case Categories.technology:
        technologyNews = list.articles;
        return;
      default:
        listItems = list.articles;
        return;
    }
  }

  Future<void> updateSavedList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> savedList = prefs.getStringList('saved') ?? <String>[];

    savedItems = savedList
        .map<Article>((String e) => Article.fromJSON(jsonDecode(e)))
        .toList();
    return;
  }

  Future<void> updateSourcesList() async {
    final SourcesResponse list =
        await api.getSources(country: Countries.gb, language: Languages.en);

    sourcesList = list.sources;
    return;
  }
}

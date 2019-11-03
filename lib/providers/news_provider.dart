import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:neaws/api/news_api.dart';
import 'package:neaws/constants/api_key.dart';
import 'package:neaws/constants/categories.dart';
import 'package:neaws/constants/countries.dart';
import 'package:neaws/constants/languages.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class NewsProvider with ChangeNotifier {
  final NewsApi api;

  List _listItems = [],
      _businessNews = [],
      _entertainmentNews = [],
      _generalNews = [],
      _healthNews = [],
      _scienceNews = [],
      _sportsNews = [],
      _technologyNews = [],
      _sourcesList = [],
      _savedItems = [];

  NewsProvider({this.api});

  get listItems => _listItems;
  get businessNews => _businessNews;
  get entertainmentNews => _entertainmentNews;
  get generalNews => _generalNews;
  get healthNews => _healthNews;
  get scienceNews => _scienceNews;
  get sportsNews => _sportsNews;
  get technologyNews => _technologyNews;
  get sourcesList => _sourcesList;
  get savedItems => _savedItems;

  set listItems(List newList) {
    _listItems = newList;
    notifyListeners();
  }

  set businessNews(List newList) {
    _businessNews = newList;
    notifyListeners();
  }

  set entertainmentNews(List newList) {
    _entertainmentNews = newList;
    notifyListeners();
  }

  set generalNews(List newList) {
    _generalNews = newList;
    notifyListeners();
  }

  set healthNews(List newList) {
    _healthNews = newList;
    notifyListeners();
  }

  set scienceNews(List newList) {
    _scienceNews = newList;
    notifyListeners();
  }

  set sportsNews(List newList) {
    _sportsNews = newList;
    notifyListeners();
  }

  set technologyNews(List newList) {
    _technologyNews = newList;
    notifyListeners();
  }

  set sourcesList(List newList) {
    _sourcesList = newList;
    notifyListeners();
  }

  set savedItems(List newList) {
    _savedItems = newList;
    notifyListeners();
  }

  Future updateList({Categories category}) async {
    final list = await fetchAPIData(buildHeadlineRequest(
      countryCode: Countries.gb,
      category: category,
      apiKey: API_KEY,
    ));

    switch (category) {
      case Categories.business:
        businessNews = list;
        return;
      case Categories.entertainment:
        entertainmentNews = list;
        return;
      case Categories.general:
        generalNews = list;
        return;
      case Categories.health:
        healthNews = list;
        return;
      case Categories.science:
        scienceNews = list;
        return;
      case Categories.sports:
        sportsNews = list;
        return;
      case Categories.technology:
        technologyNews = list;
        return;
      default:
        listItems = list;
        return;
    }
  }

  Future updateSavedList() async {
    final prefs = await SharedPreferences.getInstance();
    final List savedList = prefs.getStringList("saved") ?? [];

    savedItems = savedList.map((e) => json.decode(e)).toList();
    return;
  }

  Future updateSourcesList() async {
    final list = await fetchSourceData(buildSourcesRequest(
      country: Countries.gb,
      language: Languages.en,
      apiKey: API_KEY,
    ));

    sourcesList = list;
    return;
  }
}

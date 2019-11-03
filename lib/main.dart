import "dart:async";
import "dart:convert";

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';
import "package:shared_preferences/shared_preferences.dart";
import "package:simple_design/simple_design.dart";

import 'app.dart';
import 'providers/theme_provider.dart';
import 'ui/pages/settings_page.dart';

void main() => runApp(App());

Future<List<Widget>> fetchSourceData(String url) async {
  var response = await http.get(url);
  var data = json.decode(response.body);

  List<Widget> widgetList = [];
  for (int i = 0; i < data["sources"].length; i++) {
    widgetList.add(SourcesItem(
      source: data["sources"][i],
      apiKey: API_KEY,
    ));
  }
  return widgetList;
}

String buildHeadlineRequest(
    {Countries countryCode,
    Categories category,
    String searchTerm,
    int pageSize,
    int page,
    @required String apiKey}) {
  String url = "https://newsapi.org/v2/top-headlines?";

  if (countryCode != null)
    url += ("country=" +
        countryCode.toString().replaceAll("Countries.", "") +
        "&");
  if (category != null)
    url +=
        ("category=" + category.toString().replaceAll("Categories.", "") + "&");
  if (searchTerm != null) url += ("q=" + searchTerm + "&");
  if (pageSize != null) url += ("pageSize=" + pageSize.toString() + "&");
  if (page != null) url += ("page=" + page.toString() + "&");

  return url += ("apiKey=" + apiKey);
}

String buildEverythingRequest(
    {String searchTerm,
    String sourcesIDs,
    String domains,
    DateTime from,
    DateTime to,
    Languages language,
    Sortings sortBy,
    int pageSize,
    int page,
    @required String apiKey}) {
  String url = "https://newsapi.org/v2/everything?";

  if (searchTerm != null) url += ("q=" + searchTerm + "&");
  if (sourcesIDs != null) url += ("sources=" + sourcesIDs + "&");
  if (domains != null) url += ("domains=" + domains + "&");
  if (from != null) url += ("from=" + from.toIso8601String() + "&");
  if (to != null) url += ("to=" + to.toIso8601String() + "&");
  if (language != null)
    url +=
        ("language=" + language.toString().replaceAll("Languages.", "") + "&");
  if (sortBy != null)
    url += ("sortBy=" + sortBy.toString().replaceAll("Sortings.", "") + "&");
  if (pageSize != null) url += ("pageSize=" + pageSize.toString() + "&");
  if (page != null) url += ("page=" + page.toString() + "&");

  return url += ("apiKey=" + apiKey);
}

String buildSourcesRequest(
    {Categories category,
    Languages language,
    Countries country,
    @required String apiKey}) {
  String url = "https://newsapi.org/v2/sources?";

  if (category != null)
    url +=
        ("category=" + category.toString().replaceAll("Categories.", "") + "&");
  if (language != null)
    url +=
        ("language=" + language.toString().replaceAll("Languages.", "") + "&");
  if (country != null)
    url += ("country=" + country.toString().replaceAll("Countries.", "") + "&");

  return url += ("apiKey=" + apiKey);
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_news_app/custom_items/list_item.dart';
import 'package:flutter_news_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:simple_design/simple_design.dart';

class SourcePage extends StatefulWidget {
  final Map source;
  final String apiKey;

  SourcePage({this.source, this.apiKey});

  @override
  _SourcePageState createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {
  List articles = [];

  Future<List> fetchAPIData(String url) async {
    var response = await http.get(url);
    var data = json.decode(response.body);

    return data["articles"];
  }

  Future<Null> updateSourceList() async {
    await fetchAPIData(buildEverythingRequest(
            language: Languages.en,
            sourcesIDs: widget.source["id"],
            sortBy: Sortings.popularity,
            apiKey: widget.apiKey))
        .then((list) {
      setState(() {
        articles = list;
      });
    });
    return null;
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
      url += ("language=" +
          language.toString().replaceAll("Languages.", "") +
          "&");
    if (sortBy != null)
      url += ("sortBy=" + sortBy.toString().replaceAll("Sortings.", "") + "&");
    if (pageSize != null) url += ("pageSize=" + pageSize.toString() + "&");
    if (page != null) url += ("page=" + page.toString() + "&");

    return url += ("apiKey=" + apiKey);
  }

  @override
  void initState() {
    updateSourceList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      backgroundColor: Theme.of(context).backgroundColor,
      onRefresh: () async {
        await updateSourceList();
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SDSliverAppBar(
            title: RichText(
                text: TextSpan(
                    text: "Articles from: ",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontWeight: FontWeight.normal),
                    children: [
                  TextSpan(
                      text: widget.source["name"],
                      style: Theme.of(context).textTheme.title)
                ])),
          ),
          articles.length < 1
              ? SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, i) => ListItem(articles[i]),
                      childCount: articles.length),
                )
        ],
      ),
    ));
  }
}

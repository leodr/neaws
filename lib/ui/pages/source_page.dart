import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neaws/api/models/article.dart';
import 'package:neaws/api/models/articles_response.dart';
import 'package:neaws/api/models/source.dart';
import 'package:neaws/constants/languages.dart';
import 'package:neaws/constants/sortings.dart';
import 'package:neaws/providers/news_api_provider.dart';
import 'package:neaws/ui/widgets/list_item.dart';
import 'package:provider/provider.dart';
import 'package:simple_design/simple_design.dart';

class SourcePage extends StatefulWidget {
  const SourcePage({this.source, this.apiKey});

  final Source source;
  final String apiKey;

  @override
  _SourcePageState createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {
  List<Article> articles = <Article>[];

  Future<void> updateSourceList() async {
    final ArticlesResponse articlesResponse =
        await Provider.of<NewsApiProvider>(context).newsApi.getEverything(
              language: Languages.en,
              sources: <String>[widget.source.id],
              sortBy: Sortings.popularity,
            );

    setState(() {
      articles = articlesResponse.articles;
    });

    return;
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
    String url = 'https://newsapi.org/v2/everything?';

    if (searchTerm != null) {
      url += 'q=$searchTerm&';
    }
    if (sourcesIDs != null) {
      url += 'sources=$sourcesIDs&';
    }
    if (domains != null) {
      url += 'domains=$domains&';
    }
    if (from != null) {
      url += 'from=${from.toIso8601String()}&';
    }
    if (to != null) {
      url += 'to=${to.toIso8601String()}&';
    }
    if (language != null) {
      url += 'language=${language.toString().replaceAll("Languages.", "")}&';
    }
    if (sortBy != null) {
      url += 'sortBy=${sortBy.toString().replaceAll("Sortings.", "")}&';
    }
    if (pageSize != null) {
      url += 'pageSize=${pageSize.toString()}&';
    }
    if (page != null) {
      url += 'page=${page.toString()}&';
    }

    return url += 'apiKey=$apiKey';
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
                    text: 'Articles from: ',
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontWeight: FontWeight.normal),
                    children: <TextSpan>[
                  TextSpan(
                      text: widget.source.name,
                      style: Theme.of(context).textTheme.title)
                ])),
          ),
          articles.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: const CircularProgressIndicator(),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int i) => ListItem(articles[i]),
                      childCount: articles.length),
                )
        ],
      ),
    ));
  }
}

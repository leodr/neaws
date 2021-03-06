import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/models/article.dart';
import '../../providers/news_search_provider.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/list_item.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<NewsSearchProvider>(
          builder: (
            BuildContext context,
            NewsSearchProvider newsSearchProvider,
            _,
          ) {
            final ThemeData theme = Theme.of(context);

            final List<Article> searchList = newsSearchProvider.searchList;

            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  leading: const CustomBackButton(),
                  floating: true,
                  title: TextField(
                    onSubmitted: (String q) =>
                        newsSearchProvider.updateSearchList(q),
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                    ),
                  ),
                  backgroundColor: theme.scaffoldBackgroundColor,
                  elevation: 2.0,
                  forceElevated: true,
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(EvaIcons.funnelOutline),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/searchfilter',
                        );
                      },
                    ),
                  ],
                ),
                if (searchList.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Tap the textfield to search.',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int i) => ListItem(searchList[i]),
                      childCount: searchList.length,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

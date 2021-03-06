import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_design/simple_design.dart';

import '../../../api/models/article.dart';
import '../../../providers/news_provider.dart';
import '../../widgets/list_item.dart';
import '../../widgets/search_button.dart';
import '../../widgets/settings_button.dart';

class HeadlinesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (
        BuildContext context,
        NewsProvider newsProvider,
        _,
      ) {
        final ThemeData theme = Theme.of(context);
        final List<Article> listItems = newsProvider.listItems;

        return RefreshIndicator(
          backgroundColor: theme.backgroundColor,
          key: const Key('firstPage'),
          displacement: kToolbarHeight,
          onRefresh: () => newsProvider.updateList(),
          child: CustomScrollView(
            slivers: <Widget>[
              SDSliverAppBar(
                leading: SearchButton(),
                title: Text.rich(
                  TextSpan(
                    text: 'Neaws ',
                    style: theme.textTheme.headline6,
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'Headlines',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  SettingsButton(),
                ],
              ),
              if (listItems.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int i) => ListItem(
                      listItems[i],
                      onSaved: newsProvider.updateSavedList,
                    ),
                    childCount: listItems.length,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

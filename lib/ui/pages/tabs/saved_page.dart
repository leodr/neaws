import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_design/simple_design.dart';

import '../../../api/models/article.dart';
import '../../../providers/news_provider.dart';
import '../../widgets/list_item.dart';
import '../../widgets/search_button.dart';
import '../../widgets/settings_button.dart';

class SavedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (
        BuildContext context,
        NewsProvider newsProvider,
        _,
      ) {
        final ThemeData theme = Theme.of(context);

        final List<Article> savedItems = newsProvider.savedItems;

        return RefreshIndicator(
          key: const Key('thirdPage'),
          onRefresh: newsProvider.updateSavedList,
          child: CustomScrollView(
            slivers: <Widget>[
              SDSliverAppBar(
                leading: SearchButton(),
                title: RichText(
                  text: TextSpan(
                    text: 'Neaws ',
                    style: theme.textTheme.headline6,
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'Saved',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  SettingsButton(),
                ],
              ),
              if (savedItems.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'You have not saved any articles yet.',
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int i) => Dismissible(
                      background: Container(
                        color: Theme.of(context).errorColor,
                      ),
                      key: Key(i.toString()),
                      onDismissed: (_) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        prefs.setStringList(
                          'saved',
                          prefs.getStringList('saved')..removeAt(i),
                        );
                        newsProvider.updateSavedList();
                      },
                      child: ListItem(savedItems[i]),
                    ),
                    childCount: savedItems.length,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

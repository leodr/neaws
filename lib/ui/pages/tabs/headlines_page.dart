import 'package:flutter/material.dart';
import 'package:neaws/providers/news_provider.dart';
import 'package:neaws/ui/widgets/list_item.dart';
import 'package:neaws/ui/widgets/search_button.dart';
import 'package:neaws/ui/widgets/settings_button.dart';
import 'package:provider/provider.dart';
import 'package:simple_design/simple_design.dart';

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
        final listItems = newsProvider.listItems;

        return RefreshIndicator(
          backgroundColor: theme.backgroundColor,
          key: Key("firstPage"),
          displacement: kToolbarHeight,
          onRefresh: () => newsProvider.updateList(),
          child: CustomScrollView(
            slivers: <Widget>[
              SDSliverAppBar(
                leading: SearchButton(),
                title: Text.rich(
                  TextSpan(
                    text: "Neaws ",
                    style: theme.textTheme.title,
                    children: [
                      TextSpan(
                        text: "Headlines",
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
              listItems.length < 1
                  ? SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => ListItem(
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

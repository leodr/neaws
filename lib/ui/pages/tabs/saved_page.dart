import 'package:flutter/material.dart';
import 'package:neaws/providers/news_provider.dart';
import 'package:neaws/ui/widgets/list_item.dart';
import 'package:neaws/ui/widgets/search_button.dart';
import 'package:neaws/ui/widgets/settings_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_design/simple_design.dart';

class SavedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (
        BuildContext context,
        NewsProvider newsProvider,
        _,
      ) {
        final theme = Theme.of(context);

        final savedItems = newsProvider.savedItems;

        return RefreshIndicator(
          key: Key("thirdPage"),
          onRefresh: newsProvider.updateSavedList,
          child: CustomScrollView(
            slivers: <Widget>[
              SDSliverAppBar(
                leading: SearchButton(),
                title: RichText(
                  text: TextSpan(
                    text: "Neaws ",
                    style: theme.textTheme.title,
                    children: [
                      TextSpan(
                        text: "Saved",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  SettingsButton(),
                ],
              ),
              savedItems.length < 1
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(
                          "You have not saved any articles yet.",
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => Dismissible(
                          background: Container(
                            color: Theme.of(context).errorColor,
                          ),
                          key: Key(i.toString()),
                          child: ListItem(savedItems[i]),
                          onDismissed: (_) async {
                            final prefs = await SharedPreferences.getInstance();

                            prefs.setStringList(
                              "saved",
                              prefs.getStringList("saved")..removeAt(i),
                            );
                            newsProvider.updateSavedList();
                          },
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

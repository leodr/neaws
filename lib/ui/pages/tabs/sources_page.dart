import 'package:flutter/material.dart';
import 'package:neaws/providers/news_provider.dart';
import 'package:neaws/ui/widgets/search_button.dart';
import 'package:neaws/ui/widgets/settings_button.dart';
import 'package:neaws/ui/widgets/sources_item.dart';
import 'package:provider/provider.dart';
import 'package:simple_design/simple_design.dart';

class SourcesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (
        BuildContext context,
        NewsProvider newsProvider,
        _,
      ) {
        final ThemeData theme = Theme.of(context);

        return RefreshIndicator(
          onRefresh: newsProvider.updateSourcesList,
          child: CustomScrollView(
            key: const Key('fourthPage'),
            slivers: <Widget>[
              SDSliverAppBar(
                leading: SearchButton(),
                title: Text.rich(
                  TextSpan(
                    text: 'Neaws ',
                    style: theme.textTheme.title,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sources',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[SettingsButton()],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int i) => SourcesItem(
                    source: newsProvider.sourcesList[i],
                  ),
                  childCount: newsProvider.sourcesList.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

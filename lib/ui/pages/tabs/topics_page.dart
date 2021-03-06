import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_design/simple_design.dart';

import '../../../constants/categories.dart';
import '../../../providers/news_provider.dart';
import '../../widgets/search_button.dart';
import '../../widgets/settings_button.dart';
import '../../widgets/topic_list.dart';

class TopicsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (
        BuildContext context,
        NewsProvider newsProvider,
        _,
      ) {
        final ThemeData theme = Theme.of(context);

        final Future<void> Function({Categories category}) updateList =
            newsProvider.updateList;
        final Future<void> Function() updateSavedList =
            newsProvider.updateSavedList;

        return DefaultTabController(
          length: Categories.values.length,
          child: NestedScrollView(
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) =>
                <Widget>[
              SDSliverAppBar(
                leading: SearchButton(),
                title: Text.rich(
                  TextSpan(
                    text: 'Neaws ',
                    style: theme.textTheme.headline6,
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'Topics',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  ),
                ),
                pinned: false,
                floating: true,
                snap: true,
                actions: <Widget>[
                  SettingsButton(),
                ],
                bottom: const TabBar(
                  isScrollable: true,
                  tabs: <Tab>[
                    Tab(
                      text: 'Business',
                      icon: Icon(EvaIcons.briefcaseOutline),
                    ),
                    Tab(
                      text: 'Entertainment',
                      icon: Icon(EvaIcons.tvOutline),
                    ),
                    Tab(
                      text: 'General',
                      icon: Icon(EvaIcons.peopleOutline),
                    ),
                    Tab(
                      text: 'Health',
                      icon: Icon(EvaIcons.activityOutline),
                    ),
                    Tab(
                      text: 'Science',
                      icon: Icon(EvaIcons.bulbOutline),
                    ),
                    Tab(
                      text: 'Sports',
                      icon: Icon(EvaIcons.globeOutline),
                    ),
                    Tab(
                      text: 'Technology',
                      icon: Icon(EvaIcons.radioOutline),
                    ),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              children: <Widget>[
                TopicList(
                  onUpdate: updateList,
                  category: Categories.business,
                  articleList: newsProvider.businessNews,
                  onSaved: updateSavedList,
                ),
                TopicList(
                  onUpdate: updateList,
                  category: Categories.entertainment,
                  articleList: newsProvider.entertainmentNews,
                  onSaved: updateSavedList,
                ),
                TopicList(
                  onUpdate: updateList,
                  category: Categories.general,
                  articleList: newsProvider.generalNews,
                  onSaved: updateSavedList,
                ),
                TopicList(
                  onUpdate: updateList,
                  category: Categories.health,
                  articleList: newsProvider.healthNews,
                  onSaved: updateSavedList,
                ),
                TopicList(
                  onUpdate: updateList,
                  category: Categories.science,
                  articleList: newsProvider.scienceNews,
                  onSaved: updateSavedList,
                ),
                TopicList(
                  onUpdate: updateList,
                  category: Categories.sports,
                  articleList: newsProvider.sportsNews,
                  onSaved: updateSavedList,
                ),
                TopicList(
                  onUpdate: updateList,
                  category: Categories.technology,
                  articleList: newsProvider.technologyNews,
                  onSaved: updateSavedList,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

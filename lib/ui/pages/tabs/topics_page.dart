import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:neaws/constants/categories.dart';
import 'package:neaws/providers/news_provider.dart';
import 'package:neaws/ui/widgets/search_button.dart';
import 'package:neaws/ui/widgets/settings_button.dart';
import 'package:neaws/ui/widgets/topic_list.dart';
import 'package:provider/provider.dart';
import 'package:simple_design/simple_design.dart';

class TopicsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (
        BuildContext context,
        NewsProvider newsProvider,
        _,
      ) {
        final theme = Theme.of(context);

        final updateList = newsProvider.updateList;
        final updateSavedList = newsProvider.updateSavedList;

        return DefaultTabController(
          length: Categories.values.length,
          child: NestedScrollView(
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) =>
                [
              SDSliverAppBar(
                leading: SearchButton(),
                title: Text.rich(
                  TextSpan(
                    text: "Neaws ",
                    style: theme.textTheme.title,
                    children: [
                      TextSpan(
                        text: "Topics",
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
                bottom: TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: "Business",
                      icon: Icon(EvaIcons.briefcaseOutline),
                    ),
                    Tab(
                      text: "Entertainment",
                      icon: Icon(EvaIcons.tvOutline),
                    ),
                    Tab(
                      text: "General",
                      icon: Icon(EvaIcons.peopleOutline),
                    ),
                    Tab(
                      text: "Health",
                      icon: Icon(EvaIcons.activityOutline),
                    ),
                    Tab(
                      text: "Science",
                      icon: Icon(EvaIcons.bulbOutline),
                    ),
                    Tab(
                      text: "Sports",
                      icon: Icon(EvaIcons.globeOutline),
                    ),
                    Tab(
                      text: "Technology",
                      icon: Icon(EvaIcons.radioOutline),
                    ),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              children: [
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

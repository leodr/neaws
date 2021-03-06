import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/categories.dart';
import '../../providers/news_provider.dart';
import '../widgets/topic_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          PageView.builder(
            controller: pageController,
            itemBuilder: (BuildContext context, int i) => CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 49,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: AnimatedBuilder(
                      animation: pageController,
                      builder: (BuildContext context, Widget child) {
                        return Opacity(
                          opacity: (1 - (pageController.page % 1) * 2).abs(),
                          child: Container(
                            color: Colors.blueAccent,
                            height: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                TopicList(
                  onUpdate: Provider.of<NewsProvider>(context).updateList,
                  category: Categories.values[i],
                  articleList: Provider.of<NewsProvider>(context).businessNews,
                  onSaved: Provider.of<NewsProvider>(context).updateSavedList,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: SizedBox(
                height: 40,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) =>
                      AnimatedBuilder(
                    animation: pageController,
                    builder: (BuildContext context, Widget child) {
                      if (scrollController.hasListeners) {
                        scrollController.jumpTo(
                            constraints.maxWidth * 0.6 * pageController.page);
                      }

                      return ListView.builder(
                        controller: scrollController,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.2),
                        itemBuilder: (BuildContext context, int i) {
                          return SizedBox(
                            width: constraints.maxWidth * 0.6,
                            child: Center(
                                child: Text(Categories.values[i].toString())),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

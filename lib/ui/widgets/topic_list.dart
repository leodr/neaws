import 'package:flutter/material.dart';
import 'package:neaws/api/models/article.dart';
import 'package:neaws/constants/categories.dart';
import 'package:neaws/providers/news_provider.dart';
import 'package:provider/provider.dart';

import 'list_item.dart';

class TopicList extends StatefulWidget {
  const TopicList({
    Key key,
    this.onUpdate,
    this.category,
    this.articleList,
    this.onSaved,
  }) : super(key: key);

  final Future<void> Function({Categories category}) onUpdate;
  final Categories category;
  final List<Article> articleList;
  final VoidCallback onSaved;

  @override
  _TopicListState createState() => _TopicListState();
}

class _TopicListState extends State<TopicList> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<NewsProvider>(context).updateList(category: widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: kToolbarHeight,
      onRefresh: () => widget.onUpdate(
        category: widget.category,
      ),
      child: widget.articleList.isEmpty
          ? const SliverFillRemaining(
              child: CircularProgressIndicator(),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int i) => ListItem(
                  widget.articleList[i],
                  onSaved: widget.onSaved,
                ),
                childCount: widget.articleList.length,
              ),
            ),
    );
  }
}

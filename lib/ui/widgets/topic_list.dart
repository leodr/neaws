import 'package:flutter/material.dart';
import 'package:neaws/api/models/article.dart';
import 'package:neaws/constants/categories.dart';

import 'list_item.dart';

class TopicList extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: kToolbarHeight,
      onRefresh: () => onUpdate(
        category: category,
      ),
      child: articleList.isEmpty
          ? Center(
              child: const CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int i) => ListItem(
                articleList[i],
                onSaved: onSaved,
              ),
              itemCount: articleList.length,
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:neaws/constants/categories.dart';

import 'list_item.dart';

class TopicList extends StatelessWidget {
  final Future Function({Categories category}) onUpdate;
  final Categories category;
  final List articleList;
  final VoidCallback onSaved;

  const TopicList({
    Key key,
    this.onUpdate,
    this.category,
    this.articleList,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: kToolbarHeight,
      onRefresh: () => onUpdate(
        category: category,
      ),
      child: articleList.length < 1
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, i) => ListItem(
                articleList[i],
                onSaved: onSaved,
              ),
              itemCount: articleList.length,
            ),
    );
  }
}

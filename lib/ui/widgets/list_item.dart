import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:neaws/api/models/article.dart';
import 'package:neaws/util/date_utils.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_design/simple_design.dart';

class ListItem extends StatelessWidget {
  const ListItem(this.article, {this.onSaved});

  final Article article;
  final VoidCallback onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => launchURL(context, article.url),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            article.source.name.toString().toUpperCase(),
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                .copyWith(color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              article.title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subhead
                                  .copyWith(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    article.urlToImage != null
                        ? Card(
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              fadeInDuration: const Duration(milliseconds: 150),
                              imageUrl: article.urlToImage,
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Card(
                            clipBehavior: Clip.antiAlias,
                            color: Theme.of(context).backgroundColor,
                            child: Container(
                                width: 100.0,
                                height: 100.0,
                                alignment: Alignment.center,
                                child: Icon(
                                  EvaIcons.closeSquareOutline,
                                  color: Theme.of(context).disabledColor,
                                )),
                          )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(getTimeStamp(article.publishedAt),
                          style: Theme.of(context).textTheme.caption),
                    ),
                    PopupMenuButton<String>(
                        onSelected: (String value) {
                          switch (value) {
                            case 'share':
                              Share.share(article.title + '\n\n' + article.url);
                              break;
                            case 'save':
                              _save(article);
                              onSaved();
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuItem<String>>[
                              PopupMenuItem<String>(
                                  value: 'share',
                                  child: ListTile(
                                    dense: true,
                                    title: const Text('Share'),
                                    leading: Icon(EvaIcons.shareOutline),
                                  )),
                              PopupMenuItem<String>(
                                  enabled: onSaved != null,
                                  value: 'save',
                                  child: ListTile(
                                    dense: true,
                                    title: const Text('Save'),
                                    leading: Icon(EvaIcons.saveOutline),
                                  ))
                            ])
                  ],
                )
              ],
            ),
          ),
        ),
        SDDivider(
          height: 16.0,
        )
      ],
    );
  }

  String getTimeStamp(DateTime publishedAt) {
    final Duration difference = DateTime.now().difference(publishedAt);

    if (difference.inHours <= 1) {
      return difference.inHours.toString() + ' hour ago';
    } else if (difference.inHours < 24) {
      return difference.inHours.toString() + ' hours ago';
    } else if (difference.inDays <= 1) {
      return difference.inDays.toString() + ' day ago';
    } else if (difference.inDays < 7) {
      return difference.inDays.toString() + ' days ago';
    }

    return publishedAt.day.toString() +
        '. ' +
        getMonthString(publishedAt.month) +
        ' ' +
        publishedAt.year.toString();
  }

  Future<void> _save(Article article) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList(
        'saved',
        (_prefs.getStringList('saved') ?? <String>[])
          ..add(jsonEncode(article.toJSON())));
  }
}

Future<void> launchURL(BuildContext context, String url) async {
  try {
    await launch(
      url,
      option: CustomTabsOption(
        toolbarColor: Theme.of(context).scaffoldBackgroundColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: const CustomTabsAnimation(
          startEnter: 'slide_up',
          endExit: 'slide_down',
        ),
        extraCustomTabs: <String>[
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

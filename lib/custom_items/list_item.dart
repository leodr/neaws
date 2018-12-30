import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_news_app/util.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_design/simple_design.dart';

class ListItem extends StatelessWidget {
  final Map article;
  final DateTime publishedAt;
  final VoidCallback onSaved;

  ListItem(this.article, {this.onSaved})
      : publishedAt = DateTime.parse(article["publishedAt"]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => launchURL(context, article["url"]),
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
                            article["source"]["name"].toString().toUpperCase(),
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                .copyWith(color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              article["title"],
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
                    article["urlToImage"] != null
                        ? Card(
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              fadeInDuration: Duration(milliseconds: 150),
                              imageUrl: article["urlToImage"],
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
                                  CommunityMaterialIcons.image_off,
                                  color: Theme.of(context).disabledColor,
                                )),
                          )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(getTimeStamp(publishedAt),
                          style: Theme.of(context).textTheme.caption),
                    ),
                    PopupMenuButton(
                        onSelected: (value) {
                          switch (value) {
                            case "share":
                              Share.share(
                                  article["title"] + "\n\n" + article["url"]);
                              break;
                            case "save":
                              _save(article);
                              onSaved();
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: "share",
                                  child: ListTile(
                                    dense: true,
                                    title: Text("Share"),
                                    leading: Icon(
                                        CommunityMaterialIcons.share_outline),
                                  )),
                              PopupMenuItem(
                                  enabled: onSaved != null,
                                  value: "save",
                                  child: ListTile(
                                    dense: true,
                                    title: Text("Save"),
                                    leading: Icon(CommunityMaterialIcons
                                        .content_save_outline),
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
    Duration difference = DateTime.now().difference(publishedAt);

    if (difference.inHours <= 1) {
      return difference.inHours.toString() + " hour ago";
    } else if (difference.inHours < 24) {
      return difference.inHours.toString() + " hours ago";
    } else if (difference.inDays <= 1) {
      return difference.inDays.toString() + " day ago";
    } else if (difference.inDays < 7) {
      return difference.inDays.toString() + " days ago";
    }

    return publishedAt.day.toString() +
        ". " +
        getMonthString(publishedAt.month) +
        " " +
        publishedAt.year.toString();
  }

  void _save(Map article) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList("saved",
        (_prefs.getStringList("saved") ?? [])..add(json.encode(article)));
  }
}

void launchURL(BuildContext context, String url) async {
  try {
    await launch(
      url,
      option: new CustomTabsOption(
        toolbarColor: Theme.of(context).scaffoldBackgroundColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: CustomTabsAnimation(
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

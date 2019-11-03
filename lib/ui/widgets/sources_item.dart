import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:neaws/pages/source_page.dart';
import 'package:simple_design/simple_design.dart';

import 'list_item.dart';

class SourcesItem extends StatelessWidget {
  final Map source;
  final String apiKey;

  SourcesItem({this.source, this.apiKey});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SourcePage(
                  apiKey: apiKey,
                  source: source,
                )));
      },
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).backgroundColor,
        child: Text(
          source["name"].toString().substring(0, 1),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        source["name"],
        maxLines: 1,
      ),
      subtitle: Text(
        source["description"],
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      isThreeLine: true,
      trailing: PopupMenuButton(
          tooltip: "Options",
          padding: EdgeInsets.all(0.0),
          onSelected: (selection) {
            switch (selection) {
              case "info":
                showDialog(
                    context: context,
                    builder: (context) => SDDialog(
                          title: source["name"],
                          content: Text(source["description"]),
                          actionButton: SDActionButton(
                              title: "Ok",
                              onPressed: () => Navigator.of(context).pop()),
                        ));
                break;
              case "web":
                launchURL(context, source["url"]);
                break;
            }
          },
          itemBuilder: (context) => [
                PopupMenuItem(
                  value: "info",
                  child: ListTile(
                    leading: Icon(EvaIcons.infoOutline),
                    title: Text("Information"),
                    dense: true,
                  ),
                ),
                PopupMenuItem(
                  value: "web",
                  child: ListTile(
                    leading: Icon(EvaIcons.externalLinkOutline),
                    title: Text("Open website"),
                    dense: true,
                  ),
                )
              ]),
    );
  }
}

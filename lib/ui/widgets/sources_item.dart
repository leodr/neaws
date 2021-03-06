import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:simple_design/simple_design.dart';

import '../../api/models/source.dart';
import '../pages/source_page.dart';
import 'list_item.dart';

class SourcesItem extends StatelessWidget {
  const SourcesItem({this.source, this.apiKey});

  final Source source;
  final String apiKey;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => SourcePage(
              apiKey: apiKey,
              source: source,
            ),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).backgroundColor,
        child: Text(
          source.name.toString().substring(0, 1),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        source.name,
        maxLines: 1,
      ),
      subtitle: Text(
        source.description,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      isThreeLine: true,
      trailing: PopupMenuButton<String>(
        tooltip: 'Options',
        padding: const EdgeInsets.all(0.0),
        onSelected: (String selection) {
          switch (selection) {
            case 'info':
              showDialog<void>(
                context: context,
                builder: (BuildContext context) => SDDialog(
                  title: source.name,
                  content: Text(source.description),
                  actionButton: SDActionButton(
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              );
              break;
            case 'web':
              launchURL(context, source.url);
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
          const PopupMenuItem<String>(
            value: 'info',
            child: ListTile(
              leading: Icon(EvaIcons.infoOutline),
              title: Text('Information'),
              dense: true,
            ),
          ),
          const PopupMenuItem<String>(
            value: 'web',
            child: ListTile(
              leading: Icon(EvaIcons.externalLinkOutline),
              title: Text('Open website'),
              dense: true,
            ),
          ),
        ],
      ),
    );
  }
}

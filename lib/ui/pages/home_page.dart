import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'tabs/headlines_page.dart';
import 'tabs/saved_page.dart';
import 'tabs/sources_page.dart';
import 'tabs/topics_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _getBody(index),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int position) {
          if (position != index) {
            setState(() {
              index = position;
            });
          }
        },
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.globe2Outline),
            activeIcon: Icon(EvaIcons.globe2),
            title: const Text('Headlines'),
          ),
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.folderOutline),
            activeIcon: Icon(EvaIcons.folder),
            title: const Text('Topics'),
          ),
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.bookmarkOutline),
            activeIcon: Icon(EvaIcons.bookmark),
            title: const Text('Saved'),
          ),
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.codeOutline),
            activeIcon: Icon(EvaIcons.code),
            title: const Text('Sources'),
          ),
        ],
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return HeadlinesPage();
      case 1:
        return TopicsPage();
      case 2:
        return SavedPage();
      case 3:
        return SourcesPage();
      default:
        return const Text('Error.');
    }
  }
}

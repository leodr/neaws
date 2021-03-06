import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api/news_api.dart';
import 'constants/api_key.dart';
import 'providers/news_api_provider.dart';
import 'providers/news_provider.dart';
import 'providers/news_search_provider.dart';
import 'providers/theme_provider.dart';
import 'ui/pages/filter_dialog.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/search_page.dart';
import 'ui/pages/settings_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewsApiProvider>(
      create: (BuildContext context) => NewsApiProvider(apiKey: apiKey),
      child: Consumer<NewsApiProvider>(
        builder: (
          BuildContext context,
          NewsApiProvider newsApiProvider,
          _,
        ) {
          final NewsApi newsApi = newsApiProvider.newsApi;

          return MultiProvider(
            providers: <SingleChildCloneableWidget>[
              ChangeNotifierProvider<ThemeProvider>(
                create: (BuildContext context) => ThemeProvider(),
              ),
              ChangeNotifierProvider<NewsProvider>(
                create: (BuildContext context) => NewsProvider(api: newsApi),
              ),
              ChangeNotifierProvider<NewsSearchProvider>(
                create: (BuildContext context) =>
                    NewsSearchProvider(api: newsApi),
              ),
            ],
            child: Consumer<ThemeProvider>(
              builder: (
                BuildContext context,
                ThemeProvider themeProvider,
                _,
              ) {
                final ThemeData theme = themeProvider.theme;

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  color: theme.backgroundColor,
                  title: 'Neaws',
                  theme: theme,
                  routes: <String, WidgetBuilder>{
                    '/': (BuildContext context) => HomePage(),
                    '/settings': (BuildContext context) => SettingsPage(),
                    '/search': (BuildContext context) => SearchPage(),
                    '/searchfilter': (BuildContext context) => FilterDialog(),
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

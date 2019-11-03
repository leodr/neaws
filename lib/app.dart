import 'package:flutter/material.dart';
import 'package:neaws/constants/api_key.dart';
import 'package:neaws/providers/news_search_provider.dart';
import 'package:neaws/ui/pages/filter_dialog.dart';
import 'package:provider/provider.dart';

import 'api/news_api.dart';
import 'providers/news_provider.dart';
import 'providers/theme_provider.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/search_page.dart';
import 'ui/pages/settings_page.dart';

class App extends StatelessWidget {
  final NewsApi _newsApi = NewsApi(apiKey: API_KEY);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          builder: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<NewsProvider>(
          builder: (context) => NewsProvider(api: _newsApi),
        ),
        ChangeNotifierProvider<NewsSearchProvider>(
          builder: (context) => NewsSearchProvider(api: _newsApi),
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
            title: "Neaws",
            theme: theme,
            routes: {
              "/": (context) => HomePage(),
              "/settings": (context) => SettingsPage(),
              "/search": (context) => SearchPage(),
              "/searchfilter": (context) => FilterDialog(),
            },
          );
        },
      ),
    );
  }
}

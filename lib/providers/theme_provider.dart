import 'package:flutter/material.dart';
import 'package:simple_design/simple_design.dart';

class ThemeProvider with ChangeNotifier {
  final ThemeData lightTheme = SimpleDesign.lightTheme;

  final ThemeData darkTheme = SimpleDesign.darkTheme;

  ThemeData _theme;

  ThemeData get theme => _theme;

  set theme(ThemeData newTheme) {
    _theme = newTheme;
    notifyListeners();
  }

  setTheme(Themes newTheme) {
    switch (newTheme) {
      case Themes.light:
        theme = lightTheme;
        break;
      case Themes.dark:
        theme = darkTheme;
        break;
      default:
        break;
    }
  }
}

enum Themes {
  light,
  dark,
}

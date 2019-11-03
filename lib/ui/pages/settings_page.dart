import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:neaws/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_design/simple_design.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<ThemeProvider>(
          builder: (
            BuildContext context,
            ThemeProvider themeProvider,
            _,
          ) {
            return CustomScrollView(
              slivers: <Widget>[
                SDSliverAppBar(
                  title: Text("Settings"),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SDSectionHeader("Appearance"),
                      SwitchListTile.adaptive(
                        value:
                            themeProvider.theme.brightness == Brightness.dark,
                        onChanged: (v) {
                          themeProvider.setTheme(
                            v ? Themes.dark : Themes.light,
                          );
                        },
                        title: Text("Dark Theme"),
                        secondary: Icon(EvaIcons.sunOutline),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

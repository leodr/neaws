import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:neaws/providers/theme_provider.dart';
import 'package:neaws/ui/widgets/custom_back_button.dart';
import 'package:provider/provider.dart';
import 'package:simple_design/simple_design.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeProvider>(
        builder: (
          BuildContext context,
          ThemeProvider themeProvider,
          _,
        ) {
          return CustomScrollView(
            slivers: <Widget>[
              SDSliverAppBar(
                leading: const CustomBackButton(),
                title: const Text('Settings'),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    SDSectionHeader('Appearance'),
                    SwitchListTile.adaptive(
                      value: themeProvider.theme.brightness == Brightness.dark,
                      onChanged: (bool v) {
                        themeProvider.setTheme(
                          v ? Themes.dark : Themes.light,
                        );
                      },
                      title: const Text('Dark Theme'),
                      secondary: const Icon(EvaIcons.sunOutline),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

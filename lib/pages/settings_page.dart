import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/custom_items/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_design/simple_design.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    loadState();
    super.initState();
  }

  loadState() async {
    var prefs = await _prefs;
    setState(() {
      darkMode = prefs.getBool("darkMode") ?? false;
    });
  }

  updatePrefs() async {
    var prefs = await _prefs;
    prefs.setBool('darkMode', darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SDSliverAppBar(title: Text("Settings")),
            SliverList(
                delegate: SliverChildListDelegate([
              SDSectionHeader("Appearance"),
              SwitchListTile.adaptive(
                value: darkMode,
                onChanged: (newVal) {
                  setState(() {
                    darkMode = newVal;
                    ThemeController.of(context).appTheme =
                        darkMode ? AppThemeOption.dark : AppThemeOption.light;
                    updatePrefs();
                  });
                },
                title: Text("Dark Theme"),
                secondary: Icon(CommunityMaterialIcons.theme_light_dark),
              )
            ]))
          ],
        ),
      ),
    );
  }
}

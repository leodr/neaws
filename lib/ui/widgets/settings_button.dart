import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(EvaIcons.settings2Outline),
      onPressed: () {
        Navigator.of(context).pushNamed('/settings');
      },
    );
  }
}

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(EvaIcons.arrowBackOutline),
      onPressed: () {
        Navigator.pop(context);
      },
      tooltip: 'Back',
    );
  }
}

import 'package:flutter/material.dart';

ThemeData _myTheme;

ThemeData getTheme(BuildContext context) {
  _myTheme ??= ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  return _myTheme;
}

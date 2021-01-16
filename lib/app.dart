import 'package:flutter/material.dart';
import 'package:opencc/theme.dart';
import 'package:opencc/ui/home.dart';

class OpenCCApp extends StatelessWidget {
  static const String initialRoute = '/';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getTheme(context),
      initialRoute: initialRoute,
      routes: <String, WidgetBuilder>{
        initialRoute: (BuildContext context) => HomePage()
      },
    );
  }
}

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:opencc/data/preferences.dart';
import 'package:opencc/theme.dart';
import 'package:opencc/ui/home.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpenCCApp extends StatelessWidget {
  static const String initialRoute = '/';

  @override
  Widget build(BuildContext context) {
    final CurrencyService currencyService = CurrencyService();
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<CurrencyService>.value(value: currencyService),
        Provider<PreferenceManager>(create: (_) => PreferenceManager(prefs))
      ],
      child: MaterialApp(
        theme: getTheme(context),
        initialRoute: initialRoute,
        routes: <String, WidgetBuilder>{
          initialRoute: (BuildContext context) => HomePage()
        },
      ),
    );
  }
}

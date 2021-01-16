import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:opencc/ui/common/currency_tile.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Locale> systemLocales;

  @override
  void initState() {
    super.initState();
    systemLocales = WidgetsBinding.instance.window.locales;
  }

  @override
  Widget build(BuildContext context) {
    final Locale userLocale = Localizations.localeOf(context);
    final Locale altLocale = systemLocales.firstWhere(
        (Locale locale) => locale != userLocale,
        orElse: () => userLocale);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            height: 240,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  CurrencyExchangeTile(
                    countryCode: userLocale.countryCode,
                  ),
                  IconButton(
                    icon: const Icon(
                      MaterialIcons.swap_vertical_circle,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                  CurrencyExchangeTile(
                    countryCode: altLocale.countryCode,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

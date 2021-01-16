import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:opencc/ui/common/currency_tile.dart';
import 'package:opencc/ui/common/label.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Locale> systemLocales;
  static const String FROM_CURRENCY_KEY = 'FROM_CURRENCY';
  static const String TO_CURRENCY_KEY = 'TO_CURRENCY';
  Currency fromCurrency;
  Currency toCurrency;
  bool showLabels = false;

  @override
  void initState() {
    super.initState();
    systemLocales = WidgetsBinding.instance.window.locales;
  }

  void swapCurrencies() {
    setState(() {
      final Currency currency = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = currency;
    });
  }

  void selectCurrency(String target) {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        setState(() {
          switch (target) {
            case FROM_CURRENCY_KEY:
              fromCurrency = currency;
              break;

            case TO_CURRENCY_KEY:
              toCurrency = currency;
              break;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CurrencyService currencyService =
        Provider.of<CurrencyService>(context);

    // Select random from and to currencies.
    fromCurrency ??= currencyService.getAll().first;
    toCurrency ??= currencyService.getAll().elementAt(2);

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
            height: showLabels ? 280 : 240,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Visibility(
                    visible: showLabels,
                    child: Label(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'Convert from',
                        style: theme.textTheme.subtitle1
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  CurrencyExchangeTile(
                    currency: fromCurrency,
                    onFlagPressed: () {
                      selectCurrency(FROM_CURRENCY_KEY);
                    },
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: const Icon(
                        MaterialIcons.swap_vertical_circle,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        swapCurrencies();
                      },
                    ),
                  ),
                  Visibility(
                    visible: showLabels,
                    child: Label(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'To',
                        style: theme.textTheme.subtitle1
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  CurrencyTile(
                    currency: toCurrency,
                    onFlagPressed: () {
                      selectCurrency(TO_CURRENCY_KEY);
                    },
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

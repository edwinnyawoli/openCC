import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:opencc/ui/common/currency_exchange_group.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Locale> systemLocales;
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
      showFlag: false,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        setState(() {
          switch (target) {
            case CurrencyExchangeGroup.FROM_CURRENCY_KEY:
              fromCurrency = currency;
              break;

            case CurrencyExchangeGroup.TO_CURRENCY_KEY:
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
          CurrencyExchangeGroup(
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            showLabels: false,
            onSwapCurrency: swapCurrencies,
            onSelectCurrency: selectCurrency,
          )
        ],
      ),
    );
  }
}

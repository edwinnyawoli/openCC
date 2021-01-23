import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:forex/forex.dart';
import 'package:opencc/ui/common/currency_exchange_group.dart';
import 'package:opencc/ui/common/currency_tile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Currency fromCurrency;
  Currency toCurrency;
  bool showLabels = false;
  Future<Map<String, num>> quotesFuture;
  final TextEditingController amountEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    amountEditingController.dispose();
  }

  void swapCurrencies() {
    setState(() {
      final Currency currency = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = currency;

      resetQuotes();
    });
  }

  void resetQuotes() {
    quotesFuture = Forex.fx(
      base: fromCurrency.code,
      quotes: <String>[toCurrency.code],
      quoteProvider: QuoteProvider.yahoo,
    );
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
          resetQuotes();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CurrencyService currencyService =
        Provider.of<CurrencyService>(context);

    final List<Currency> currencies = currencyService.getAll();
    // Select random from and to currencies.
    fromCurrency ??= currencies.first;
    toCurrency ??= currencies.elementAt(2);
    final Iterable<Currency> filteredCurrencies = currencies
        .where(
          (Currency c) =>
              c.code != fromCurrency.code || c.code != toCurrency.code,
        )
        .take(10);

    quotesFuture ??= Forex.fx(
      base: fromCurrency.code,
      quotes: <String>[toCurrency.code],
      quoteProvider: QuoteProvider.yahoo,
    );
    final Future<Map<String, num>> favouritesQuotes = Forex.fx(
      base: fromCurrency.code,
      quotes: filteredCurrencies.map((Currency c) => c.code).toList(),
      quoteProvider: QuoteProvider.yahoo,
    );
    final double topSectionHeight = showLabels ? 280 : 260;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
            height: topSectionHeight,
            child: CurrencyExchangeGroup(
              amountEditingController: amountEditingController,
              fromCurrency: fromCurrency,
              toCurrency: toCurrency,
              quote: quotesFuture,
              showLabels: false,
              onSwapCurrency: swapCurrencies,
              onSelectCurrency: selectCurrency,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: topSectionHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 16, bottom: 4, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Other currencies',
                        style: theme.textTheme.subtitle1,
                      ),
                      Text(
                        'Your amount is automatically converted to a few other currencies below',
                        style: theme.textTheme.caption,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 32, top: 2),
                    itemCount: filteredCurrencies.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Currency baseCurrency =
                          filteredCurrencies.elementAt(index);

                      return CurrencyTile(
                        amountController: amountEditingController,
                        baseCurrency: baseCurrency,
                        fromCurrency: fromCurrency,
                        quote: favouritesQuotes,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 12);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

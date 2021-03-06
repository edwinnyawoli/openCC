import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:opencc/ui/common/currency_tile.dart';
import 'package:opencc/ui/common/label.dart';

class CurrencyExchangeGroup extends StatelessWidget {
  const CurrencyExchangeGroup({
    Key key,
    this.showLabels,
    @required this.fromCurrency,
    @required this.toCurrency,
    this.onSwapCurrency,
    this.onSelectCurrency,
    @required this.quote,
    this.amountEditingController,
  }) : super(key: key);

  static const String FROM_CURRENCY_KEY = 'FROM_CURRENCY';
  static const String TO_CURRENCY_KEY = 'TO_CURRENCY';
  final bool showLabels;
  final Currency fromCurrency;
  final Currency toCurrency;
  final VoidCallback onSwapCurrency;
  final void Function(String) onSelectCurrency;
  final Future<Map<String, num>> quote;
  final TextEditingController amountEditingController;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Tap on a flag to select a currency',
                  style: theme.textTheme.caption.copyWith(color: Colors.white),
                ),
              ),
            ),
            Visibility(
              visible: showLabels ?? false,
              child: Label(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  'Convert from',
                  style:
                      theme.textTheme.subtitle1.copyWith(color: Colors.white),
                ),
              ),
            ),
            CurrencyValueInputTile(
              controller: amountEditingController,
              currency: fromCurrency,
              onFlagPressed: () {
                onSelectCurrency(FROM_CURRENCY_KEY);
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
                  onSwapCurrency();
                },
              ),
            ),
            Visibility(
              visible: showLabels ?? false,
              child: Label(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  'To',
                  style:
                      theme.textTheme.subtitle1.copyWith(color: Colors.white),
                ),
              ),
            ),
            CurrencyExchangeTile(
              baseCurrency: toCurrency,
              fromCurrency: fromCurrency,
              quote: quote,
              amountController: amountEditingController,
              onFlagPressed: () {
                onSelectCurrency(TO_CURRENCY_KEY);
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';

///
/// CurrencyExchangeTile is a widget that allows you to select a currency
/// and input an amount to be converted into another currency.
///
class CurrencyExchangeTile extends StatelessWidget {
  const CurrencyExchangeTile({
    Key key,
    this.currency,
    this.margin,
    this.controller,
    this.onFlagPressed,
  }) : super(key: key);

  final Currency currency;
  final TextEditingController controller;
  final EdgeInsets margin;
  final VoidCallback onFlagPressed;

  @override
  Widget build(BuildContext context) {
    final Country country =
        CountryPickerUtils.getCountryByCurrencyCode(currency.code);

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: <Widget>[
          CountrySelector(
            country: country,
            onFlagPressed: onFlagPressed,
          ),
          const VerticalDivider(
            indent: 8,
            endIndent: 8,
            width: 1,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CurrencyTextField(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              controller: controller,
              currency: currency,
            ),
          ),
          const SizedBox(width: 12),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[],
          // ),
        ],
      ),
    );
  }
}

///
/// A CurrencyTile widget displays exchange rate information
/// between a base currency and another currency.
///
class CurrencyTile extends StatelessWidget {
  const CurrencyTile({Key key, this.currency, this.onFlagPressed})
      : super(key: key);
  final Currency currency;
  final VoidCallback onFlagPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Country country =
        CountryPickerUtils.getCountryByCurrencyCode(currency.code);

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: <Widget>[
          CountrySelector(
            country: country,
            onFlagPressed: onFlagPressed,
          ),
          const VerticalDivider(
            indent: 8,
            endIndent: 8,
            width: 1,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      currency.code,
                      style: theme.textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${currency.symbol} 7890.50',
                        textAlign: TextAlign.end,
                        style: theme.textTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        currency.name,
                        style: theme.textTheme.caption,
                      ),
                    ),
                    Text(
                      '1 USD = 73.04 ${currency.code}',
                      style: theme.textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class CurrencyTextField extends StatelessWidget {
  const CurrencyTextField(
      {Key key, this.padding, this.controller, this.currency})
      : super(key: key);
  final Currency currency;
  final EdgeInsets padding;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        // textAlign: TextAlign.end,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(2.0),
            color: Colors.grey.shade100,
            padding: const EdgeInsets.only(left: 16.0, top: 12.0),
            child: Text(
              currency.symbol,
              style: theme.textTheme.headline6,
            ),
          ),
          isDense: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class CountrySelector extends StatelessWidget {
  const CountrySelector({Key key, this.country, this.onFlagPressed})
      : super(key: key);
  final Country country;
  final VoidCallback onFlagPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            const Icon(Icons.keyboard_arrow_down)
          ],
        ),
      ),
      onTap: () {
        if (onFlagPressed != null) {
          onFlagPressed();
        }
      },
    );
  }
}

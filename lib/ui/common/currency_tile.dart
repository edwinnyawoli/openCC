import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

///
/// CurrencyValueInputTile is a widget that allows you to select a currency
/// and input an amount to be converted into another currency.
///
class CurrencyValueInputTile extends StatelessWidget {
  const CurrencyValueInputTile({
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
/// A CurrencyExchangeTile widget displays exchange rate information
/// between a base currency and another currency.
///
class CurrencyExchangeTile extends StatefulWidget {
  const CurrencyExchangeTile({
    Key key,
    @required this.baseCurrency,
    this.onFlagPressed,
    @required this.fromCurrency,
    @required this.quote,
    @required this.amountController,
  }) : super(key: key);
  // The currency being converted to
  final Currency baseCurrency;
  // The currency being converted from
  final Currency fromCurrency;
  final VoidCallback onFlagPressed;
  final Future<Map<String, num>> quote;
  // The controller from which the amount value will be retrieved
  final TextEditingController amountController;

  @override
  _CurrencyExchangeTileState createState() => _CurrencyExchangeTileState();
}

class _CurrencyExchangeTileState extends State<CurrencyExchangeTile> {
  num amount = 0;

  @override
  void initState() {
    super.initState();
    widget.amountController.addListener(() {
      setState(() {
        amount = num.tryParse(widget.amountController.text) ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Country country =
        CountryPickerUtils.getCountryByCurrencyCode(widget.baseCurrency.code);

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
            onFlagPressed: widget.onFlagPressed,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.baseCurrency.code,
                  style: theme.textTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                ),
                Text(
                  widget.baseCurrency.name,
                  style: theme.textTheme.caption,
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, num>>(
              future: widget.quote,
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, num>> snapshot) {
                Widget amountWidget;
                Widget rateWidget;

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    amountWidget = Container(
                      width: 50,
                      height: 15,
                      color: Colors.black,
                    );
                    rateWidget = Container(
                      height: 10,
                      width: 80,
                      color: Colors.black,
                    );

                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade100,
                      highlightColor: Colors.grey.shade300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          amountWidget,
                          const SizedBox(
                            height: 4,
                          ),
                          rateWidget
                        ],
                      ),
                    );

                  default:
                    String amountStr = '?';
                    String rate = '?';
                    if (!snapshot.hasError) {
                      try {
                        final Iterable<MapEntry<String, num>> entries =
                            snapshot.data.entries;
                        final MapEntry<String, num> entry = entries.firstWhere(
                            (MapEntry<String, num> entry) =>
                                entry.key.endsWith(widget.baseCurrency.code));
                        final num rateValue = entry.value;
                        rate = rateValue?.toStringAsFixed(3);
                        amountStr = (amount * rateValue).toStringAsFixed(2);
                      } catch (e) {
                        // Error resolving rate and amount
                      }
                    }

                    amountWidget = Text(
                      '${widget.baseCurrency.symbol} $amountStr',
                      textAlign: TextAlign.end,
                      style: theme.textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    );
                    rateWidget = Text(
                      '1 ${widget.fromCurrency.code} = $rate ${widget.baseCurrency.code}',
                      style: theme.textTheme.caption,
                    );
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        amountWidget,
                        rateWidget,
                      ],
                    );
                }
              },
            ),
          ),
          // Expanded(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Row(
          //         children: <Widget>[
          //           Text(
          //             baseCurrency.code,
          //             style: theme.textTheme.subtitle1.copyWith(
          //               fontWeight: FontWeight.bold,
          //               color: Colors.lightBlue,
          //             ),
          //           ),
          //           Expanded(
          //             child: Text(
          //               '${baseCurrency.symbol} 7890.50',
          //               textAlign: TextAlign.end,
          //               style: theme.textTheme.subtitle1.copyWith(
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.black87,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       Row(
          //         children: <Widget>[
          //           Expanded(
          //             child: Text(
          //               baseCurrency.name,
          //               style: theme.textTheme.caption,
          //             ),
          //           ),
          //           Text(
          //             '1 ${fromCurrency.code} = 73.04 ${baseCurrency.code}',
          //             style: theme.textTheme.caption,
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
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
            padding: const EdgeInsets.all(12.0),
            child: FittedBox(
              child: Text(
                currency.symbol,
                style: theme.textTheme.headline6,
              ),
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
    final bool showFlagDropdown = onFlagPressed != null;
    // Showing the flag causes the contents of the column below to be pushed
    // up and thus a padding is added to the top to offset that.
    // Where the icon is not shown, there is no need to offset with a top
    // padding
    final double topPadding = showFlagDropdown ? 8.0 : 0.0;

    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: topPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            Visibility(
              visible: showFlagDropdown,
              child: const Icon(Icons.keyboard_arrow_down),
            )
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

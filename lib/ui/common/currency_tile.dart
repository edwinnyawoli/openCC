import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';

class CurrencyExchangeTile extends StatelessWidget {
  const CurrencyExchangeTile({Key key, this.countryCode, this.margin})
      : super(key: key);
  final String countryCode;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    final Country country = CountryPickerUtils.getCountryByIsoCode(countryCode);

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CountryPickerUtils.getDefaultFlagImage(country),
                const Icon(Icons.keyboard_arrow_down)
              ],
            ),
          ),
          const VerticalDivider(
            indent: 8,
            endIndent: 8,
            width: 1,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(country.name),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(country.name),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CurrencyTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

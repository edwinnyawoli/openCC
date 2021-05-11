import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  factory PreferenceManager(Future<SharedPreferences> prefs) {
    _instance ??= PreferenceManager._(prefs);
    return _instance;
  }

  PreferenceManager._(this._prefs);
  Future<SharedPreferences> _prefs;
  static PreferenceManager _instance;

  Future<void> setFromCurrency(String currencyCode) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(Preferences.FROM_CURRENCY, currencyCode);
  }

  Future<void> setToCurrency(String currencyCode) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(Preferences.TO_CURRENCY, currencyCode);
  }

  Future<String> getFromCurrency() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(Preferences.FROM_CURRENCY);
  }

  Future<String> getToCurrency() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(Preferences.TO_CURRENCY);
  }
}

class Preferences {
  static const String FROM_CURRENCY = 'FROM_CURRENCY';
  static const String TO_CURRENCY = 'TO_CURRENCY';
}

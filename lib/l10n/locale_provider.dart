import 'package:flutter/material.dart';
import 'app_strings.dart';

class LocaleProvider extends ChangeNotifier {
  AppLocale _locale = AppLocale.uz;

  AppLocale get locale => _locale;
  AppStrings get strings => AppStrings(_locale);

  void setLocale(AppLocale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}

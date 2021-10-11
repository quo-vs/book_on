import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/theme.dart';
import '../main.dart';

class AppProvider extends ChangeNotifier {
  AppProvider() {
    init();
  }

   void init() async {
    await setTheme(sharedPrefs.getTheme());
    setLanguage(null, sharedPrefs.getLanguage());
    notifyListeners();
  }

  ThemeData theme = ThemeConfig.lightTheme;
  ThemeMode mode = ThemeMode.light;

  String language = 'en';
  Key key = UniqueKey();

  Future<void> setLanguage(BuildContext? context, lang) async {
    if (context != null) {
      final _newLocale = Locale(lang);
      await context.setLocale(_newLocale);
    }
    language = lang;
    notifyListeners();
  }

  Future<void> setTheme(themeMode) async {
    mode = themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    await sharedPrefs.setTheme(themeMode);
    notifyListeners();
  }
}

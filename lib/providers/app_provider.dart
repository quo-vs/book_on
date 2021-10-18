import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/books_service.dart';
import '../services/quotes_service.dart';
import '../config/theme.dart';
import '../main.dart';

class AppProvider extends ChangeNotifier {  
  ThemeData theme = ThemeConfig.lightTheme;
  ThemeMode mode = ThemeMode.light;
  bool syncWithCloud = false;
  String language = 'en';

  Key key = UniqueKey();

  AppProvider() {
    init();
  }

   void init() async {
    await setTheme(sharedPrefs.getTheme());
    setLanguage(null, sharedPrefs.getLanguage());
    setSyncWithCloud(null, sharedPrefs.getSyncWithCloud());
    notifyListeners();
  }


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

  Future<void> setSyncWithCloud(BuildContext? context, bool sync) async {
    await sharedPrefs.setSyncWithCloud(sync);
    syncWithCloud = sync;

    if (context != null) {
      await BooksService().addBooks(context);
      await QuotesService().addQuotes(context);
    }

    notifyListeners();
  }
}

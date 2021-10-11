import 'package:shared_preferences/shared_preferences.dart';

class SPSettings {
  static const String languageKey = 'language';
  static const String themeKey = 'theme';

  late SharedPreferences _sharedPreferences;
  SPSettings._internal();

  static final SPSettings _instance = SPSettings._internal();

  factory SPSettings() {
    return _instance;
  }

  Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future setTheme(String mode) {
    return _sharedPreferences.setString(themeKey, mode);
  }

  String getTheme() {
    String? theme = _sharedPreferences.getString(themeKey);
    theme ??= 'light';

    return theme;
  }

  Future setLanguage(String mode) {
    return _sharedPreferences.setString(languageKey, mode);
  }

  String getLanguage() {
    String? language = _sharedPreferences.getString(languageKey);
    language ??= 'en';

    return language;
  }
}
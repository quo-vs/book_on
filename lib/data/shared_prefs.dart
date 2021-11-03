import 'package:shared_preferences/shared_preferences.dart';

class SPSettings {
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  static const String syncKey = 'sync';
  static const String onBoardingFinishedKey = 'finishedOnBoarding';

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

  Future setSyncWithCloud(bool syncWihCloud) async {
    return await _sharedPreferences.setBool(syncKey, syncWihCloud);
  }

  bool getSyncWithCloud() {
    bool? syncWithCloud = _sharedPreferences.getBool(syncKey);
    syncWithCloud ??= false;

    return syncWithCloud;
  }

  Future setOnBoardingFinished(bool isFinished) async {
    return await _sharedPreferences.setBool(onBoardingFinishedKey, isFinished);
  }

  bool getOnBoardingFinished() {
    bool? onBoardingFinished = _sharedPreferences.getBool(onBoardingFinishedKey);
    onBoardingFinished ??= false;

    return onBoardingFinished;
  }
}
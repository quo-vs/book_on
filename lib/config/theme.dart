import 'package:flutter/material.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';

import '../utils/constants.dart';

class ThemeConfig {
  static const FlexScheme usedFlexScheme = FlexScheme.money;

  static ThemeData lightTheme = FlexColorScheme.light(
          scheme: usedFlexScheme,
          // Use comfortable on desktops instead of compact, devices use default.
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          fontFamily: AppFonts.fontRussoOne)
      .toTheme;

  static ThemeData darkTheme = FlexColorScheme.dark(
          scheme: usedFlexScheme,
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          fontFamily: AppFonts.fontRussoOne)
      .toTheme;
}

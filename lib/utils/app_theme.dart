import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Light Theme
  static const Color primary = Color(0xFFFEBE3F); // green
  static const Color secondary = Color.fromARGB(255, 252, 219, 154);

  static const Color backgroundLightGrey = Color(0xFFE5E5E5);
  static const Color backgroundNearlyWhite = Color(0xFFFEFEFE);

  // Dark Theme
  static const Color darkPrimary = Color(0xFFFEBE3F);
  static const Color darkSecondary = Color.fromARGB(255, 252, 219, 154);

  static const Color backgroundDarkGrey = Color(0xFF383838);

  static const Color errorRed = Color(0xFFFF0000);

  static const Color dividerGrey = Color(0xFFD3D3D3);
  static const Color dividerDarkGrey = Color(0xFF656565);

  static const Color nearlyWhite = Color(0xFFFEFEFE);

  static const Color lightGrey = Color(0xFFBFBFBF);

  static const Color chipBackground = Color(0xFFEEF1F3);

  static const double APPBAR_ELEVATION = 10;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: Colors.blue,
    fontFamily: 'Schyler',
    accentColor: Color(0xFFFEBE3F),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF6200EE),
      onPrimary: Color(0xFFFFFFFF),
      primaryVariant: Color(0xFF3700B3),
      secondaryVariant: Color(0xFF018786),
      primaryContainer: backgroundLightGrey,
      onPrimaryContainer: Colors.black,
      secondaryContainer: Color(0xFFF1F8FF),
      // onSecondaryContainer: ,
      secondary: Color(0xFF03DAC6),
      onSecondary: Color(0xFF000000),
      tertiaryContainer: Color(0xFFFEFEFE),
      // onTertiaryContainer: ,
      errorContainer: primary,
      onErrorContainer: Colors.white,
      shadow: lightGrey,
      error: Color(0xFFB00020),
      onError: Color(0xFFFFFFFF),
      background: Color(0xFFFFFFFF),
      onBackground: Color(0xFF000000),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF000000),
    ),
    scaffoldBackgroundColor: backgroundLightGrey,
    dividerTheme: const DividerThemeData(
      color: AppTheme.dividerDarkGrey,
    ),
    appBarTheme: const AppBarTheme(
      brightness: Brightness.dark,
      elevation: APPBAR_ELEVATION,
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      color: primary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: Colors.yellow,
    accentColor: primary,
    fontFamily: 'Schyler',
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF6200EE),
      onPrimary: Color(0xFFFFFFFF),
      primaryVariant: Color(0xFF3700B3),
      secondaryVariant: Color(0xFF018786),
      primaryContainer: backgroundLightGrey,
      onPrimaryContainer: Colors.black,
      secondaryContainer: Color(0xFFF1F8FF),
      // onSecondaryContainer: ,
      secondary: Color(0xFF03DAC6),
      onSecondary: Color(0xFF000000),
      tertiaryContainer: Color(0xFFFEFEFE),
      // onTertiaryContainer: ,
      errorContainer: primary,
      onErrorContainer: Colors.white,
      shadow: lightGrey,
      error: Color(0xFFB00020),
      onError: Color(0xFFFFFFFF),
      background: Color(0xFFFFFFFF),
      onBackground: Color(0xFF000000),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF000000),
    ),
    scaffoldBackgroundColor: backgroundDarkGrey,
    dividerTheme: const DividerThemeData(
      color: AppTheme.dividerGrey,
    ),
    appBarTheme: const AppBarTheme(
      elevation: APPBAR_ELEVATION,
      textTheme: TextTheme(
        subtitle1: TextStyle(
          color: primary,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'schemas/color_schemes.g.dart';

class AppTheme {
  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme, 
    );
  }
}
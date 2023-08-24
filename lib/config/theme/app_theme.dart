

import 'package:flutter/material.dart';
import 'schemas/color_schemes.g.dart';

class AppTheme {

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,

  );

}
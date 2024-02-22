import 'package:flutter/material.dart';
import 'package:food_cafe/core/theme/text_theme.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    background: const Color(0XFFFEFEFF),
    primary: const Color(0XFF6B50F6).withOpacity(0.2),
    secondary: const Color(0XFF6B50F6),
    tertiary: const Color(0XFF00FF66).withOpacity(0.8),
    brightness: Brightness.light,
  ),
  textTheme: kTextTheme.lightTextTheme
);

ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    background: Color(0XFF2A2C38),
    primary: Color(0XFF222222),
    secondary: Color(0XFF4023D7),
    tertiary: Color(0xFF1E824C),
    brightness: Brightness.dark,
  ),
  textTheme: kTextTheme.darkTextTheme
);

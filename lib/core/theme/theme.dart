import 'package:flutter/material.dart';
import 'package:food_cafe/core/theme/text_theme.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    background: Colors.white,
    primary: Colors.white,
    secondary: Color(0XFF6B50F6),
    tertiary: Color(0XFF6B50F6),
    brightness: Brightness.light,
  ),
  textTheme: kTextTheme.lightTextTheme
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    background: Color(0XFF2A2C38),
    primary: Color(0XFF222222),
    secondary: Color(0XFF4023D7),
    tertiary: Color(0xFF1E824C),
    brightness: Brightness.dark,
  ),
  textTheme: kTextTheme.darkTextTheme
);

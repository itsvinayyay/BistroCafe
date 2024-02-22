import 'package:flutter/material.dart';
import 'package:food_cafe/core/theme/text_theme.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    background: Color.fromARGB(255, 235, 231, 248),
    primary: Color(0XFFF9D4FF),
    secondary: Color(0XFFE0C882),
    tertiary: Color(0xFFff8c00),
    brightness: Brightness.light,
  ),
  textTheme: kTextTheme.lightTextTheme,
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

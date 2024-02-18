import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/theme/theme.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';

ThemeData getTheme({required BuildContext context}) {
  final themeMode = context.watch<ThemeCubit>().state;
  final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
  return theme;
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_cafe/core/theme/theme.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';

class CustomErrorAlertDialogBox extends StatelessWidget {
  final String heading;
  final String subHeading;

  const CustomErrorAlertDialogBox({
    super.key,
    required this.heading,
    required this.subHeading,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.colorScheme.secondary,
      title: Text(
        heading,
        style: theme.textTheme.headlineMedium,
      ),
      content: Text(
        subHeading,
        style: theme.textTheme.bodyLarge,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Okay")),
      ],
    );
  }
}

class CustomNoInternetAlertDialogBox extends StatelessWidget {
  const CustomNoInternetAlertDialogBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return AlertDialog(
      backgroundColor: theme.colorScheme.secondary,
      title: Text(
        'Not Connected!',
        style: theme.textTheme.headlineMedium,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/noInternet.svg',
            height: 200.h,
            fit: BoxFit.cover,
          ),
          Text(
            'Please connect to a stable Internet Connection to carry out the operation.',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Okay")),
      ],
    );
  }
}

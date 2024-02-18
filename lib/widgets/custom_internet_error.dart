import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_cafe/core/theme/theme.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';

class CustomInternetError extends StatelessWidget {
  final VoidCallback tryAgain;
  const CustomInternetError({super.key, required this.tryAgain});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Column(
      children: [
        SvgPicture.asset(
          'assets/icons/noInternet.svg',
          height: 200.h,
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            'Please connect to a stable Internet Connection to carry out the operation.',
            style: theme.textTheme.bodyLarge!.copyWith(height: 1.25),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        customTryButton(
            theme: theme, onPressed: tryAgain),
      ],
    );
  }
}

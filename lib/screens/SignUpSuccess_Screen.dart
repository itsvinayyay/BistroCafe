import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';

class SignUpSuccess extends StatelessWidget {
  const SignUpSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/signup_success.png"),
              SizedBox(
                height: 33.h,
              ),
              Text(
                "Congrats!",
                style: TextStyle(
                  fontSize: 30.sp,
                  fontFamily: "BentonSans_Bold",
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.tertiary,
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                "Your Profile is Ready To Use",
                style: theme.textTheme.headlineMedium,
              ),
              SizedBox(
                height: 192.h,
              ),
              customButton(
                  context: context,
                  theme: theme,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.bottomNav, (route) => false);
                  },
                  title: "Try Order"),
            ],
          ),
        ),
      ),
    );
  }
}

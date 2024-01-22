import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';

class ForgotPasswordSuccess extends StatefulWidget {
  const ForgotPasswordSuccess({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordSuccess> createState() => _ForgotPasswordSuccessState();
}

class _ForgotPasswordSuccessState extends State<ForgotPasswordSuccess> {
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
                "Success!",
                style: theme.textTheme.labelLarge!.copyWith(fontSize: 30),
              ),
              Text(
                "Password Reset Initiated...",
                style: theme.textTheme.headlineMedium!.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                "Check your email for instructions to reclaim your account.",
                style: theme.textTheme.bodySmall!.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 192.h,
              ),
              customButton(
                  context: context,
                  theme: theme,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: "Back to Sign In"),
            ],
          ),
        ),
      ),
    );
  }
}

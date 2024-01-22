import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';

class ChangePasswordSuccessScreen extends StatefulWidget {
  const ChangePasswordSuccessScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordSuccessScreen> createState() => _ChangePasswordSuccessScreenState();
}

class _ChangePasswordSuccessScreenState extends State<ChangePasswordSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                "Password Change Successful",
                style: theme.textTheme.headlineMedium!.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                "Your Password has been changed successfully!",
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
                  title: "Continue"),
            ],
          ),
        ),
      ),
    );
  }
}

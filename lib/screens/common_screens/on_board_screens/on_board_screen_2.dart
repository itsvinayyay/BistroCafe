import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/core/theme/theme.dart';

class OnBoard2 extends StatelessWidget {
  const OnBoard2({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 90.h),
          child: Column(
            children: [
              Hero(
                  tag: 'onboard',
                  child: Image.asset("assets/images/onboard-2.png")),
              SizedBox(
                height: 48.h,
              ),
              SizedBox(
                width: 348.w,
                child: Text(
                  "Savor every moment with BistroCafe",
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                width: 300.w,
                child: Text(
                  "Discover, Order, Enjoy – BistroCafe, your personalized culinary adventure awaits!",
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 42.h,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.signIn);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 60.w, vertical: 18.h),
                ),
                child: Text(
                  "Next",
                  style: theme.textTheme.titleSmall,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

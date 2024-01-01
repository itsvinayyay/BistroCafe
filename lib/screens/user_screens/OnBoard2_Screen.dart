import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';

class OnBoard2 extends StatelessWidget {
  const OnBoard2({Key? key}) : super(key: key);

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
              Image.asset("assets/images/onboard-2.png"),
              SizedBox(
                height: 48.h,
              ),
              SizedBox(
                width: 348.w,
                child: Text(
                  "SMVDU Food Court is where your Comfort Food Lives",
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                width: 244.w,
                child: Text(
                  "Enjoy a fast and smooth food delivery at your Hostels!",
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
                child: Text(
                  "Next",
                  style: theme.textTheme.titleSmall,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 18.h),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

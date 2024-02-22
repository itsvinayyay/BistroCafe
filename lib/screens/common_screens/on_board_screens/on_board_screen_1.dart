import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/core/theme/theme.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';

class OnBoard extends StatelessWidget {
  const OnBoard({super.key});

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
              Hero(tag: 'onboard',child: Image.asset("assets/images/onboard-1.png")),
              SizedBox(
                height: 48.h,
              ),
              SizedBox(
                width: 211.w,
                child: Text(
                  "Find your Comfort Food here",
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
                  "Experience culinary delight with BistroCafe – Your go-to food solution.",
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 42.h,
              ),
              customButton(context: context, theme: theme, onPressed: (){
                Navigator.pushNamed(context, Routes.onboard2);
              }, title: "Next")
            ],
          ),
        ),
      ),
    );
  }


}

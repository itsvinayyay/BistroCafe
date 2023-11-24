import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';

class OnBoard extends StatelessWidget {
  const OnBoard({Key? key}) : super(key: key);

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
              Image.asset("assets/images/onboard-1.png"),
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
                width: 244.w,
                child: Text(
                  "Here You Can find a chef or dish for every taste and color. Enjoy!",
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

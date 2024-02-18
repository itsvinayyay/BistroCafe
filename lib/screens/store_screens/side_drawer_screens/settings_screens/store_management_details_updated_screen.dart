import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/core/theme/theme.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';

class StoreManagementUpdated extends StatelessWidget {
  const StoreManagementUpdated({super.key});

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
                "Details Updated Successfully!",
                style: theme.textTheme.headlineMedium,
              ),
              SizedBox(
                height: 192.h,
              ),
              customButton(
                  context: context,
                  theme: theme,
                  onPressed: () {
                    Navigator.popUntil(
                        context,
                        (route) =>
                            route.settings.name == Routes.store_SettingsScreen);
                  },
                  title: "Back to Settings"),
            ],
          ),
        ),
      ),
    );
  }
}

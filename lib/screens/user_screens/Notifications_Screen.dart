import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_BackButton.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                customBackButton(context, theme),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  height: 66.h,
                  width: 264.w,
                  child: Text(
                    "Notification",
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/icons/success.svg"),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your Order has been accepted!", style: theme.textTheme.labelMedium,),
                          Text("Recently", style: theme.textTheme.bodySmall,),
                        ],
                      ),
                    ],
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}


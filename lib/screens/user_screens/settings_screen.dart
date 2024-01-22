import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/widgets/custom_BackButton.dart';
import 'package:food_cafe/widgets/headings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeCubit themeCubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    themeCubit = BlocProvider.of(context);
  }

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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBackButton(context, theme),
                Text(
                  "Settings",
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "GENERAL",
                  style: theme.textTheme.labelLarge!.copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Change Theme",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                      width: 40.w,
                      child: Switch(
                        value: context.read<ThemeCubit>().state == MyTheme.dark
                            ? true
                            : false,
                        onChanged: (value) {
                          themeCubit.toggleTheme(isDark: value);
                        },
                        activeTrackColor: Color.fromRGBO(108, 117, 125, 0.12),
                        inactiveTrackColor: Color.fromRGBO(108, 117, 125, 0.12),
                        inactiveThumbColor: theme.colorScheme.primary,
                        activeColor: theme.colorScheme.secondary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Divider(
                  color: theme.colorScheme.secondary,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "CAFE MANAGEMENT",
                  style: theme.textTheme.labelLarge!.copyWith(fontSize: 20),
                ),
                buildSettingsOption(
                    theme: theme,
                    iconData: Icons.access_time_filled_rounded,
                    title: "Store Timings",
                    onTap: () {}),
                
                SizedBox(
                  height: 20,
                ),
                Text(
                  "FEEDBACK",
                  style: theme.textTheme.labelLarge!.copyWith(fontSize: 20),
                ),
                buildSettingsOption(
                    theme: theme,
                    iconData: Icons.info_outline_rounded,
                    title: "Who are we?",
                    onTap: () {}),
                buildSettingsOption(
                    theme: theme,
                    iconData: Icons.privacy_tip_outlined,
                    title: "Is my Data Secure?",
                    onTap: () {}),
                buildSettingsOption(
                    theme: theme,
                    iconData: Icons.bug_report,
                    title: "Found a Bug?",
                    onTap: () {}),
                buildSettingsOption(
                    theme: theme,
                    iconData: Icons.feedback,
                    title: "Wanna give us credits?",
                    onTap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}

Column buildSettingsOption(
      {required ThemeData theme,
      required IconData iconData,
      required String title,
      required VoidCallback onTap}) {
    return Column(
      children: [
        CupertinoButton(
          padding: EdgeInsets.only(top: 10),
          onPressed: onTap,
          child: Row(
            children: [
              Icon(
                iconData,
                color: theme.colorScheme.tertiary,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        Divider(
          color: theme.colorScheme.secondary,
        ),
      ],
    );
  }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_back_button.dart';
import 'package:food_cafe/widgets/headings.dart';

class StoreSettingsScreen extends StatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  late ThemeCubit themeCubit;
  @override
  void initState() {
    super.initState();
    themeCubit = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                const SizedBox(
                  height: 20,
                ),
                storeSubHeading(theme: theme, heading: 'GENERAL'),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                         Icon(Icons.lightbulb, color: theme.colorScheme.tertiary,),
                        const SizedBox(
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
                        activeTrackColor:
                            const Color.fromRGBO(108, 117, 125, 0.12),
                        inactiveTrackColor:
                            const Color.fromRGBO(108, 117, 125, 0.12),
                        inactiveThumbColor: theme.colorScheme.primary,
                        activeColor: theme.colorScheme.secondary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                Divider(
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(
                  height: 20,
                ),
                storeSubHeading(theme: theme, heading: 'CAFE MANAGEMENT'),
                buildSettingsOption(
                    theme: theme,
                    iconData: Icons.access_time_filled_rounded,
                    title: "Store Timings",
                    onTap: () async {
                      await checkConnectivity(
                          context: context,
                          onConnected: () {
                            Navigator.pushNamed(
                                context, Routes.store_managementScreen);
                          });
                    }),
                const SizedBox(
                  height: 20,
                ),
                storeSubHeading(theme: theme, heading: 'FEEDBACK'),
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
        padding: const EdgeInsets.only(top: 10),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(
              iconData,
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(
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

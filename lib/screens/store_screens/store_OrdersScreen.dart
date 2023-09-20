import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/widgets/headings.dart';

class store_OrdersScreen extends StatelessWidget {
  store_OrdersScreen({Key? key}) : super(key: key);

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
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Your Orders!",
                  style: theme.textTheme.headlineLarge,
                ),
                SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      ...List.generate(
                        Tabs.length,
                        (index) => tabContainers(
                          theme: theme,
                          name: Tabs[index],
                          onTap: (){}
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Card(
                  elevation: 8,
                  shadowColor: theme.colorScheme.secondary,
                  color: theme.colorScheme.primary,
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dine-In",
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          "26 June 2023 | 12:05",
                          style: theme.textTheme.bodySmall,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade600,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.food_bank_rounded,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Paneer Naan",
                                      style: theme.textTheme.labelSmall,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                Text(
                                  "2",
                                  style: theme.textTheme.labelSmall,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            )
                          ]
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade600,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹ 430",
                              style: theme.textTheme.labelLarge,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "");
                              },
                              child: Text(
                                "Reorder",
                                style: theme.textTheme.titleSmall,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector tabContainers(
      {required ThemeData theme, required String name, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        margin: EdgeInsets.only(right: 10),
        alignment: Alignment.center,
        height: 50,
        width: 130,
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 3.0, color: Colors.white),
          color: theme.colorScheme.secondary,
        ),
        child: Text(
          name,
          style: theme.textTheme.titleSmall,
        ),
      ),
    );
  }

  List<String> Tabs = ["Requested", "Current", "Past"];
}

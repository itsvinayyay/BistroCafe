import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/routes/named_routes.dart';
import 'package:food_cafe/screens/Home_Screen.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_FoodCard.dart';
import 'package:food_cafe/widgets/headings.dart';
import 'package:food_cafe/widgets/store_customCards.dart';

class store_HomeScreen extends StatelessWidget {
  const store_HomeScreen({Key? key}) : super(key: key);

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
                  height: 60,
                ),
                SizedBox(
                  height: 82.h,
                  width: 233.w,
                  child: Text(
                    "Give your best food!",
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    custom_Icons(theme: theme, iconData: Icons.settings, onTap: (){}),
                    custom_Icons(theme: theme, iconData: Icons.menu_book, onTap: (){
                      Navigator.pushNamed(context, Routes.store_menuItems);
                    }),
                    custom_Icons(theme: theme, iconData: Icons.receipt_long, onTap: (){}),
                    custom_Icons(
                        theme: theme, iconData: Icons.add_card_rounded, onTap: (){
                          Navigator.pushNamed(context, Routes.store_addItemsScreen);
                    }),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                subHeading(theme: theme, heading: "Popular Picks available"),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      popularPicks.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: foodCard(
                          theme: theme,
                          image_url: popularPicks[index]["image_url"],
                          foodName: popularPicks[index]["foodName"],
                          mrp: popularPicks[index]["mrp"],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                subHeading(theme: theme, heading: "Past Orders"),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  GestureDetector custom_Icons(
      {required ThemeData theme, required IconData iconData, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          iconData,
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}

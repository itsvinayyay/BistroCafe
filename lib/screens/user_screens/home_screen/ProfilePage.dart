import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';

import 'package:food_cafe/widgets/custom_TextButton.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String personID;
  late String userName = "Some Person";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final state = context.read<LoginCubit>().state;
    if (state is LoginLoggedInState) {
      personID = state.personID;
    } else {
      log("Some State Error Occured in Profile Screen");
      personID = "error";
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Your Profile",
                  style: theme.textTheme.titleMedium,
                ),
                Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.person,
                          size: 80.sp,
                          color: theme.colorScheme.secondary,
                        ),
                        radius: 60.sp,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      userName,
                      style: theme.textTheme.headlineMedium,
                    ),
                    Text(
                      "Shri Mata Vaishno Devi University",
                      style: theme.textTheme.bodyLarge,
                    ),
                    Text(
                      personID,
                      style: theme.textTheme.labelLarge,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BlocConsumer<LoginCubit, LoginState>(
                        builder: (context, state) {
                      if (state is LoginLoggedInState) {
                        return customButton(
                            context: context,
                            theme: theme,
                            onPressed: () {
                              context.read<LoginCubit>().signOut();
                            },
                            title: "Log Out!");
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }, listener: (context, state) {
                      if (state is LoginLoggedOutState) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.signIn, (route) => false);
                      }
                    })
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Order History",
                  style: theme.textTheme.titleSmall,
                ),
                SizedBox(
                  height: 10,
                ),
                _buildOrderHistoryCard(theme, context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card _buildOrderHistoryCard(ThemeData theme, BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: theme.colorScheme.secondary,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
              children: List.generate(
                history.length,
                (index) => itemOrdered(
                  theme: theme,
                  orderName: history[index]["orderName"],
                  qty: history[index]["qty"],
                ),
              ),
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row itemOrdered({
    required ThemeData theme,
    required String orderName,
    required int qty,
  }) {
    return Row(
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
              orderName,
              style: theme.textTheme.labelSmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        Text(
          qty.toString(),
          style: theme.textTheme.labelSmall,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}

List history = [
  {
    "orderName": "Paneer Naan",
    "qty": 1,
  },
  {"orderName": "Chicken Tikka", "qty": 2},
  {"orderName": "Vegetable Biryani", "qty": 3},
  {"orderName": "Butter Chicken", "qty": 1},
  {"orderName": "Pulao Rice", "qty": 4}
];

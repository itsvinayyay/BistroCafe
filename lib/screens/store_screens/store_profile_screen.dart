import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/cubits/user_name_cubit/user_name_cubit.dart';
import 'package:food_cafe/cubits/user_name_cubit/user_name_states.dart';
import 'package:food_cafe/screens/user_screens/settings_screen.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/widgets/custom_BackButton.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String personID;
  late String storeID;
  late UserNameCubit userNameCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameCubit = BlocProvider.of<UserNameCubit>(context);
    final state = context.read<LoginCubit>().state;
    if (state is CafeLoginLoadedState) {
      personID = state.personID;

      storeID = state.storeID;
    } else {
      log("Some State Error Occured in Profile Screen");

      personID = "error";
      storeID = "error";
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
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBackButton(context, theme),
                Text(
                  "Profile",
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(
                  height: 20,
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
                    BlocConsumer<UserNameCubit, UserNameStates>(
                        listener: (context, state) {
                      if (state is UserNameErrorState) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(state.error)));
                      }
                    }, builder: (context, state) {
                      if (state is UserNameLoadingState) {
                        return Text(
                          'Loading',
                          style: theme.textTheme.headlineMedium,
                        );
                      } else if (state is UserNameErrorState) {
                        return Text(
                          'Error',
                          style: theme.textTheme.headlineMedium,
                        );
                      }
                      return Text(
                        state.userName,
                        style: theme.textTheme.headlineMedium,
                      );
                    }),
                    Text(
                      "Shri Mata Vaishno Devi University",
                      style: theme.textTheme.bodyLarge,
                    ),
                    Text(
                      personID,
                      style: theme.textTheme.labelLarge,
                    ),
                    Text(
                      "Store Number for which you're registered",
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'SMVDU101',
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "ACCOUNT RELATED",
                  style: theme.textTheme.labelLarge!.copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                buildSettingsOption(
                    theme: theme,
                    iconData: Icons.change_circle_rounded,
                    title: "Change Information",
                    onTap: () async {
                      await Navigator.pushNamed(
                          context, Routes.changeUserDetailsScreen);
                      userNameCubit.fetchUserName();
                    }),
                buildSettingsOption(
                    theme: theme,
                    iconData: Icons.lock,
                    title: "Change Password",
                    onTap: () {
                      Navigator.pushNamed(context, Routes.changePasswordScreen);
                    }),
                buildSettingsOption(
                    theme: theme,
                    iconData: Icons.person_off_rounded,
                    title: "Deactivate Account",
                    onTap: () {
                      Navigator.pushNamed(
                          context, Routes.deactivateAccountScreen);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

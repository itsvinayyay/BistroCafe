import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/user_name_cubit/user_name_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/user_name_cubit/user_name_states.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/settings_screens/store_settings_screen.dart';
import 'package:food_cafe/core/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/widgets/custom_back_button.dart';
import 'package:food_cafe/widgets/custom_snackbar.dart';

class StoreProfileScreen extends StatefulWidget {
  const StoreProfileScreen({super.key});

  @override
  State<StoreProfileScreen> createState() => _StoreProfileScreenState();
}

class _StoreProfileScreenState extends State<StoreProfileScreen> {
  late String personID;
  late String storeID;
  late UserNameCubit userNameCubit;

  @override
  void initState() {
    super.initState();
    userNameCubit = BlocProvider.of<UserNameCubit>(context);
    MapEntry<String, String> cafeInfo = checkLoginStateForCafeOwner(
        context: context, screenName: 'Store Profile Screen');
    personID = cafeInfo.key;
    storeID = cafeInfo.value;
  }

  @override
  void dispose() {
    super.dispose();
    userNameCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
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
                  "Profile",
                  style: theme.textTheme.titleLarge,
                ),
                Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 60.sp,
                        child: Icon(
                          Icons.person,
                          size: 80.sp,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocConsumer<UserNameCubit, UserNameStates>(
                        listener: (context, state) {
                      if (state is UserNameErrorState) {
                        showSnackBar(context: context, error: state.error);
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
                      storeID,
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "ACCOUNT RELATED",
                  style: theme.textTheme.labelLarge!.copyWith(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                buildSettingsOption(
                    theme: theme,
                    iconData: Icons.change_circle_rounded,
                    title: "Change Information",
                    onTap: () async {
                      await Navigator.pushNamed(
                          context, Routes.changeUserDetailsScreen,
                          arguments: true);
                      userNameCubit.fetchUserName();
                    }),
                buildSettingsOption(
                    theme: theme,
                    iconData: Icons.lock,
                    title: "Change Password",
                    onTap: () {
                      Navigator.pushNamed(context, Routes.changePasswordScreen);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

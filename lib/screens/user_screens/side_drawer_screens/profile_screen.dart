import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/common_cubits/user_name_cubit/user_name_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/user_name_cubit/user_name_states.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/settings_screens/store_settings_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_back_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String personID;
  late UserNameCubit _userNameCubit;

  void _initializeCubits() {
    _userNameCubit = BlocProvider.of<UserNameCubit>(context);
    personID =
        checkLoginStateForUser(context: context, screenName: 'Profile Screen');
  }

  @override
  void initState() {
    super.initState();
    _initializeCubits();
  }

  @override
  void dispose() {
    super.dispose();
    _userNameCubit.close();
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
                  "Profile",
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 20,
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
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(state.error)));
                      }
                    }, builder: (context, state) {
                      if (state is UserNameLoadingState) {
                        return Text(
                          'Loading...',
                          style: theme.textTheme.headlineMedium,
                        );
                      } else if (state is UserNameErrorState) {
                        return Text(
                          'Error Loading User Name',
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
                          arguments: false);
                      _userNameCubit.fetchUserName();
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

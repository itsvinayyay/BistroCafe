import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';

class SignUpSuccess extends StatefulWidget {
  const SignUpSuccess({Key? key}) : super(key: key);

  @override
  State<SignUpSuccess> createState() => _SignUpSuccessState();
}

class _SignUpSuccessState extends State<SignUpSuccess> {
  late bool isUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final state = context.read<LoginCubit>().state;
    if (state is LoginLoggedInState) {
      isUser = true;
    } else if (state is CafeLoginLoadedState) {
      isUser = false;
    }
  }

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
                "Congrats!",
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
                "Your Profile is Ready To Use",
                style: theme.textTheme.headlineMedium,
              ),
              SizedBox(
                height: 192.h,
              ),
              customButton(
                  context: context,
                  theme: theme,
                  onPressed: () {
                    isUser == true
                        ? Navigator.pushNamedAndRemoveUntil(
                            context, Routes.bottomNav, (route) => false)
                        : Navigator.pushNamedAndRemoveUntil(
                            context, Routes.store_HomeScreen, (route) => false);
                  },
                  title: "Proceed"),
            ],
          ),
        ),
      ),
    );
  }
}

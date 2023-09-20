import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';

class SignUpVerification extends StatefulWidget {
  const SignUpVerification({Key? key}) : super(key: key);

  @override
  State<SignUpVerification> createState() => _SignUpVerificationState();
}

class _SignUpVerificationState extends State<SignUpVerification> {
  String? rollNo;

  @override
  Widget build(BuildContext context) {
    rollNo = ModalRoute.of(context)!.settings.arguments as String;
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              children: [
                SizedBox(
                  height: 48.h,
                ),
                Image.asset("assets/images/logo.png"),
                Text(
                  "Pure Flavours",
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.w, right: 16.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 60.h,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Entry No.",
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          rollNo!,
                          style: theme.textTheme.labelLarge,
                        ),
                      ],
                    )),
                SizedBox(
                  height: 25.h,
                ),
                Text(
                  "Verify your Account!",
                  style: theme.textTheme.headlineMedium,
                ),
                SizedBox(
                  height: 10.h,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    // height: 300.h,
                    child: Image.asset("assets/images/demoSignup.gif"),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginLoggedInState) {
                      print("Successfully Logged In!!!!!!!!!");
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.signUpSuccess, (route) => false);
                    }
                    else if (state is LoginuserNotVerifiedState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("You're not verified!"),
                        ),
                      );
                    } else if (state is LoginErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                    // else if(state is LoginrequiredVerificationState){
                    //   return customButton(
                    //       context: context,
                    //       theme: theme,
                    //       onPressed: () {
                    //         BlocProvider.of<LoginCubit>(context).verifyUser();
                    //       },
                    //       title: "Verify");
                    // }
                    return customButton(
                        context: context,
                        theme: theme,
                        onPressed: () {
                          BlocProvider.of<LoginCubit>(context)
                              .verifyUser(rollNo!);
                        },
                        title: "Verify");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

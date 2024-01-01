import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';

class SignUpVerification extends StatefulWidget {
  const SignUpVerification({Key? key}) : super(key: key);

  @override
  State<SignUpVerification> createState() => _SignUpVerificationState();
}

class _SignUpVerificationState extends State<SignUpVerification> {
  late String entryNo;
  bool isUser = true;
  Timer? _timer;

  void startTimer() {
    const duration = Duration(seconds: 30);
    _timer = Timer(duration, () {
      print("Completed!");
      context.read<TimerCubit>().enableResendButton();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    entryNo = context.read<LoginCubit>().getEntryNo();
    final state = context.read<LoginCubit>().state;
    if(state is CafeLoginRequiredVerificationState){
      isUser = false;
    }
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 48),
            child: Column(
              children: [
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
                          entryNo,
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
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.signUpSuccess, (route) => false, arguments: isUser);
                    } else if (state is LoginuserNotVerifiedState) {
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
                    return customButton(
                        context: context,
                        theme: theme,
                        onPressed: () {
                          isUser == true ? BlocProvider.of<LoginCubit>(context)
                              .verifyUser(entryNo) : BlocProvider.of<LoginCubit>(context)
                              .verifycafeOwner(entryNo);
                        },
                        title: "Verify");
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Didn't received verification mail?",
                  style: TextStyle(
                      color: Color(0XFF6B50F6),
                      fontWeight: FontWeight.w400,
                      fontFamily: "BentonSans_Medium",
                      fontSize: 12.sp,
                      decoration: TextDecoration.underline),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Resend button will be activated in ",
                      style: TextStyle(
                        color: Color(0XFF6B50F6),
                        fontWeight: FontWeight.w400,
                        fontFamily: "BentonSans_Medium",
                        fontSize: 12.sp,
                      ),
                    ),
                    buildTimer(),
                  ],
                ),
                BlocBuilder<TimerCubit, bool>(
                  builder: (context, state) {
                    if (state == true) {
                      return BlocProvider(
                        create: (context) => ResendVerificationCubit(),
                        child: BlocBuilder<ResendVerificationCubit, bool>(
                          builder: (context, state) {
                            if(state == false){
                              return TextButton(
                                onPressed: () {
                                  context
                                      .read<ResendVerificationCubit>()
                                      .resendVerification();
                                },
                                // Button is inactive when _isButtonActive is false.
                                child: Text(
                                  "Resend",
                                  style: theme.textTheme.labelLarge,
                                ),
                              );
                            }
                            return Text(
                              "Sent",
                              style: theme.textTheme.labelMedium,
                            );
                          },
                        ),
                      );
                    }
                    return Text(
                      "Please Wait...",
                      style: theme.textTheme.labelMedium,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TweenAnimationBuilder<double> buildTimer() {
    return TweenAnimationBuilder(
      tween: Tween(begin: 30.00, end: 0.00),
      duration: Duration(seconds: 30),
      builder: (BuildContext context, double value, Widget? child) => Text(
        "00:${value.toInt()}",
      ),
    );
  }
}

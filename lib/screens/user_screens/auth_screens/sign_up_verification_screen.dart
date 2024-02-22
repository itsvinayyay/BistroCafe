import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_state.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_snackbar.dart';

class SignUpVerification extends StatefulWidget {
  const SignUpVerification({super.key});

  @override
  State<SignUpVerification> createState() => _SignUpVerificationState();
}

class _SignUpVerificationState extends State<SignUpVerification> {
  late String personID;
  late String storeID;
  late LoginCubit _loginCubit;
  late TimerCubit _timerCubit;
  late ResendVerificationCubit _resendVerificationCubit;
  late ResendVerificationCubit resendVerificationCubit;
  late bool isUser;
  Timer? _timer;

  void startTimer() {
    const duration = Duration(seconds: 30);
    _timer = Timer(duration, () {
      print("Completed!");
      _timerCubit.enableResendButton();
    });
  }

  @override
  void initState() {
    super.initState();
    //Cubit Initialization
    resendVerificationCubit = BlocProvider.of<ResendVerificationCubit>(context);
    _loginCubit = BlocProvider.of<LoginCubit>(context);
    _timerCubit = BlocProvider.of<TimerCubit>(context);
    _resendVerificationCubit =
        BlocProvider.of<ResendVerificationCubit>(context);
    final state = context.read<LoginCubit>().state;
    //Checking if the User is User or a  Store Owner...
    if (state is CafeLoginRequiredVerificationState) {
      isUser = false;
      storeID = state.storeID;
      personID = state.personID;
    } else if (state is LoginRequiredVerificationState) {
      isUser = true;
      personID = state.personID;
    }
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerCubit.close();
    _resendVerificationCubit.close();

    super.dispose();
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
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 48),
            child: Column(
              children: [
                Hero(
                    tag: 'logo2',
                    child: Image.asset(
                      "assets/images/logo2.png",
                      height: 200.h,
                    )),
                const SizedBox(
                  height: 20,
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
                          personID,
                          style: theme.textTheme.labelLarge,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 25,
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
                const SizedBox(
                  height: 30,
                ),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginLoggedInState) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.signUpSuccess,
                        (route) => false,
                      );
                    } else if (state is LoginUserNotVerifiedState) {
                      showSnackBar(
                          context: context, error: "You're not Verified.");
                    } else if (state is LoginErrorState) {
                      showSnackBar(context: context, error: state.error);
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginLoadingState) {
                      return const CustomCircularProgress();
                    }
                    return customButton(
                        context: context,
                        theme: theme,
                        onPressed: () async {
                          await checkConnectivity(
                              context: context,
                              onConnected: () {
                                isUser == true
                                    ? _loginCubit.verifyUser(personID: personID)
                                    : _loginCubit.verifyCafeOwner(
                                        personID: personID, storeID: storeID);
                              });
                        },
                        title: "Verify");
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Didn't received verification mail?",
                  style: TextStyle(
                      color: const Color(0XFF6B50F6),
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
                        color: const Color(0XFF6B50F6),
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
                      return BlocBuilder<ResendVerificationCubit, bool>(
                        builder: (context, state) {
                          if (state == false) {
                            return TextButton(
                              onPressed: () async {
                                await checkConnectivity(
                                    context: context,
                                    onConnected: () {
                                      resendVerificationCubit
                                          .resendVerification();
                                    });
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
      duration: const Duration(seconds: 30),
      builder: (BuildContext context, double value, Widget? child) => Text(
        "00:${value.toInt()}",
      ),
    );
  }
}

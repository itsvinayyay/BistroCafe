import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';
import 'package:food_cafe/widgets/custom_TextFormField.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 48.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png"),
                  Text(
                    "Pure Flavours",
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(
                    height: 47.h,
                  ),
                  Text(
                    "Login to your Account",
                    style: theme.textTheme.headlineMedium,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  customTextFormField(
                      theme: theme,
                      hintText: "Email",
                      controller: _emailController),
                  SizedBox(
                    height: 12.h,
                  ),
                  customTextFormField(
                      theme: theme,
                      hintText: "Password",
                      controller: _passwordController),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Or Continue With",
                    style: theme.textTheme.titleSmall,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 154.w,
                    padding:
                        EdgeInsets.symmetric(vertical: 22.h, horizontal: 24.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_add_alt_1_rounded,
                          color: theme.colorScheme.secondary,
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Text(
                          "Sign Up",
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Forgot your Password?",
                    style: TextStyle(
                        color: Color(0XFF6B50F6),
                        fontWeight: FontWeight.w400,
                        fontFamily: "BentonSans_Medium",
                        fontSize: 12.sp,
                        decoration: TextDecoration.underline),
                  ),
                  SizedBox(
                    height: 36.h,
                  ),
                  BlocConsumer<LoginCubit, LoginState>(
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
                          BlocProvider.of<LoginCubit>(context).signinwith_Email(
                              _emailController.text, _passwordController.text);
                        },
                        title: "Verify");
                  }, listener: (context, state) {
                    if (state is LoginLoggedInState) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.bottomNav, (route) => false);
                    } else if (state is LoginErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                        ),
                      );
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

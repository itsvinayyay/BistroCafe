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

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  //TODO: Make these variables more relevant
  bool ispasswordVisible = false;
  bool isconfirmpasswordVisible = true;

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
                  "Create your Account",
                  style: theme.textTheme.headlineMedium,
                ),
                SizedBox(
                  height: 40.h,
                ),
                customTextFormField(
                    theme: theme,
                    hintText: "Name",
                    controller: _nameController,
                    prefixIcon: "profile"),
                SizedBox(
                  height: 12.h,
                ),
                customTextFormField(
                    theme: theme,
                    hintText: "Email",
                    controller: _emailController,
                    prefixIcon: "message"),
                SizedBox(
                  height: 12.h,
                ),
                customTextFormField(
                  theme: theme,
                  hintText: "Password",
                  controller: _passwordController,
                  prefixIcon: "lock",
                  // onTap: () => setState(() {
                  //       ispasswordVisible = !ispasswordVisible;
                  //     }),
                  onTap: () {
                    BlocProvider.of<PasswordVisibility>(context)
                        .toggleVisibility();
                    print("TAPPED");
                  },
                  obscure: context.watch<PasswordVisibility>().state,
                ),
                SizedBox(
                  height: 12.h,
                ),
                customTextFormField(
                    theme: theme,
                    hintText: "Confirm Password",
                    controller: _confirmPasswordController,
                    prefixIcon: "lock",
                    onTap: () => setState(() {
                          isconfirmpasswordVisible = !isconfirmpasswordVisible;
                        }),
                    obscure: isconfirmpasswordVisible),
                SizedBox(
                  height: 118.h,
                ),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginrequiredVerificationState) {
                      Navigator.pushNamed(context, Routes.signupVerification);
                    } else if (state is LoginErrorState) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return customButton(
                        context: context,
                        theme: theme,
                        onPressed: () {
                          BlocProvider.of<LoginCubit>(context).signupwith_Email(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text);
                        },
                        title: "Create Account");
                  },
                ),
                SizedBox(
                  height: 14.h,
                ),
                Text(
                  "Already have an Account?",
                  style: TextStyle(
                      color: Color(0XFF6B50F6),
                      fontWeight: FontWeight.w400,
                      fontFamily: "BentonSans_Medium",
                      fontSize: 12.sp,
                      decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

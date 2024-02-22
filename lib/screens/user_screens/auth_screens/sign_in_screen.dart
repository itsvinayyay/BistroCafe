import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/common_cubits/password_visibility_cubits/password_visibility_cubits.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/core/theme/theme.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/utils/constants.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';
import 'package:food_cafe/widgets/custom_TextFormField.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late PasswordVisibility _passwordVisibility;
  final _formkey = GlobalKey<FormState>();
  late LoginCubit _loginCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginCubit = BlocProvider.of<LoginCubit>(context);
    _passwordVisibility = BlocProvider.of<PasswordVisibility>(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _passwordVisibility.close();
  }

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
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 48.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(tag: 'logo2',child: Image.asset("assets/images/logo2.png", height: 200.h,)),
                  const SizedBox(height: 20,),
                  Text(
                    "Login to your Account",
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        customTextFormField(
                          theme: theme,
                          hintText: "Email",
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return kEmailNullError;
                            } else if (!value.trim().endsWith('@smvdu.ac.in')) {
                              return kInvalidEmailError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        customTextFormField(
                          theme: theme,
                          hintText: "Password",
                          controller: _passwordController,
                          prefixIcon: "lock",
                          onTap: () {
                            _passwordVisibility.toggleVisibility();
                          },
                          obscure: context.watch<PasswordVisibility>().state,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return kNullPasswordError;
                            } else if (value.length < 6) {
                              return kShortPasswordError;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Or Continue with/as",
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.signUp);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 22.h, horizontal: 24.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_add_alt_1_rounded,
                                color: theme.colorScheme.secondary,
                              ),
                              const SizedBox(
                                width: 13,
                              ),
                              Text(
                                "Sign Up",
                                style: theme.textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.store_SignIn);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 22.h, horizontal: 24.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: theme.colorScheme.secondary,
                              ),
                              const SizedBox(
                                width: 13,
                              ),
                              Text(
                                "Cafe Owner",
                                style: theme.textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.forgotPasswordScreen);
                    },
                    child: Text(
                      "Forgot your Password?",
                      style: TextStyle(
                          color: const Color(0XFF6B50F6),
                          fontWeight: FontWeight.w400,
                          fontFamily: "BentonSans_Medium",
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  BlocConsumer<LoginCubit, LoginState>(
                      builder: (context, state) {
                    if (state is LoginLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                    return customButton(
                        context: context,
                        theme: theme,
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            await checkConnectivity(
                                context: context,
                                onConnected: () {
                                  _loginCubit.signInUserWithEmail(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  );
                                });
                          }
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
                    } else if (state is LoginRequiredVerificationState) {
                      Navigator.pushNamed(context, Routes.signupVerification);
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

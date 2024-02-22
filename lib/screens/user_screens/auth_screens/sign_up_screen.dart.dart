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

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late LoginCubit loginCubit;

  late PasswordVisibility passwordVisibility;
  late ConfirmPasswordVisibility confirmPasswordVisibility;
  @override
  void initState() {
    
    super.initState();
    loginCubit = BlocProvider.of<LoginCubit>(context);
    passwordVisibility = BlocProvider.of<PasswordVisibility>(context);
    confirmPasswordVisibility =
        BlocProvider.of<ConfirmPasswordVisibility>(context);
  }

  @override
  void dispose() {
    
    super.dispose();
    passwordVisibility.close();
    confirmPasswordVisibility.close();
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
            padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 48.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(tag: 'logo2',child: Image.asset("assets/images/logo2.png", height: 200.h,)),
                  const SizedBox(height: 20,),
                  Text(
                    "Create your Account",
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  customTextFormField(
                    theme: theme,
                    hintText: "Name",
                    controller: _nameController,
                    prefixIcon: "profile",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return kNameNull;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  customTextFormField(
                    theme: theme,
                    hintText: "Email",
                    controller: _emailController,
                    prefixIcon: "message",
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
                      passwordVisibility.toggleVisibility();
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
                  const SizedBox(
                    height: 12,
                  ),
                  customTextFormField(
                      theme: theme,
                      hintText: "Confirm Password",
                      controller: _confirmPasswordController,
                      prefixIcon: "lock",
                      onTap: () => confirmPasswordVisibility.toggleVisibility(),
                      obscure: context.watch<ConfirmPasswordVisibility>().state,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return kConfPasswordError;
                        }
                        if (value.trim() != _passwordController.text.trim()) {
                          return kNoPasswordMatchError;
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 40,
                  ),
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginRequiredVerificationState) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.signupVerification, (route) => false);
                      } else if (state is LoginErrorState) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(state.error)));
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.tertiary,
                          ),
                        );
                      }
                      return customButton(
                          context: context,
                          theme: theme,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await checkConnectivity(
                                  context: context,
                                  onConnected: () {
                                    loginCubit.signUpUserWithEmail(
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim(),
                                        name: _nameController.text.trim());
                                  });
                            }
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
                        color: const Color(0XFF6B50F6),
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
      ),
    );
  }
}

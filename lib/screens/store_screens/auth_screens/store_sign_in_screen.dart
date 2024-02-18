import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/common_cubits/password_visibility_cubits/password_visibility_cubits.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/utils/constants.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';
import 'package:food_cafe/widgets/custom_TextFormField.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_snackbar.dart';

class StoreSignInScreen extends StatefulWidget {
  const StoreSignInScreen({super.key});

  @override
  State<StoreSignInScreen> createState() => _StoreSignInScreenState();
}

class _StoreSignInScreenState extends State<StoreSignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late PasswordVisibility _passwordVisibility;
  final _formKey = GlobalKey<FormState>();
  late LoginCubit _loginCubit;

  void _initializeCubits() {
    _loginCubit = BlocProvider.of<LoginCubit>(context);
    _passwordVisibility = BlocProvider.of<PasswordVisibility>(context);
  }

  @override
  void initState() {
    super.initState();
    _initializeCubits();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordVisibility.close();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 48.h),
              child: Form(
                key: _formKey,
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
                      "Login as a Cafe Owner",
                      style: theme.textTheme.headlineMedium,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    customTextFormField(
                        theme: theme,
                        hintText: "Email",
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return kEmailNullError;
                          } else if (!EmailValidator.validate(value.trim())) {
                            return kInvalidEmailError;
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 12.h,
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
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Forgot your Password?",
                      style: TextStyle(
                          color: const Color(0XFF6B50F6),
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
                      if (state is CafeLoginLoadingState) {
                        return const CustomCircularProgress();
                      }
                      return customButton(
                          context: context,
                          theme: theme,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await checkConnectivity(
                                  context: context,
                                  onConnected: () {
                                    _loginCubit.signInCafeOwnerwithEmail(
                                        _emailController.text,
                                        _passwordController.text);
                                  });
                            }
                          },
                          title: "Verify");
                    }, listener: (context, state) {
                      if (state is CafeLoginLoadedState) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.store_HomeScreen, (route) => false);
                      } else if (state is CafeLoginErrorState) {
                        showSnackBar(context: context, error: state.error);
                      } else if (state is CafeLoginRequiredVerificationState) {
                        Navigator.pushNamed(context, Routes.signupVerification);
                      }
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

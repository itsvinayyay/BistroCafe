import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/utils/constants.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';
import 'package:food_cafe/widgets/custom_TextFormField.dart';

class store_SignIn extends StatefulWidget {
  const store_SignIn({Key? key}) : super(key: key);

  @override
  State<store_SignIn> createState() => _store_SignInState();
}

class _store_SignInState extends State<store_SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late LoginCubit loginCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginCubit = BlocProvider.of<LoginCubit>(context);
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
            physics: BouncingScrollPhysics(),
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
                            return kemailnullerror;
                          } else if (!EmailValidator.validate(value.trim())) {
                            return kvalidemailerror;
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return knullpasserror;
                        } else if (value.length < 6) {
                          return kshortpass;
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
                      if (state is CafeLoginLoadingState) {
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
                            if (_formKey.currentState!.validate()) {
                              loginCubit.cafe_signinwith_Email(
                                  _emailController.text,
                                  _passwordController.text);
                            }
                          },
                          title: "Verify");
                    }, listener: (context, state) {
                      if (state is CafeLoginLoadedState) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.store_HomeScreen, (route) => false);
                      } else if (state is CafeLoginErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                          ),
                        );
                      } else if (state is CafeLoginRequiredVerificationState) {
                        //TODO add route
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

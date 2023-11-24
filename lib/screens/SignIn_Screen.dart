import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/utils/constants.dart';
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
  final _formkey = GlobalKey<FormState>();

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
                  BlocBuilder<SignInErrorsCubit, List<String>>(
                    builder: (context, state) {
                      return Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            customTextFormField(
                              theme: theme,
                              hintText: "Email",
                              controller: _emailController,
                              onChanged: (value) {
                                if (value.isNotEmpty &&
                                    state.contains(kemailnullerror)) {
                                  BlocProvider.of<SignInErrorsCubit>(context).removeSignInError(kemailnullerror);
                                } else if (value.endsWith("@smvdu.ac.in") &&
                                    state.contains(kvalidemailerror)) {
                                  BlocProvider.of<SignInErrorsCubit>(context).removeSignInError(kvalidemailerror);
                                }
                                return null;
                              },
                              validator: (value) {
                                if (value!.isEmpty &&
                                    !state.contains(kemailnullerror)) {
                                  BlocProvider.of<SignInErrorsCubit>(context).addSignInError(kemailnullerror);
                                } else if (value != null &&
                                    !value.endsWith("@smvdu.ac.in") &&
                                    !state.contains(kvalidemailerror) &&
                                    !state.contains(kemailnullerror)) {
                                  BlocProvider.of<SignInErrorsCubit>(context).addSignInError(kvalidemailerror);
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            customTextFormField(
                                theme: theme,
                                hintText: "Password",
                                controller: _passwordController,
                              onChanged: (value) {
                                if (value.isNotEmpty &&
                                    state.contains(knullpasserror)) {
                                  BlocProvider.of<SignInErrorsCubit>(context).removeSignInError(knullpasserror);
                                } else if (value.length > 6 &&
                                    state.contains(kshortpass)) {
                                  BlocProvider.of<SignInErrorsCubit>(context).removeSignInError(kshortpass);
                                }
                                return null;
                              },
                              validator: (value) {
                                if (value != null &&
                                    value.isEmpty &&
                                    !state.contains(knullpasserror)) {
                                  BlocProvider.of<SignInErrorsCubit>(context).addSignInError(knullpasserror);
                                } else if (value != null &&
                                    value.length < 6 &&
                                    !state.contains(kshortpass) &&
                                    !state.contains(knullpasserror)) {
                                  BlocProvider.of<SignInErrorsCubit>(context).addSignInError(kshortpass);
                                }
                                return null;
                              },
                            ),
                            Column(
                              children: List.generate(
                                state.length,
                                (index) => Row(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      size: 20,
                                      color: Colors.red.shade200,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      state[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Or Continue with/as",
                    style: theme.textTheme.titleSmall,
                  ),
                  SizedBox(
                    height: 20.h,
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
                              SizedBox(
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
                          if(_formkey.currentState!.validate()){
                            if(context.read<SignInErrorsCubit>().state.isEmpty){
                              BlocProvider.of<LoginCubit>(context).signinwith_Email(
                                  _emailController.text, _passwordController.text);
                            }
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

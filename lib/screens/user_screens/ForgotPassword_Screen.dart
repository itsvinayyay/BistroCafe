import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';
import 'package:food_cafe/widgets/custom_TextFormField.dart';
import 'package:food_cafe/widgets/headings.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();
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
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                loginHeader(
                    context: context,
                    theme: theme,
                    title: "Forgot Password?",
                    subheading:
                        "Enter your email on which you wish to receive verification link"),
                SizedBox(height: 20.h,),
                customTextFormField(theme: theme, hintText: "Email", controller: _emailController),
                SizedBox(height: 350.h,),
                Center(child: customButton(context: context, theme: theme, onPressed: (){}, title: "Next")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

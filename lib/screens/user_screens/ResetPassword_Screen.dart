import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';
import 'package:food_cafe/widgets/custom_TextFormField.dart';
import 'package:food_cafe/widgets/headings.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
  bool ispasswordVisible = true;
  bool isconfirmpasswordVisible = true;
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
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                loginHeader(context: context, theme: theme, title: "Reset your password here", subheading: "Enter your new password",),
                SizedBox(height: 40.h,),
                customTextFormField(theme: theme, hintText: "Password", controller: _passwordController, prefixIcon: "lock", onTap: () => setState(() {
                  ispasswordVisible = !ispasswordVisible;
                }), obscure: ispasswordVisible),
                SizedBox(height: 12.h,),
                customTextFormField(theme: theme, hintText: "Confirm Password", controller: _confirmpasswordController, prefixIcon: "lock", onTap: () => setState(() {
                  isconfirmpasswordVisible = !isconfirmpasswordVisible;
                }), obscure: isconfirmpasswordVisible),
                SizedBox(height: 290.h,),
                Center(child: customButton(context: context, theme: theme,onPressed: (){}, title: "Next")),
              ],
            ),
          ),
        ),

      ),
    );
  }
}

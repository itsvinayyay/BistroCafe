import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';

class ChangeUserDetailsSuccessScreen extends StatefulWidget {
  const ChangeUserDetailsSuccessScreen({super.key});

  @override
  State<ChangeUserDetailsSuccessScreen> createState() =>
      _ChangeUserDetailsSuccessScreenState();
}

class _ChangeUserDetailsSuccessScreenState
    extends State<ChangeUserDetailsSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/signup_success.png"),
              SizedBox(
                height: 33.h,
              ),
              Text(
                "Success!",
                style: theme.textTheme.labelLarge!.copyWith(fontSize: 30),
              ),
              Text(
                "Details Updation Successful",
                style: theme.textTheme.headlineMedium!.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                "Your Details has been changed successfully!",
                style: theme.textTheme.bodySmall!.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 192.h,
              ),
              customButton(
                  context: context,
                  theme: theme,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: "back to Profile"),
            ],
          ),
        ),
      ),
    );
  }
}

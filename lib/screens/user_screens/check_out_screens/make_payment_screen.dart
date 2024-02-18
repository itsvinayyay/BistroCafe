import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';

class MakePaymentScreen extends StatelessWidget {
  const MakePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset("assets/images/upiPayment.gif")),
                  SizedBox(
                    height: 33.h,
                  ),
                  Text(
                    "Make Payment!",
                    style: TextStyle(
                        fontSize: 30.sp,
                        fontFamily: "BentonSans_Bold",
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.tertiary),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    "Please make Payment so we can start perparing your order",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 250.w,
                    child: Text(
                      "You can Alternatively pay on +91 8800XX32XX",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
              customButton(
                  context: context,
                  theme: theme,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.bottomNav, (route) => false);
                  },
                  title: "Back to Home"),
            ],
          ),
        ),
      ),
    );
  }
}

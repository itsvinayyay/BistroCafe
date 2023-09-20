import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SubsequentLayout extends StatelessWidget {
  final ThemeData theme;
  final Widget child;
  const SubsequentLayout({Key? key, required this.theme, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.h,),
          child: Expanded(child: SingleChildScrollView(child: child, physics: BouncingScrollPhysics(),)),
        ),
      ),
    );
  }
}

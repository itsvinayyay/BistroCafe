import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


ThemeData lightTheme = ThemeData(


  colorScheme: ColorScheme.dark(
    background: Colors.white,
    primary: Colors.white,
    secondary: Color(0XFF6B50F6),
    tertiary: Color(0XFF6B50F6),
    brightness: Brightness.light,
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontFamily: 'BentonSans_Bold',
      fontSize: 34.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
    ), //Largest Headline
    titleMedium: TextStyle(
      fontFamily: 'BentonSans_Bold',
      fontSize: 25.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
    ),
    titleSmall: TextStyle(
      fontFamily: 'BentonSans_Bold',
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
    ),
    headlineLarge: TextStyle(
      fontFamily: 'BentonSans_Bold',
      fontSize: 30.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
    ),
    headlineMedium: TextStyle(
      fontFamily: 'BentonSans_Bold',
      fontSize: 22.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
      height: 1.25,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'BentonSans_Bold',
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
    ),
    bodyMedium: TextStyle(
      fontFamily: 'BentonSans_Book',
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
    ),
  ),
);

ThemeData darkTheme = ThemeData(

  colorScheme: ColorScheme.dark(
    background: Color(0XFF2A2C38),
    primary: Color(0XFF222222),
    secondary: Color(0XFF4023D7),
    tertiary: Color(0XFF6B50F6),
    brightness: Brightness.dark,
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontFamily: 'BentonSans_Bold',
      fontSize: 34.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
    ), //Largest Headline
    titleMedium: TextStyle(
      fontFamily: 'BentonSans_Bold',
      fontSize: 25.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
      height: 1.35,
    ),
    titleSmall: TextStyle(
      fontFamily: 'BentonSans_Bold',
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
      height: 1.10,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'BentonSans_Bold',
      fontSize: 31.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
      height: 1.35
    ),
    headlineMedium: TextStyle(
      fontFamily: 'BentonSans_Bold',
      fontSize: 22.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
      height: 1.25,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'BentonSans_Bold',
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
    ),
    bodyLarge: TextStyle(
      fontFamily: 'BentonSans_Book',
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
    ),
    bodyMedium: TextStyle(
      fontFamily: 'BentonSans_Book',
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
      height: 1.75,
    ),
    bodySmall: TextStyle(
      fontFamily: 'BentonSans_Book',
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFC4C4C4),
      height: 1.10,
    ),
    labelLarge: TextStyle(
      fontFamily: 'BentonSans_Bold',
      fontSize: 19.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFF4023D7),
    ),
    labelMedium: TextStyle(
      fontFamily: 'BentonSans_Medium',
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: Color(0XFFE8E5F8),
    ),
    labelSmall: TextStyle(
      fontFamily: 'BentonSans_Book',
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: Color(0XFFEAE6F9),
      height: 1.25,
    ),
  ),



);
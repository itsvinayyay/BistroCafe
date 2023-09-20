import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextButton customButton({ required BuildContext context, required ThemeData theme, required VoidCallback onPressed, required String title}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      title,
      style: theme.textTheme.titleSmall,
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 18.h),
    ),
  );
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextButton customButton(
    {required BuildContext context,
    required ThemeData theme,
    required VoidCallback onPressed,
    required String title}) {
  return TextButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 18.h),
    ),
    child: Text(
      title,
      style: theme.textTheme.titleSmall,
    ),
  );
}

CupertinoButton customTryButton(
    {
    required ThemeData theme,
    required VoidCallback onPressed}) {
  return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.tertiary, width: 3),
        ),
        child: Text(
          'Try Again',
          style: theme.textTheme.titleSmall,
        ),
      ));
}

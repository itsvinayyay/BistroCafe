import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

TextFormField customTextFormField({required ThemeData theme, required String hintText, required TextEditingController controller, String? prefixIcon, VoidCallback? onTap, bool? obscure, bool? autoFocus}) {
  return TextFormField(
    autofocus: autoFocus ?? false,
    controller: controller,
    decoration: InputDecoration(
      fillColor: theme.colorScheme.primary,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(width: 0, color: theme.colorScheme.primary)
      ),
      hintText: hintText,
      hintStyle: theme.textTheme.bodySmall,
      contentPadding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 22.h),
      prefixIcon: prefixIcon == null ? null : Padding(
        padding: EdgeInsets.only(left: 20.w, right: 16.w),
        child: SvgPicture.asset("assets/icons/$prefixIcon.svg",),
      ),
      suffixIcon: prefixIcon == "lock" ? GestureDetector(onTap: onTap,child: Icon(Icons.remove_red_eye_rounded, color: Colors.black,)) : null,

      // prefixIconConstraints: BoxConstraints(minWidth: 24, maxWidth: 24, minHeight: 24, maxHeight: 24)

      // prefix: Padding(
      //   padding: EdgeInsets.only(left: 0),
      //   child: SvgPicture.asset("assets/icons/$prefixIcon.svg",),
      // )

    ),
    style: theme.textTheme.bodyLarge,
    cursorColor: theme.colorScheme.secondary,
    obscureText: obscure == null ? false : obscure,
  );
}
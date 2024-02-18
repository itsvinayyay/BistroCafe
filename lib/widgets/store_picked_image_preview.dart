import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ClipRRect storePickedImageView({required File pickedImage}) {
  return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 90.w,
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            pickedImage,
            fit: BoxFit.cover,
          ),
        ),
      ));
}

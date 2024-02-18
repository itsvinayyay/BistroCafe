import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

CupertinoButton storePickImageButton({
  required VoidCallback onTap,
  required ThemeData theme,
  required bool toChangeImage,
}) {
  return CupertinoButton(
    padding: EdgeInsets.zero,
    onPressed: onTap,
    child: DottedBorder(
      color: theme.colorScheme.tertiary,
      strokeWidth: 4,
      dashPattern: <double>[4, 7],
      radius: Radius.circular(20),
      strokeCap: StrokeCap.round,
      borderType: BorderType.Circle,
      child: SizedBox(
        width: 70.w,
        child: AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: theme.colorScheme.tertiary,
                ),
                Text(
                  toChangeImage ? "Change\nImage" : 'Select\nImage',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 12.w,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

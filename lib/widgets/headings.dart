import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/widgets/custom_BackButton.dart';

Column loginHeader({
  required BuildContext context,
  required ThemeData theme,
  required String title,
  required String subheading,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 20.h,
      ),
      customBackButton(context, theme),
      SizedBox(
        height: 20.h,
      ),
      SizedBox(
        height: 66.h,
        width: 264.w,
        child: Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
      ),
      SizedBox(
        height: 19.h,
      ),
      SizedBox(
        width: 239.w,
        child: Text(
          subheading,
          style: theme.textTheme.bodySmall,
        ),
      ),
    ],
  );
}

Text subHeading({required ThemeData theme, required String heading}) {
  return Text(
    heading,
    style: theme.textTheme.titleSmall,
  );
}

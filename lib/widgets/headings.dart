import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/widgets/custom_back_button.dart';

Column loginHeader({
  required BuildContext context,
  required ThemeData theme,
  required String title,
  required String subheading,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      customBackButton(context, theme),
      SizedBox(
        height: 20.h,
      ),
      Text(
        title,
        style: theme.textTheme.titleMedium,
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        width: 239.w,
        child: Text(
          subheading,
          style: theme.textTheme.bodySmall!.copyWith(fontSize: 12),
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

Text storeSubHeading({required ThemeData theme, required String heading}) {
  return Text(
    heading,
    style: theme.textTheme.labelLarge!.copyWith(height: 1),
  );
}

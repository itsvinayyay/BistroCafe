import 'package:flutter/material.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';

class CustomError extends StatelessWidget {
  final String errorMessage;
  final VoidCallback tryAgain;
  const CustomError(
      {super.key, required this.errorMessage, required this.tryAgain});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = getTheme(context: context);

    return Column(
      children: [
        Icon(
          Icons.running_with_errors_rounded,
          size: 40,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            errorMessage,
            style: theme.textTheme.bodyLarge!.copyWith(height: 1.25),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        customTryButton(theme: theme, onPressed: tryAgain),
      ],
    );
  }
}

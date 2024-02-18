import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String error}) {
  ThemeData theme = Theme.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: theme.colorScheme.primary,
      duration: Duration(seconds: 1),
      content: Text(
        error,
        style: theme.textTheme.bodyLarge,
      ),
    ),
  );
}

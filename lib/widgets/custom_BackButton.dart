import 'package:flutter/material.dart';

GestureDetector customBackButton(BuildContext context, ThemeData theme) {
  return GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.secondary,),
    ),
  );
}
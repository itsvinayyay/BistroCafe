import 'package:flutter/material.dart';

import 'package:food_cafe/utils/theme_check.dart';

class CustomEmptyError extends StatelessWidget {
  final String message;
  const CustomEmptyError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage('assets/images/emptyError.gif'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20)),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              message,
              style: theme.textTheme.bodyLarge!.copyWith(height: 1.25),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_cafe/utils/theme_check.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = getTheme(context: context);
    return Center(
      child: Column(children: [
        SpinKitFadingCube(color: theme.colorScheme.secondary,)
      ]),
    );
  }
}

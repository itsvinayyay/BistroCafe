import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_cafe/utils/theme_check.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = getTheme(context: context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Hero(
                tag: 'logo2',
                child: Image.asset(
                            'assets/images/logo2.png',
                            height: 300,
                          ),
              )),
          const SizedBox(height: 60,),
          SpinKitCircle(
            color: theme.colorScheme.secondary,
            size: 60,
          ),
        ],
      ),
    );
  }
}

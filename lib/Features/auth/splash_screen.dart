import 'package:flutter/material.dart';
import 'package:nurtotrack/Core/utils/assets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            Image.asset(AssetsData.splashScreen)
          ],
        ),
      ),
    );
  }
}
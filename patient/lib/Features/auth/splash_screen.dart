import 'package:flutter/material.dart';
import 'package:patient/Core/utils/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.1;

  @override
  void initState() {
    super.initState();

    // Start the animation after a short delay
    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });

    // Navigate to SigninOrSignupScreen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/SigninOrSignup');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: _opacity,
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(_scale),
            child: Image.asset(
              AssetsData.splashScreen,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

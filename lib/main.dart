import 'package:flutter/material.dart';
import 'package:nurtotrack/Features/auth/login.dart';
import 'package:nurtotrack/Features/auth/login_or_reg.dart';
import 'package:nurtotrack/Features/auth/register.dart';
import 'package:nurtotrack/Features/auth/splash_screen.dart';

void main() {
  runApp( MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Define the routes   here
      routes: {
         '/': (context) => const SplashScreen(), // Set SplashScreen as the initial route
        '/SigninOrSignup': (context) => const SigninOrSignupScreen(),
        '/SignIn' : (context) => const SignInScreen(),
        '/SignUp' : (context) => SignUpScreen(),
        // '/ForgetPass' : (context) => ForgotPasswordScreen(),
        // '/Verify' : (context) => const VerificationScreen(),
        // '/ChangePass' : (context) => const ChangePasswordScreen(),
        // '/PassChanged' : (context) => PasswordChangedScreen(),
        // '/Home' : (context) => const Home(),
        // '/Calculations' : (context) => const Questionnaire()

      },
    );
  }
}
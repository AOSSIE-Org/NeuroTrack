import 'package:flutter/material.dart';
import 'package:patient/Features/auth/login.dart';
import 'package:patient/Features/auth/login_or_reg.dart';
import 'package:patient/Features/auth/register.dart';
import 'package:patient/Features/auth/splash_screen.dart';
import 'package:patient/Features/home/home.dart';
import 'package:patient/Features/home/presentation/views/daily_activities.dart';
import 'package:patient/Features/home/presentation/views/therapy_goal.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Set SplashScreen as the initial route
      routes: {
        '/': (context) => const SplashScreen(),
        '/SigninOrSignup':  (context) => const SigninOrSignupScreen(),
        '/SignIn': (context) => const SignInScreen(),
        '/SignUp': (context) => const SignUpScreen(),
        '/Home': (context) => const Home(),
        '/TherapyGoals': (context) => const TherapyGoalsScreen(),
        '/DailyActivities': (context) => const DailyActivities(),
      },
      onGenerateRoute: (settings) {
        // Handle undefined routes
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      },
    );
  }
}

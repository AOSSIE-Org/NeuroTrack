import 'package:flutter/material.dart';
import 'package:patient/Features/auth/presentation/views/login_view_body.dart';
class SignInScreen extends StatelessWidget {
  final String route = '/SignIn';

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: LoginBody(),
    );
  }
}

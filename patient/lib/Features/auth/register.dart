import 'package:flutter/material.dart';
import 'package:patient/Features/auth/presentation/views/register_view_body.dart';

class SignUpScreen extends StatelessWidget {
  final String route ='/SignUp';

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body:  RegisterBody(),
    );
  }
}

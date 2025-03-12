import 'package:flutter/material.dart';
import 'package:nurtotrack/Features/auth/presentation/views/login_view_body.dart';
class SignInScreen extends StatelessWidget {
  final String route = '/SignIn';

  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: LoginBody(),
    );
  }
}

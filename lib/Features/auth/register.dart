import 'package:flutter/material.dart';
import 'package:nurtotrack/Features/auth/presentation/views/register_view_body.dart';

class SignUpScreen extends StatelessWidget {
  final String route ='/SignUp';

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body:  RegisterBody(),
    );
  }
}

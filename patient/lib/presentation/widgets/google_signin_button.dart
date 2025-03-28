
import 'package:flutter/material.dart';



import 'package:patient/presentation/auth/personal_details_screen.dart';

import 'package:patient/presentation/auth/personal_details_screen.dart';
import 'package:patient/provider/auth_provider.dart';
import 'package:provider/provider.dart';


import '../auth/personal_details_screen.dart';




class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed
  });

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(

          onPressed: () => onPressed(),
      

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 2,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Image.asset(
                'assets/google_logo.png',
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 10),
              const Text(
                'Continue with Google',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapist/provider/auth_provider.dart';
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () =>  _handleGoogleSignIn(context),
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
  
Future<void> _handleGoogleSignIn(BuildContext context) async {
  final authProvider = context.read<AuthProvider>(); // Store provider reference

  try {
    await authProvider.signInWithGoogle(); // Perform sign-in
   // final fullName = authProvider.getFullName();
    // print(fullName);
     // Fetch full name after sign-in
  } catch (error) {
    // Handle error (you can log it or handle it elsewhere)
    print('Sign-in failed: $error');
    }
  }
}



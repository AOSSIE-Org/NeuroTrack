import 'package:flutter/material.dart';

class SocialSignInButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;
  // ignore: prefer_typing_uninitialized_variables
  final width;

   const SocialSignInButton({
    required this.iconPath,
    required this.onPressed,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Image.asset(
        iconPath,
        width: width*0.2,
        height: width*0.2,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nurtotrack/Features/auth/presentation/views/widgets/Social_Icon_button.dart';
import '../../../../../Core/utils/assets.dart';

class login_methods extends StatelessWidget {
  final double screenWidth,screenHeight;

 const login_methods({
    super.key,
  required this.screenHeight,required this.screenWidth
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SocialSignInButton(
            iconPath: AssetsData.facebook,
            width: screenWidth*.6,
            onPressed: () {
              // Facebook sign-in action
            },
          ),
        ),
        Expanded(
          child: SocialSignInButton(
            iconPath: AssetsData.google, // Google icon path
            width:screenWidth*.6,
            onPressed: () {
              // Google sign-in action
            },
          ),
        ),
        Expanded(
          child: SocialSignInButton(
            iconPath: AssetsData.apple, // Google icon path
            width: screenWidth*.6,
            onPressed: () {
              // Google sign-in action
            },
          ),
        ),
      ],
    );
  }
}

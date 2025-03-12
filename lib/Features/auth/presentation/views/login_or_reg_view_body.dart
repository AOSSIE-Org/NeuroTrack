import 'package:flutter/material.dart';
import 'package:nurtotrack/Core/utils/assets.dart';
import 'package:nurtotrack/constants.dart';


class LoginOrRegBody extends StatelessWidget {
  const LoginOrRegBody({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return  Stack(
        fit: StackFit.expand,
        children:[
          Image.asset(AssetsData.splashScreen,
          fit: BoxFit.fill,),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Spacer(flex:(screenHeight * .0039).toInt()),
                  Expanded(
                    flex: 10,
                    child: Center(
                      child: FractionallySizedBox(
                        widthFactor: screenWidth*.5,
                        alignment: Alignment.center,
                        child: Image.asset(
                          AssetsData.splashScreen,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: (screenHeight * .01).toInt()),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/SignIn');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 40,
                      backgroundColor: MyColors.kPrimaryColor,
                      foregroundColor: MyColors.white,
                      minimumSize: Size(screenWidth - 44, screenHeight * .086),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    child: const Text("Sign In"),
                  ),
                  SizedBox(height:screenHeight * .02),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/SignUp');
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 40,
                        foregroundColor: MyColors.black,
                        minimumSize: Size(screenWidth - 44, screenHeight * .086),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        backgroundColor: MyColors.white),
                    child: const Text("Sign Up"),
                  ),
                  Spacer(flex: (screenHeight * .0039).toInt()),

                ],
              ),
            ),
          ),
        ]
    );
  }
}

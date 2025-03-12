import 'package:flutter/material.dart';
import '../../../../constants.dart';
import 'widgets/login_methods.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  // Step 1: Declare the TextEditingController for the password field
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Step 2: Dispose the controller to prevent memory leaks
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    .01 * screenWidth, .1 * screenHeight, 0, 10),
                child: Text(
                  "Yippy! You’re Back!",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: screenWidth * .07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * .05),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: screenWidth - 60,
                      height: screenHeight * .07,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          filled: true,
                          fillColor: Color(0xffE8ECF4),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                                Radius.circular(9)),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: screenHeight * .02),
                    SizedBox(
                      width :screenWidth - 60,
                      height:  screenHeight * .07,
                      child: TextFormField(
                        controller: _passwordController,
                        // Step 3: Bind controller to the password field
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          filled: true,
                          fillColor: const Color(0xffE8ECF4),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/ForgetPass');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * .02),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          Navigator.pushReplacementNamed(context, '/Home');

                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: MyColors.kPrimaryColor,
                          foregroundColor: MyColors.white,
                          minimumSize: Size(
                              screenWidth - 60, screenHeight * .07),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))),
          
                      ),
                      child: const Text("Login"),
                    ),
                    SizedBox(height: screenHeight * .02),
                     const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Or Login with",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidth * .02),
                    login_methods(
                      screenWidth: screenWidth, screenHeight: screenHeight,),
                    SizedBox(height: screenHeight * .17),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/SignUp');
                      },
                      child: Text.rich(
                        const TextSpan(
                          text: "Don’t have an account? ",
                          children: [
                            TextSpan(
                              text: "Register Now",
                              style: TextStyle(color: MyColors.kPrimaryColor),
                            ),
                          ],
                        ),
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )

    );
  }
}

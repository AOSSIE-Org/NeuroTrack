import 'package:flutter/material.dart';
import 'package:nurtotrack/Features/auth/presentation/views/widgets/login_methods.dart';
import 'package:nurtotrack/constants.dart';


class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Dispose the controller to prevent memory leaks
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      .01 * screenWidth, .1 * screenHeight, 0, 10),
                  child: Text(
                    "Hello! Register to get started",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: screenWidth * .07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * .02),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: screenWidth - 44,
                        height: screenHeight * .086,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your name',
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
                        width: screenWidth - 44,
                        height: screenHeight * .086,
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
                        width: screenWidth - 44,
                        height: screenHeight * .086,
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
                      SizedBox(height: screenHeight * .02),
                      SizedBox(
                        width: screenWidth - 44,
                        height: screenHeight * .086,
                        child: TextFormField(
                          controller: _passwordController,
                          // Step 3: Bind controller to the password field
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: 'Confirm your password',
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
                      SizedBox(height: screenHeight * .02),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // Navigate to the main screen
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: MyColors.kPrimaryColor,
                          foregroundColor: MyColors.white,
                          minimumSize: Size(
                              screenWidth - 44, screenHeight * .086),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))),

                        ),
                        child: const Text("Register"),
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
                              "Or Register with",
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
                        screenHeight: screenHeight,screenWidth: screenWidth,
                      ),
                      SizedBox(height: screenHeight * .17),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/SignIn');
                        },
                        child: Text.rich(
                          const TextSpan(
                            text: "Already have an account? ",
                            children: [
                              TextSpan(
                                text: "Login Now",
                                style:
                                 TextStyle(color: MyColors.kPrimaryColor),
                              ),
                            ],
                          ),
                          style: Theme.of(context)
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

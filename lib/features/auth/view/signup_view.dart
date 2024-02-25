import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tweetify/common/common.dart';
import 'package:tweetify/constants/constants.dart';
import 'package:tweetify/features/auth/view/login_view.dart';
import 'package:tweetify/features/auth/widgets/auth_field.dart';
import 'package:tweetify/theme/theme.dart';

class SignUpView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpView());
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // by creating an instance of appbar here this will not be rebuilt when the widget is rebuilt
  final appbar = UIConstants.appBar();
  final emailConroller = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailConroller.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // textspan

                AuthField(
                  controller: emailConroller,
                  hintText: "Email",
                ),
                const SizedBox(height: 25),
                AuthField(
                  controller: passwordController,
                  hintText: "Password",
                ),
                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerRight,
                  child: RoundedSmallButton(
                    onTap: () {},
                    label: "Sign Up",
                  ),
                ),

                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: " Login ",
                        style: const TextStyle(
                          color: Pallete.blueColor,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // navigate to sign up page
                            Navigator.push(
                              context,
                              LoginView.route()
                            );
                          },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

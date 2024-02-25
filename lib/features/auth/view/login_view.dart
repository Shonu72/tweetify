import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tweetify/common/common.dart';
import 'package:tweetify/constants/constants.dart';
import 'package:tweetify/features/auth/controller/auth_controller.dart';
import 'package:tweetify/features/auth/view/signup_view.dart';
import 'package:tweetify/features/auth/widgets/auth_field.dart';
import 'package:tweetify/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginView());
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
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

    void onLogin() {
    ref.read(authControllerProvider.notifier).signUp(
          email: emailConroller.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appbar,
      body: isLoading ?const Loader() : Center(
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
                    onTap: onLogin,
                    label: "Login",
                  ),
                ),

                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: " Sign Up",
                        style: const TextStyle(
                          color: Pallete.blueColor,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // navigate to sign up page
                            Navigator.push(
                              context,
                              SignUpView.route(),
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

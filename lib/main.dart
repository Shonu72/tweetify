import 'package:flutter/material.dart';
import 'package:tweetify/features/auth/view/login_view.dart';
import 'package:tweetify/features/auth/view/signup_view.dart';
import 'package:tweetify/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tweetify',
      theme: AppTheme.theme,
      home: const SignUpView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

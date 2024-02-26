import 'package:flutter/material.dart';
class Errors extends StatelessWidget {
  final String error;
  const Errors({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),);
  }
}

class ErrorPage extends StatelessWidget {
  final String errorText;
  const ErrorPage({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Errors(
        error: errorText,
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const AuthField(
      {super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Pallete.blueColor, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Pallete.greyColor, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 18),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}

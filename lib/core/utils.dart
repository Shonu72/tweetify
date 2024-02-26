import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

String getNameFromEmail(String email) {
  // this will spilt the name from email and return as list 
  return email.split('@')[0];
}

import 'package:flutter/material.dart';

class CustomSnackbar {
  Color backgroundColor;
  int duration;

  CustomSnackbar(
      {this.backgroundColor = const Color(0xFF9F0000), this.duration = 4});

  void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(_snackbar(message));
  }

  SnackBar _snackbar(String message) {
    return SnackBar(
      content: Text(
        message,
        textScaleFactor: 1.0,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: duration),
    );
  }
}

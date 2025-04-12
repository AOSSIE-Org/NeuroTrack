import 'package:flutter/material.dart';

class SnackbarService {
  static final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _scaffoldMessengerKey;

  static void showSuccess(String message) {
    _showSnackbar(message, Colors.green);
  }

  static void showError(String message) {
    _showSnackbar(message, Colors.red);
  }

  static void showInfo(String message) {
    _showSnackbar(message, Colors.blue);
  }

  static void _showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    );

    _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}

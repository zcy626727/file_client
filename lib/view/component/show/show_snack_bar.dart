import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ShowSnackBar {
  static void exception({
    required BuildContext context,
    required Exception e,
    String defaultValue = "操作失败",
    double width = 200,
  }) {
    String msg = defaultValue;
    if (e is FormatException) {
      msg = e.message;
    } else if (e is DioError) {
      var err = e.error;
      if (err is FormatException) {
        msg = err.source.toString();
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        width: width,
        showCloseIcon: true,
        duration: const Duration(milliseconds: 1000),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void error({
    required BuildContext context,
    String message = "操作失败",
    double width = 200,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        width: width,
        showCloseIcon: true,
        duration: const Duration(milliseconds: 1000),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void info({
    required BuildContext context,
    required String message,
    double width = 200,
  }) {
    var colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:  TextStyle(color: colorScheme.onPrimaryContainer),
        ),
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        width: width,
        showCloseIcon: true,
        duration: const Duration(milliseconds: 1000),
        backgroundColor: colorScheme.primaryContainer,
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart'
    show
        BuildContext,
        Color,
        Colors,
        DismissDirection,
        ScaffoldMessenger,
        SnackBarAction,
        SnackBarBehavior;

extension SnackBarExtension on BuildContext {
  void showSnackBar(
    String text, {
    bool dismissible = true,
    Color color = Colors.white,
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior? behavior,
    SnackBarAction? snackBarAction,
    String? solution,
    DismissDirection dismissDirection = DismissDirection.down,
  }) =>
      ScaffoldMessenger.of(this)
        ..clearSnackBars()
        ..showSnackBar(
          customSnackBar(
            text,
            behavior: behavior,
            color: color,
            dismissDirection: dismissDirection,
            dismissible: dismissible,
            duration: duration,
            snackBarAction: snackBarAction,
            solution: solution,
          ),
        );

  void showUndismissableSnackBar(
    String text, {
    String? solution,
    Color color = Colors.white,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        customSnackBar(
          text,
          behavior: SnackBarBehavior.floating,
          color: color,
          duration: const Duration(days: 1),
          snackBarAction: action,
          dismissible: false,
          solution: solution,
        ),
      );
  }

  void closeSnackBars() {
    ScaffoldMessenger.of(this).clearSnackBars();
  }
}

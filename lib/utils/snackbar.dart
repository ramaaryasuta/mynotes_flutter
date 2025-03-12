import 'package:flutter/material.dart';

enum SnackbarStatus { success, error }

void showSnackBar(
  BuildContext context, {
  required String message,
  SnackbarStatus status = SnackbarStatus.success,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.white),
      ),
      backgroundColor:
          status == SnackbarStatus.success ? Colors.green : Colors.red,
    ),
  );
}

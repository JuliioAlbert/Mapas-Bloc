import 'package:flutter/material.dart';

class CustomSnakBar extends SnackBar {
  CustomSnakBar({
    Key? key,
    String btnLabel = "OK",
    required String texto,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onOk,
  }) : super(
            key: key,
            content: Text(texto),
            duration: duration,
            action: SnackBarAction(
                label: btnLabel,
                onPressed: () {
                  if (onOk != null) {
                    onOk();
                  }
                }));
}

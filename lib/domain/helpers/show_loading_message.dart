import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingMessage(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Espere..."),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Calculando..."),
            SizedBox(height: 10),
            CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
          ],
        ),
      ),
    );
    return;
  }

  showCupertinoDialog(
    context: context,
    builder: (context) => const CupertinoAlertDialog(
      title: Text("Espere..."),
      content: CupertinoActivityIndicator(),
    ),
  );

  return;
}

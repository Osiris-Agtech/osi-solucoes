// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';

void showCircularProgressIndicator(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return const Center(child: CircularProgressIndicator());
    },
  );
}

void showLoaderDialog(BuildContext context, String error) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: AlertDialog(
          content: Text(
            error,
            textAlign: TextAlign.center,
          ),
        ),
      );
    },
  );
}

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

forgotPassword() {
  return TextButton(
    child: Text(
      "textTextButton".i18n(),
      style: const TextStyle(
          color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
    ),
    onPressed: () {},
  );
}

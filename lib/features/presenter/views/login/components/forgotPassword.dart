// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';

forgotPassword() {
  return TextButton(
    child: Text(
      "textTextButton".i18n(),
      style: const TextStyle(
          color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
    ),
    onPressed: () {
      Get.toNamed(Routes.recuperarSenha);
    },
  );
}

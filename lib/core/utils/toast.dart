import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';

toastError({required String? message}) {
  Get.rawSnackbar(
    backgroundColor: Colors.red,
    message: message ?? 'Não foi possíovel realizar essa requisição',
    duration: const Duration(seconds: 3),
  );
}

toastSuccess({required String message}) {
  Get.rawSnackbar(
    backgroundColor: Constants.kPrimaryColor,
    message: message,
    duration: const Duration(seconds: 3),
  );
}

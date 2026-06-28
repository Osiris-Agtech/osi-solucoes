import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

void getBottomSheet(Widget child) {
  Get.bottomSheet(
    child,
    isScrollControlled: true,
    backgroundColor: Constants.kSecondBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    barrierColor: Colors.black.withValues(alpha: 0.3),
    settings: const RouteSettings(name: 'bottomSheet'),
  );
}

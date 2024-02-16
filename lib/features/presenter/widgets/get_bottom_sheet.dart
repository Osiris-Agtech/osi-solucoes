import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_hort_gestao_equipe/core/constants/constants.dart';

getBottomSheet(Widget child) {
  Get.bottomSheet(
    child,
    isScrollControlled: true,
    backgroundColor: Constants.kBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
    ),
  );
}

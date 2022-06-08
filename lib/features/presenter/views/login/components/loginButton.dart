// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/home/home_page.dart';
import 'package:osi_solucoes/features/presenter/views/login/components/loadingDialog.dart';

import '../../../viewmodels/login_store.dart';
import '../multi_account_page.dart';

loginButton(
  Size size,
  GlobalKey<FormState> formKey,
  LoginStore store,
  BuildContext context,
) {
  return Padding(
    padding: EdgeInsets.only(top: size.height * .041),
    child: SizedBox(
      width: size.width * .7,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Constants.kPrimaryColor),
        child: Text(
          "textButton".i18n(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            showCircularProgressIndicator(context);
            String response = await store.login();
            await Future.delayed(const Duration(seconds: 2));
            if (response == "sucesso") {
              Get.to(() => const HomePage());
              // Modular.to.pushReplacementNamed("/Home/");
            } else if (response == "multiple") {
              Get.to(
                () => MultiAccountsPage(
                  user: store.userList[0],
                  isLoggedIn: false,
                ),
              );
              // Modular.to.pushReplacementNamed(
              //   "/Login/MultiAccounts/",
              //   arguments: {
              //     "user": store.userList[0],
              //     "isLoggedIn": false,
              //   },
              // );
            } else {
              showLoaderDialog(context, response);
              await Future.delayed(const Duration(seconds: 3));
              Navigator.pop(context);
              Navigator.pop(context);
            }
          }
        },
      ),
    ),
  );
}

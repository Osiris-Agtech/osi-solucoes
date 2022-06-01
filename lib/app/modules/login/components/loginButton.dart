// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/app/constants.dart';
import 'package:osi_solucoes/app/modules/login/components/loadingDialog.dart';
import 'package:osi_solucoes/app/modules/login/login_store.dart';

loginButton(
  Size size,
  GlobalKey<FormState> formKey,
  LoginStore store,
  BuildContext context,
) async {
  return Padding(
    padding: EdgeInsets.only(top: size.height * .041),
    child: SizedBox(
      width: size.width * .7,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: kPrimaryColor),
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
              Modular.to.pushReplacementNamed("/Home/");
            } else if (response == "multiple") {
              Modular.to.pushReplacementNamed(
                "/Login/MultiAccounts/",
                arguments: {
                  "user": store.userList[0],
                  "isLoggedIn": false,
                },
              );
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

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/app/constants.dart';

registrarButton(Size size) {
  return Container(
    padding: EdgeInsets.only(
        // top: size.height * 0.06,
        // bottom: size.height * 0.06,
        right: size.width * 0.056),
    alignment: Alignment.bottomRight,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            Modular.to.pushNamed("/Cadastro/");
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "textTextButton2".i18n(),
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: kPrimaryColor,
                size: 32,
              )
            ],
          ),
        ),
      ],
    ),
  );
}

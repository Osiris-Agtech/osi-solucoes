// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';

Container lotePage(BuildContext context, CadernoCampoStore store) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: EdgeInsets.only(
      top: 0,
      left: MediaQuery.of(context).size.width * 0.08,
      right: MediaQuery.of(context).size.width * 0.08,
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              text: 'Quais',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: ' lotes ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Constants.kPrimaryColor),
                ),
                TextSpan(
                  text: 'deseja selecionar ?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Constants.kText2),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
      ],
    ),
  );
}

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sigma_hort_gestao_producao/core/constants/constants.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/caderno_campo_store.dart';

Container atividadePage(BuildContext context, CadernoCampoStore store) {
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
              text: 'Qual ',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: 'atividade',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Constants.kPrimaryColor),
                ),
                TextSpan(
                  text: ' deseja registrar ?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Constants.kText2),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Observer(builder: (_) {
            return TextFormField(
              initialValue: store.novoAtividadeName.text,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
              ),
              decoration: const InputDecoration(
                hintText: 'Título da Atividade',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onChanged: (String value) => store.alterarAtividadeNome(value),
            );
          }),
        ),
        const Spacer(),
      ],
    ),
  );
}

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';

Container lotePage(BuildContext context, SetorStore store) {
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
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Observer(builder: (_) {
            return TextFormField(
              initialValue: store.novoSetorName.text,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
              ),
              decoration: const InputDecoration(
                hintText: 'Pesquisar por',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onChanged: (String value) => store.alterarNome(value),
            );
          }),
        ),
        const Spacer(),
      ],
    ),
  );
}

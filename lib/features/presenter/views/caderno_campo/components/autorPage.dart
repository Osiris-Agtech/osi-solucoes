// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';

Container autorPage(BuildContext context, CadernoCampoStore store) {
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
              text: 'Qual',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: ' autor ',
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
        const SizedBox(
          height: 30,
        ),
        Expanded(
          //MOCK PARA DROPDOWN
          child: Observer(builder: (_) {
            return DropdownButtonFormField<Usuario>(
              value: store.selectedUsuario,
              hint: const Text(
                'Selecionar autor',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              isExpanded: true,
              iconEnabledColor: Constants.kPrimaryColor,
              items: store.usuariosConta.map((Usuario usuario) {
                return DropdownMenuItem<Usuario>(
                  value: usuario,
                  child: Text(usuario.nome ?? '-'),
                );
              }).toList(),
              onChanged: store.selectUser,
            );
          }),
        ),
        const Spacer(),
      ],
    ),
  );
}

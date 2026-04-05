// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/utils/enum/sistema_protocolo_enum.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';

Container editSistemaPage(BuildContext context, ProtocoloStore store) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: EdgeInsets.only(
      top: 0,
      left: MediaQuery.of(context).size.width * 0.08,
      right: MediaQuery.of(context).size.width * 0.08,
    ),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              textAlign: TextAlign.start,
              text: const TextSpan(
                text: 'Qual o',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: ' sistema ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.kPrimaryColor),
                  ),
                  TextSpan(
                    text: 'de cultivo ?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Constants.kText2),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 30),
            child: DropdownButton<String>(
              isExpanded: true,
              alignment: Alignment.center,
              hint: const Text("Selecione o Sistema de Cultivo..."),
              value: store.novoSistemaProtocoloDetalhes == null
                  ? store.protocoloSelecionado!.sistema_cultivo
                  : store.novoSistemaProtocoloDetalhes!,
              focusColor: Colors.transparent,
              iconEnabledColor: Constants.kPrimaryColor,
              elevation: 16,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              onChanged: (String? newValue) async {
                store.editarSistema(newValue!);
              },
              items: sistemaProtocoloList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}

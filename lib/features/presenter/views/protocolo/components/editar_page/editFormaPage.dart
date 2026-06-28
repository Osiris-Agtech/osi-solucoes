// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/utils/enum/forma_protocolo_enum.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';

Container editFormaPage(BuildContext context, ProtocoloStore store) {
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
                text: 'Qual a será a',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: ' forma de implantação ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.kPrimaryColor),
                  ),
                  TextSpan(
                    text: '?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Constants.kText2),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 30),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                alignment: Alignment.center,
                hint: const Text("Selecione a Forma de Implantação..."),
                value: store.novoFormaProtocoloDetalhes == null
                    ? store.protocoloSelecionado!.implantacao
                    : store.novoFormaProtocoloDetalhes!,
                icon: const Icon(Icons.expand_more, color: Constants.kPrimaryColor),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Constants.kText2,
                ),
                elevation: 16,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                onChanged: (String? newValue) async {
                  store.editarForma(newValue!);
                },
                items: formaProtocoloList
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
          ),
        ],
      ),
    ),
  );
}

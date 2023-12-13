// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';

Container nomePage(BuildContext context, ProtocoloStore store) {
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
                text: 'Qual será o',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: ' nome ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.kPrimaryColor),
                  ),
                  TextSpan(
                    text: 'do seu protocolo ?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Constants.kText2),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 30),
            child: TextFormField(
              initialValue: store.novoNomeProtocolo,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
              ),
              decoration: const InputDecoration(
                hintText: 'EX. Protocolo para Alface',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
              ),
              onChanged: store.alterarNome,
            ),
          ),
        ],
      ),
    ),
  );
}

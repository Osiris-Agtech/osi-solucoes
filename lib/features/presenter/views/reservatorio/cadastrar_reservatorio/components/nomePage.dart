// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sigma_hort_gestao_producao/core/constants/constants.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/reservatorios_store.dart';

Container nomePage(BuildContext context, ReservatoriosStore store) {
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
              text: 'Qual nome deseja para o ',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: 'reservatório?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.kPrimaryColor)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: TextFormField(
            controller: store.novoReservatorioName,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
            decoration: const InputDecoration(
              hintText: 'EX. Reservatório Central',
              hintStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    ),
  );
}

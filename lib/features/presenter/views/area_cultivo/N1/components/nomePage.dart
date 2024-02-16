// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sigma_hort_gestao_equipe/core/constants/constants.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/viewmodels/area_cultivo_store.dart';

Container nomePage(BuildContext context, AreaCultivoStore store) {
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
              text: 'Qual nome deseja para a ',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: 'área de cultivo?',
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
            // controller: store.novaAreaName,
            initialValue: store.novaAreaName.text,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
            decoration: const InputDecoration(
              hintText: 'EX. Estufa UFMT',
              hintStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
              ),
            ),
            onChanged: (String value) => store.alterarNome(value),
          ),
        ),
        const Spacer(),
      ],
    ),
  );
}

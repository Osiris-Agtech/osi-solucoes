// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/utils/enum/sistema_protocolo_enum.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

Container sistemaPage(BuildContext context, ProtocoloStore store) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: const EdgeInsets.symmetric(horizontal: 24),
    child: AppFormSection(
      title: 'Qual o sistema de cultivo?',
      description: 'Selecione o sistema de cultivo do protocolo.',
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            hint: const Text("Selecione o Sistema de Cultivo..."),
            value: store.novoSistemaProtocolo,
            icon: const Icon(Icons.expand_more, color: Constants.kPrimaryColor),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Constants.kText2,
            ),
            elevation: 16,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            onChanged: (String? newValue) async {
              store.alterarSistema(newValue!);
            },
            items: sistemaProtocoloList
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    ),
  );
}

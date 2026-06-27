// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/utils/enum/forma_protocolo_enum.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

Container formaPage(BuildContext context, ProtocoloStore store) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: const EdgeInsets.symmetric(horizontal: 24),
    child: AppFormSection(
      title: 'Qual a forma de implantação?',
      description: 'Selecione a forma de implantação do protocolo.',
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text("Selecione a Forma de Implantação..."),
          value: store.novoFormaProtocolo,
          focusColor: Colors.transparent,
          iconEnabledColor: Constants.kPrimaryColor,
          elevation: 16,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          onChanged: (String? newValue) async {
            store.alterarForma(newValue!);
          },
          items:
              formaProtocoloList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    ),
  );
}

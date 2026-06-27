// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

Container nomePage(BuildContext context, ProtocoloStore store) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: const EdgeInsets.symmetric(horizontal: 24),
    child: AppFormSection(
      title: 'Qual será o nome do seu protocolo?',
      description: 'Defina um nome claro para identificar o protocolo.',
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
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
    ),
  );
}

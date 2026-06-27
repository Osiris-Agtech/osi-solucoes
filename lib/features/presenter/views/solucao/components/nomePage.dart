// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

Container nomePage(BuildContext context, SolucaoStore store) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: const EdgeInsets.symmetric(horizontal: 24),
    child: AppFormSection(
      title: 'Qual nome deseja para a receita?',
      description: 'Defina um nome para identificar a solução nutritiva.',
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: TextFormField(
          controller: store.novaSolucaoName,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
          ),
          decoration: const InputDecoration(
            hintText: 'EX. Receita de alface',
            hintStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    ),
  );
}

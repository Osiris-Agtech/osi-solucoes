// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

Container nomePage(BuildContext context, AreaCultivoStore store) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: const EdgeInsets.symmetric(horizontal: 24),
    child: AppFormSection(
      title: 'Qual nome deseja para a área de cultivo?',
      description: 'Defina um nome para identificar a área.',
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: TextFormField(
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
    ),
  );
}

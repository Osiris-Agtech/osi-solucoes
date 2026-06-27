// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

Container nomePage(BuildContext context, ReservatoriosStore store) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: const EdgeInsets.symmetric(horizontal: 24),
    child: AppFormSection(
      title: 'Qual nome deseja para o reservatório?',
      description: 'Defina um nome para identificar o reservatório.',
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
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
    ),
  );
}

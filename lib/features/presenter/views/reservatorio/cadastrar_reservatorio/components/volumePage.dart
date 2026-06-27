// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_section.dart';

Container volumePage(BuildContext context, ReservatoriosStore store) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    margin: const EdgeInsets.symmetric(horizontal: 24),
    child: AppFormSection(
      title: 'Qual o volume do reservatório?',
      description: 'Informe a capacidade total em litros.',
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: store.novoReservatorioVolume,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
          ),
          decoration: const InputDecoration(
            suffixText: 'Litros',
            hintText: 'EX. 2500',
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

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N2/components/nomePage.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N2/components/reservatorioPage.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_step_wizard.dart';

Widget pagesNovoSetor(
    BuildContext context,
    SetorStore store) {
  return AppStepWizard(
    steps: [
      nomePage(context, store),
      reservatorioPage(context, store),
    ],
    onSubmit: () => Navigator.pop(context),
    stepLabels: const ['Nome', 'Reservatório'],
  );
}

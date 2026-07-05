// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';
import 'package:osi_solucoes/features/presenter/views/caderno_campo/components/atividadePage.dart';
import 'package:osi_solucoes/features/presenter/views/caderno_campo/components/autorPage.dart';
import 'package:osi_solucoes/features/presenter/views/caderno_campo/components/lotePage.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_step_wizard.dart';

Widget pagesNovoCadernoCampo(
    BuildContext context,
    CadernoCampoStore store) {
  return AppStepWizard(
    steps: [
      autorPage(context, store),
      lotePage(context, store),
      atividadePage(context, store),
    ],
    onSubmit: () => Navigator.pop(context),
    stepLabels: const ['Autor', 'Lote', 'Atividade'],
  );
}

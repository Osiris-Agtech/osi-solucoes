// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_modal_sheet.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/caderno_campo_store.dart';
import 'package:osi_solucoes/features/presenter/views/caderno_campo/components/pagesNovoCadernoCampo.dart';

Future<void> bottomSheet(
  BuildContext context,
  CadernoCampoStore store
) {
  return AppModalSheet.show<void>(
    title: 'Novo Caderno de Campo',
    body: pagesNovoCadernoCampo(context, store),
  );
}

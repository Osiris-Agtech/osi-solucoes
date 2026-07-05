// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_modal_sheet.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N2/components/pagesNovoSetor.dart';

Future<void> bottomSheet(
    BuildContext context,
    SetorStore store) {
  return AppModalSheet.show<void>(
    title: 'Novo Setor',
    body: pagesNovoSetor(context, store),
  );
}

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_modal_sheet.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/components/pagesNovaSolucao.dart';

Future<void> bottomSheet(
    BuildContext context,
    SolucaoStore store) {
  return AppModalSheet.show<void>(
    title: 'Nova Solução Nutritiva',
    body: pagesNovaSolucao(context, store),
  );
}

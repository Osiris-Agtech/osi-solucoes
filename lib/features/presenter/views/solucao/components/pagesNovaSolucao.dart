// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/components/fertilizantePage.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/components/nomePage.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_step_wizard.dart';

Widget pagesNovaSolucao(
  BuildContext context,
  SolucaoStore store,
) {
  return AppStepWizard(
    steps: [
      nomePage(context, store),
      fertilizantePage(context, CarouselSliderController()),
    ],
    onSubmit: () => Navigator.pop(context),
    stepLabels: const ['Nome', 'Fertilizantes'],
  );
}

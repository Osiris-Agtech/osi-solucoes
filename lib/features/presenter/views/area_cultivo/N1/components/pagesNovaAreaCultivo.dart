// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/components/nomePage.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/components/localizacaoPage.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_step_wizard.dart';

Widget pagesNovaAreaCultivo(
    BuildContext context,
    AreaCultivoStore store,
    CarouselSliderController controlerPages) {
  return AppStepWizard(
    steps: [
      nomePage(context, store),
      localizacaoPage(context, store),
    ],
    onSubmit: () => Navigator.pop(context),
    stepLabels: const ['Nome', 'Localização'],
  );
}

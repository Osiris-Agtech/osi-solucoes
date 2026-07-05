// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/components/nomePage.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/components/receitaPage.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/components/volumePage.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_step_wizard.dart';

Widget pagesNewReservatorio(
  BuildContext context,
  ReservatoriosStore store,
  CarouselSliderController controlerPages,
) {
  return AppStepWizard(
    steps: [
      nomePage(context, store),
      volumePage(context, store),
      receitaPage(context, CarouselSliderController()),
    ],
    onSubmit: () => Navigator.pop(context),
    stepLabels: const ['Nome', 'Volume', 'Receita'],
  );
}

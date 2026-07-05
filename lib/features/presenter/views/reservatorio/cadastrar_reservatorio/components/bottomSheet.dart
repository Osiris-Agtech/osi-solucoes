// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_modal_sheet.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/components/pagesNovoReservatorio.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/components/receitaDetalhes.dart';

Future<void> bottomSheet(
    BuildContext context,
    CarouselSliderController controlerPages,
    ReservatoriosStore store) {
  return AppModalSheet.show<void>(
    title: 'Novo Reservatório',
    body: CarouselSlider(
      carouselController: controlerPages,
      options: CarouselOptions(
        initialPage: 0,
        enableInfiniteScroll: false,
        height: MediaQuery.of(context).size.height * 0.9,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        scrollPhysics: const NeverScrollableScrollPhysics(),
      ),
      items: [
        pagesNewReservatorio(context, store, controlerPages),
        receitaDetalhe(context, controlerPages, store),
      ],
    ),
  );
}

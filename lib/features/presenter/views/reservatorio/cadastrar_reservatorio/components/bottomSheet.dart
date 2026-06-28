// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/components/pagesNovoReservatorio.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/components/receitaDetalhes.dart';

Future<void> bottomSheet(
    BuildContext context,
    CarouselSliderController controlerPages,
    CarouselSliderController carouselController,
    ReservatoriosStore store) {
  return showModalBottomSheet<void>(
    backgroundColor: Constants.kSecondBackgroundColor,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    isScrollControlled: true,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    builder: (BuildContext context) {
      return CarouselSlider(
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
          pagesNewReservatorio(
              context, store, carouselController, controlerPages),
          receitaDetalhe(context, controlerPages, store),
        ],
      );
    },
  );
}

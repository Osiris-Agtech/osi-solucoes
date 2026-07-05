// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_modal_sheet.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/components/finalizar_page/finalizacao_lote_page.dart';

Future<void> bottomSheet(
  BuildContext context,
  CarouselSliderController carouselController,
  CarouselSliderController controlerPages,
) {
  return AppModalSheet.show<void>(
    title: 'Finalizar Lote',
    body: CarouselSlider(
      carouselController: carouselController,
      options: CarouselOptions(
        initialPage: 0,
        enableInfiniteScroll: false,
        height: MediaQuery.of(context).size.height * 0.9,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        scrollPhysics: const NeverScrollableScrollPhysics(),
      ),
      items: [
        pagesFinalizacaoLote(context, carouselController, controlerPages)
      ],
    ),
  );
}

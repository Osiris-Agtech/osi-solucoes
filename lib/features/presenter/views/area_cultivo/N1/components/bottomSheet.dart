// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_modal_sheet.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/components/novaLocalizacaoPage.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/components/pagesNovaAreaCultivo.dart';

Future<void> bottomSheet(
    BuildContext context,
    CarouselSliderController controlerPages,
    AreaCultivoStore store) {
  return AppModalSheet.show<void>(
    title: 'Nova Área de Cultivo',
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
        pagesNovaAreaCultivo(context, store, controlerPages),
        novaLocalizacaoPage(context, controlerPages, store),
      ],
    ),
  );
}

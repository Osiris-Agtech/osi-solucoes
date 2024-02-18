// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sigma_hort_gestao_producao/core/constants/constants.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/views/area_cultivo/N1/components/novaLocalizacaoPage.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/views/area_cultivo/N1/components/pagesNovaAreaCultivo.dart';

Future<void> bottomSheet(
    BuildContext context,
    CarouselController controlerPages,
    CarouselController carouselController,
    AreaCultivoStore store) {
  return showModalBottomSheet<void>(
    backgroundColor: Constants.kBackgroundColor,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    isScrollControlled: true,
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
          pagesNovaAreaCultivo(
              context, store, carouselController, controlerPages),
          novaLocalizacaoPage(context, controlerPages, store),
        ],
      );
    },
  );
}

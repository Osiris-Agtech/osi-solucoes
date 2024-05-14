// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/editar_page/carouselEditarProtocolo.dart';

Future<void> editarBottomSheet(
    BuildContext context,
    CarouselController carouselController,
    CarouselController controlerPages,
    ProtocoloStore store) {
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
          carouselEditarProtocolo(
              context, carouselController, controlerPages, store)
        ],
      );
    },
  );
}

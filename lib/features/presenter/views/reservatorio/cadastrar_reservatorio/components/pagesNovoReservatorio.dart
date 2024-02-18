// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sigma_hort_gestao_producao/core/constants/constants.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/views/reservatorio/cadastrar_reservatorio/components/nomePage.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/views/reservatorio/cadastrar_reservatorio/components/receitaPage.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/views/reservatorio/cadastrar_reservatorio/components/volumePage.dart';

SizedBox pagesNewReservatorio(BuildContext context, ReservatoriosStore store,
    CarouselController carouselController, CarouselController controlerPages) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.9,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  size: 32,
                ),
                color: Constants.kPrimaryColor,
              ),
              Observer(builder: (_) {
                return DotsIndicator(
                  dotsCount: 3,
                  position: store.dotIndicator * 1.0,
                  decorator: DotsDecorator(
                    size: const Size.square(9.0),
                    activeSize: const Size(18.0, 9.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                );
              }),
              const SizedBox(
                width: 70,
              ),
            ],
          ),
        ),
        Observer(builder: (_) {
          return CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              initialPage: store.dotIndicator,
              enableInfiniteScroll: false,
              height: MediaQuery.of(context).size.height * 0.9 - 140,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              scrollPhysics: const NeverScrollableScrollPhysics(),
            ),
            items: [
              nomePage(context, store),
              volumePage(context, store),
              receitaPage(context, controlerPages),
            ],
          );
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  store.setDotIndicator(store.dotIndicator - 1);
                  carouselController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn,
                  );
                },
                child: Observer(builder: (_) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        color: store.dotIndicator == 0
                            ? Colors.grey
                            : Constants.kPrimaryColor,
                      ),
                      Text(
                        'Voltar',
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: store.dotIndicator == 0
                              ? Colors.grey
                              : Constants.kPrimaryColor,
                        ),
                      ),
                    ],
                  );
                }),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  primary: Constants.kPrimaryColor,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Avançar',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
                onPressed: () {
                  if (store.dotIndicator == 2) {
                    Navigator.pop(context);
                  } else {
                    if (store.dotIndicator == 1) store.buscarSolucoes();
                    store.setDotIndicator(store.dotIndicator + 1);
                    carouselController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn,
                    );
                  }
                },
              ),
            ],
          ),
        )
      ],
    ),
  );
}

// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/components/nomePage.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/components/localizacaoPage.dart';

SizedBox pagesNovaAreaCultivo(
    BuildContext context,
    AreaCultivoStore store,
    CarouselSliderController carouselController,
    CarouselSliderController controlerPages) {
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
                  dotsCount: 2,
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
              localizacaoPage(context, store),
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
              NextStepButton(
                carouselController: carouselController,
                controlerPages: controlerPages,
              ),
            ],
          ),
        )
      ],
    ),
  );
}

class NextStepButton extends StatefulWidget {
  final CarouselSliderController carouselController;
  final CarouselSliderController controlerPages;
  const NextStepButton(
      {super.key,
      required this.carouselController,
      required this.controlerPages});

  @override
  State<NextStepButton> createState() => _NextStepButtonState();
}

class _NextStepButtonState extends State<NextStepButton> {
  AreaCultivoStore store = GetIt.I<AreaCultivoStore>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Constants.kPrimaryColor,
      ),
      child: Center(
        child: Observer(builder: (_) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              store.dotIndicator == 1 ? const Icon(Icons.add) : Container(),
              Text(
                store.dotIndicator == 0 ? 'Avançar' : "Novo",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              store.dotIndicator == 0
                  ? const Icon(Icons.chevron_right)
                  : Container(),
            ],
          );
        }),
      ),
      onPressed: () {
        if (store.dotIndicator == 1) {
          widget.controlerPages.nextPage();
        } else {
          store.setDotIndicator(store.dotIndicator + 1);
          widget.carouselController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeIn,
          );
        }
      },
    );
  }
}

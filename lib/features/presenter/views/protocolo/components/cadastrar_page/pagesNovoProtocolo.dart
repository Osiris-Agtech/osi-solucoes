// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/cadastrar_page/cultura_item.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/cadastrar_page/formaPage.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/cadastrar_page/nomePage.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/cadastrar_page/sistemaPage.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/cadastrar_page/tipoPage.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/cadastrar_page/registrar_ativ.dart';

SizedBox pagesNovoProtocolo(
    BuildContext context,
    CarouselSliderController carouselController,
    CarouselSliderController controlerPages,
    ProtocoloStore store) {
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
                  dotsCount: 6,
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
              culturaPage(context, store),
              tipoPage(context, store),
              sistemaPage(context, store),
              formaPage(context, store),
              registrarAtivPage(context, store)
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
                            : Constants.kButtonGrey,
                      ),
                      const Text(
                        'Voltar',
                        style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Constants.kButtonGrey),
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
  ProtocoloStore store = GetIt.I<ProtocoloStore>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Constants.kPrimaryColor,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Avançar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
      onPressed: () {
        if (store.dotIndicator == 5) {
          Navigator.pop(context);
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

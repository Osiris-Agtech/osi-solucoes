// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/components/finalizar_page/atividades_abertas.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/components/finalizar_page/detalhes_producao.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/components/finalizar_page/selecionar_lote.dart';

SizedBox pagesFinalizacaoLote(
  BuildContext context,
  CarouselController carouselController,
  CarouselController controlerPages,
) {
  LoteStore store = GetIt.I<LoteStore>();

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
              selecionarLote(context),
              atividadesAbertas(context),
              detalhesProducao(context),
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
                  if (store.dotIndicator == 0) {
                    Navigator.pop(context);
                  }
                  if (store.atividadesPendentes.isEmpty) {
                    store.setDotIndicator(store.dotIndicator - 2);
                    carouselController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn,
                    );
                    return;
                  }
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
  final CarouselController carouselController;
  final CarouselController controlerPages;
  const NextStepButton(
      {Key? key,
      required this.carouselController,
      required this.controlerPages})
      : super(key: key);

  @override
  State<NextStepButton> createState() => _NextStepButtonState();
}

class _NextStepButtonState extends State<NextStepButton> {
  LoteStore store = GetIt.I<LoteStore>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        primary: Constants.kPrimaryColor,
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
      onPressed: () async {
        if (store.dotIndicator == 2) {
          if (!store.podemosFinalizarLotes()) {
            toastError(
                message: "Complete as informações dos lotes para finalizar");
            return;
          }
          await store.finalizarTodosLotes();
          Navigator.pop(context);
          return;
        }
        if (store.dotIndicator == 0) {
          if (store.lotesSelecionadosEstaVazio()) {
            toastError(message: "Selecione ao menos um lote para finalizar");
            return;
          }
          await store.verificarAtividades();
          //store.atividadesPendentes.clear();
          if (store.atividadesPendentes.isEmpty) {
            store.setDotIndicator(store.dotIndicator + 2);
            widget.carouselController.animateToPage(
              2,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
            );
            return;
          }
        }
        if (store.dotIndicator == 1 &&
            store.atividadesPendentes.map((e) => e.selected).contains(false)) {
          toastError(message: "Finalize as atividades pendentes para avançar");
          return;
        }
        store.setDotIndicator(store.dotIndicator + 1);
        widget.carouselController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      },
    );
  }
}

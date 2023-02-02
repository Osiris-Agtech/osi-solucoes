import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';

import 'components/cadastrar_page/cultura_item.dart';
import 'components/cadastrar_page/data_item.dart';
import 'components/cadastrar_page/lote_item.dart';
import 'components/cadastrar_page/reservatorio_detalhes_page.dart';
import 'components/cadastrar_page/reservatorio_item.dart';
import 'components/cadastrar_page/setor_item.dart';

class CadastrarLotePage extends StatefulWidget {
  const CadastrarLotePage({Key? key}) : super(key: key);

  @override
  State<CadastrarLotePage> createState() => _CadastrarLotePageState();
}

class _CadastrarLotePageState extends State<CadastrarLotePage> {
  LoteStore store = GetIt.I<LoteStore>();
  CarouselController carouselController = CarouselController();
  final GlobalKey<FormFieldState> key = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    store.buscarAreasList().then(
          (value) => store.carregarAreaSetor(),
        );
    store.buscarCulturas();
    store.buscarReservatorios();
    store.setIsNovaCultura(false);
    store.setMostrarErroFormulario(false);
  }

  @override
  void dispose() {
    key.currentState?.reset();
    store.limparTudo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: appBar(),
        backgroundColor: Constants.kBackgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titulo(),
                subtitulo(),
                const SizedBox(height: 20),
                setor(context, carouselController, store, key),
                Observer(builder: (_) {
                  return Visibility(
                    visible: store.mostrarErroFormulario &&
                        store.novoLoteSetor.id == null,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: 16.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        'Setor obrigatório',
                        style: TextStyle(
                          fontSize: 12,
                          color: Constants.kErrorColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
                const Divider(
                  thickness: 0.5,
                  color: Color(0xFFC4C4C4),
                ),
                lote(context, carouselController, store, key),
                Observer(builder: (_) {
                  return Visibility(
                    visible: store.mostrarErroFormulario &&
                        store.novoLoteName.text.isEmpty,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: 16.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        'Nome obrigatório',
                        style: TextStyle(
                          fontSize: 12,
                          color: Constants.kErrorColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
                const Divider(
                  thickness: 0.5,
                  color: Color(0xFFC4C4C4),
                ),
                cultura(context, carouselController, store, key),
                Observer(builder: (_) {
                  return Visibility(
                    visible: store.mostrarErroFormulario &&
                        store.novoLoteCultura.id == null,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: 16.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        'Cultura obrigatória',
                        style: TextStyle(
                          fontSize: 12,
                          color: Constants.kErrorColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
                const Divider(
                  thickness: 0.5,
                  color: Color(0xFFC4C4C4),
                ),
                reservatorio(context, carouselController, store, key),
                // fase(context),
                const Divider(),
                datas(context, store),
                const SizedBox(height: 20),
                saveButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget subtitulo() {
    return const Padding(
      padding: EdgeInsets.only(top: 10, left: 20),
      child: Text(
        'Cadastrar Informações',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xff6F6464),
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget titulo() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      child: Text(
        'Criando Novo Lote',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Constants.kBackgroundColor,
      elevation: 0,
      leading: BackButton(
        color: Constants.kPrimaryColor,
        onPressed: () {
          Get.close(1);
          store.limparTudo();
        },
      ),
    );
  }

  Padding saveButton(Size size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Center(
        child: SizedBox(
          width: size.width * .8,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Constants.kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Observer(
              builder: (_) {
                return store.isNovoLoteLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : store.isEditing
                        ? const Text(
                            "Alterar",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : const Text(
                            "Salvar",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          );
              },
            ),
            onPressed: () {
              if (store.validarRegistro()) {
                // if (store.isEditing) {
                //   store.alterarLote();
                // } else {
                //   store.registrarLote();
                // }
              }
            },
          ),
        ),
      ),
    );
  }
}

bottomSheetN3(
  BuildContext context,
  CarouselController carouselController,
  LoteStore store,
  GlobalKey<FormFieldState> key,
) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Constants.kBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: SizedBox(
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
                      Observer(
                        builder: (_) {
                          return store.dotIndicator == 3 &&
                                  store.showReservatorioDetalhes
                              ? IconButton(
                                  onPressed: () =>
                                      store.setShowReservatorioDetalhes(false),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 26,
                                  ),
                                  color: Constants.kPrimaryColor,
                                )
                              : IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(
                                    Icons.close,
                                    size: 32,
                                  ),
                                  color: Constants.kPrimaryColor,
                                );
                        },
                      ),
                      Observer(builder: (_) {
                        return DotsIndicator(
                          dotsCount: 4,
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
                      onPageChanged: (page, reason) {
                        store.setIsNovaCultura(false);
                      },
                    ),
                    items: [
                      setorPage(context, store, key),
                      lotePage(context, store),
                      culturaPage(context, store),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        firstChild: reservatorioPage(context, store),
                        secondChild: reservatorioDetalhesPage(store),
                        crossFadeState: !store.showReservatorioDetalhes
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ],
                  );
                }),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BackStepButton(
                        carouselController: carouselController,
                      ),
                      NextStepButton(
                        carouselController: carouselController,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

class BackStepButton extends StatefulWidget {
  final CarouselController carouselController;
  const BackStepButton({
    Key? key,
    required this.carouselController,
  }) : super(key: key);

  @override
  State<BackStepButton> createState() => _BackStepButtonState();
}

class _BackStepButtonState extends State<BackStepButton> {
  LoteStore store = GetIt.I<LoteStore>();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return store.dotIndicator == 3 && store.showReservatorioDetalhes
            ? Container()
            : TextButton(
                onPressed: () {
                  store.setDotIndicator(store.dotIndicator - 1);
                  widget.carouselController.previousPage(
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
              );
      },
    );
  }
}

class NextStepButton extends StatefulWidget {
  final CarouselController carouselController;
  const NextStepButton({
    Key? key,
    required this.carouselController,
  }) : super(key: key);

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
        child: Observer(builder: (_) {
          return store.dotIndicator == 3 && store.showReservatorioDetalhes
              ? const Text(
                  'Vincular',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Avançar',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                );
        }),
      ),
      onPressed: () {
        if (store.dotIndicator == 3) {
          if (store.showReservatorioDetalhes) {
            store.selecionarNovoLoteReservatorio();
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        }
        if (store.dotIndicator < 3) {
          store.setDotIndicator(store.dotIndicator + 1);
          widget.carouselController.nextPage();
        }
      },
    );
  }
}

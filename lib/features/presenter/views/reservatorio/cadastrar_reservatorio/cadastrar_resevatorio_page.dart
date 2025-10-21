import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/components/bottomSheet.dart';

import '../../../../../core/constants/constants.dart';

class CadastrarReservatorioPage extends StatefulWidget {
  final String title;
  final bool isShortcut;
  const CadastrarReservatorioPage({
    super.key,
    this.title = 'CadastrarReservatorioPage',
    this.isShortcut = false,
  });
  @override
  CadastrarReservatorioPageState createState() =>
      CadastrarReservatorioPageState();
}

class CadastrarReservatorioPageState extends State<CadastrarReservatorioPage> {
  ReservatoriosStore store = GetIt.I<ReservatoriosStore>();
  CarouselSliderController carouselController = CarouselSliderController();
  CarouselSliderController controlerPages = CarouselSliderController();

  @override
  void dispose() {
    store.limparNovoReservatorio();
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
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appBar(),
          backgroundColor: Constants.kBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                titulo(),
                subtitulo(),
                const SizedBox(height: 20),
                nome(context),
                Observer(builder: (_) {
                  return Visibility(
                    visible: store.mostrarErroFormulario &&
                        store.novoReservatorioName.text.isEmpty,
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
                const Divider(),
                volume(context),
                Observer(builder: (_) {
                  return Visibility(
                    visible: store.mostrarErroFormulario &&
                        store.novoReservatorioVolume.text.isEmpty,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: 16.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        'Volume obrigatório',
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
                const Divider(),
                solucaoNutritiva(context),
                const Divider(),
                Expanded(child: Container()),
                saveButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding subtitulo() {
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

  Padding titulo() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      child: Text(
        'Novo Reservatório',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Constants.kBackgroundColor,
      elevation: 0,
      leading: const BackButton(
        color: Constants.kPrimaryColor,
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
          child: Observer(builder: (_) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: store.isNovoReservatorioLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      store.isEditing ? "Alterar" : "Salvar",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              onPressed: () {
                if (store.validarReservatorio()) {
                  if (!store.isEditing || widget.isShortcut) {
                    store.registrarReservatorio(isShortcut: widget.isShortcut);
                  } else {
                    store.updateReservatorio();
                  }
                }
              },
            );
          }),
        ),
      ),
    );
  }

  InkWell nome(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
          leading: const Icon(Icons.label),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Text(
                  'Nome',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ),
              store.novoReservatorioName.text.isNotEmpty
                  ? Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              store.novoReservatorioName.text,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Constants.kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Constants.kPrimaryColor,
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          "Preencher",
                          style: TextStyle(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Constants.kPrimaryColor,
                        ),
                      ],
                    ),
            ],
          ),
          onTap: () {
            store.setDotIndicator(0);
            bottomSheet(context, controlerPages, carouselController, store);
            // showConfirmDialog(context);
          },
        );
      }),
    );
  }

  InkWell volume(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
          leading: const Icon(Icons.waves),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Text(
                  'Volume',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ),
              store.novoReservatorioVolume.text.isNotEmpty
                  ? Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              "${store.novoReservatorioVolume.text} Litros",
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  color: Constants.kPrimaryColor,
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Constants.kPrimaryColor,
                          )
                        ],
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          "Preencher",
                          style: TextStyle(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Constants.kPrimaryColor,
                        ),
                      ],
                    ),
            ],
          ),
          onTap: () {
            store.setDotIndicator(1);
            bottomSheet(context, controlerPages, carouselController, store);
          },
        );
      }),
    );
  }

  InkWell solucaoNutritiva(BuildContext context) {
    return InkWell(
      child: Observer(builder: (_) {
        return ListTile(
          leading: const Icon(Icons.invert_colors),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Text(
                  'Solução\nNutritiva',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ),
              store.isSolucaoNutritivaValid
                  ? Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              store.solucaoNutritiva.nome ?? "",
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Constants.kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Constants.kPrimaryColor,
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          "Selecionar",
                          style: TextStyle(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Constants.kPrimaryColor,
                        ),
                      ],
                    ),
            ],
          ),
          onTap: () {
            store.buscarSolucoes();
            store.setDotIndicator(2);
            bottomSheet(context, controlerPages, carouselController, store);
          },
        );
      }),
    );
  }
}

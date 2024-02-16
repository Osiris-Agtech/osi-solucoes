import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/views/reservatorio/cadastrar_reservatorio/components/bottomSheet.dart';

import '../../../../../core/constants/constants.dart';

class CadastrarReservatorioPage extends StatefulWidget {
  final String title;
  const CadastrarReservatorioPage(
      {Key? key, this.title = 'CadastrarReservatorioPage'})
      : super(key: key);
  @override
  CadastrarReservatorioPageState createState() =>
      CadastrarReservatorioPageState();
}

class CadastrarReservatorioPageState extends State<CadastrarReservatorioPage> {
  ReservatoriosStore store = GetIt.I<ReservatoriosStore>();
  CarouselController carouselController = CarouselController();
  CarouselController controlerPages = CarouselController();

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
                primary: Constants.kPrimaryColor,
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
                  if (store.isEditing) {
                    store.updateReservatorio();
                  } else {
                    store.registrarReservatorio();
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
          title: const Text(
            'Nome',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          trailing: store.novoReservatorioName.text.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 126,
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
                )
              : const Text(
                  "Preencher",
                  style: TextStyle(
                    color: Constants.kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
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
          title: const Text(
            'Volume',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          trailing: store.novoReservatorioVolume.text.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      store.novoReservatorioVolume.text + " Litros",
                      style: const TextStyle(
                          color: Constants.kPrimaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Constants.kPrimaryColor,
                    )
                  ],
                )
              : const Text(
                  "Preencher",
                  style: TextStyle(
                    color: Constants.kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
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
          title: const Text(
            'Solução Nutritiva',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          trailing: store.isSolucaoNutritivaValid
              ? Text(
                  store.solucaoNutritiva.nome ?? "",
                  style: const TextStyle(
                    color: Constants.kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
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

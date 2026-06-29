import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_header.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_selection_tile.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_primary_button.dart';
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

  AppFormHeader appBar() {
    return AppFormHeader(
      onBack: () => Get.back(),
    );
  }

  Widget saveButton(Size size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: SizedBox(
        width: size.width * .8,
        child: Observer(builder: (_) {
          return AppPrimaryButton(
            label: store.isEditing ? 'Alterar' : 'Salvar',
            isLoading: store.isNovoReservatorioLoading,
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
    );
  }

  Widget nome(BuildContext context) {
    return Observer(builder: (_) {
      return AppFormSelectionTile(
        leading: const Icon(Icons.label),
        title: 'Nome',
        subtitle: store.novoReservatorioName.text.isNotEmpty
            ? store.novoReservatorioName.text
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              store.novoReservatorioName.text.isNotEmpty
                  ? store.novoReservatorioName.text
                  : 'Preencher',
              style: TextStyle(
                color: Constants.kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Icon(Icons.chevron_right, color: Constants.kPrimaryColor),
          ],
        ),
        onTap: () {
          store.setDotIndicator(0);
          bottomSheet(context, controlerPages, carouselController, store);
        },
      );
    });
  }

  Widget volume(BuildContext context) {
    return Observer(builder: (_) {
      final volText = store.novoReservatorioVolume.text;
      return AppFormSelectionTile(
        leading: const Icon(Icons.waves),
        title: 'Volume',
        subtitle: volText.isNotEmpty ? '$volText Litros' : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              volText.isNotEmpty ? '$volText Litros' : 'Preencher',
              style: const TextStyle(
                color: Constants.kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Icon(Icons.chevron_right, color: Constants.kPrimaryColor),
          ],
        ),
        onTap: () {
          store.setDotIndicator(1);
          bottomSheet(context, controlerPages, carouselController, store);
        },
      );
    });
  }

  Widget solucaoNutritiva(BuildContext context) {
    return Observer(builder: (_) {
      return AppFormSelectionTile(
        leading: const Icon(Icons.invert_colors),
        title: 'Solução Nutritiva',
        subtitle: store.isSolucaoNutritivaValid
            ? store.solucaoNutritiva.nome ?? ''
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              store.isSolucaoNutritivaValid
                  ? store.solucaoNutritiva.nome ?? ''
                  : 'Selecionar',
              style: const TextStyle(
                color: Constants.kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Icon(Icons.chevron_right, color: Constants.kPrimaryColor),
          ],
        ),
        onTap: () {
          store.buscarSolucoes();
          store.setDotIndicator(2);
          bottomSheet(context, controlerPages, carouselController, store);
        },
      );
    });
  }
}

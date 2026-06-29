import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_header.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_selection_tile.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_primary_button.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/cadastrar_page/bottomSheet.dart';

import '../../../../core/utils/toast.dart';

class CadastrarProtocoloPage extends StatefulWidget {
  final bool isShortcut;
  const CadastrarProtocoloPage({
    super.key,
    this.isShortcut = false,
  });

  @override
  State<CadastrarProtocoloPage> createState() => _CadastrarProtocoloPageState();
}

class _CadastrarProtocoloPageState extends State<CadastrarProtocoloPage> {
  CarouselSliderController carouselController = CarouselSliderController();
  CarouselSliderController controlerPages = CarouselSliderController();
  ProtocoloStore store = GetIt.I<ProtocoloStore>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.buscarCulturas();
      store.buscarFases();
      store.setMostrarErroFormulario(false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    store.limparTudo();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: appBar(),
            backgroundColor: Constants.kBackgroundColor,
            body: Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    titulo(),
                    subtitulo(),
                    const SizedBox(height: 10),
                    nome(context),
                    Observer(builder: (_) {
                      return Visibility(
                        visible: store.mostrarErroFormulario &&
                            store.novaCulturaProtocolo?.nome == null,
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
                    cultura(context),
                    Observer(builder: (_) {
                      return Visibility(
                        visible: store.mostrarErroFormulario &&
                            store.novaCulturaProtocolo?.nome == null,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                            'Cultura obrigatório',
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
                    sistema(context),
                    Observer(builder: (_) {
                      return Visibility(
                        visible: store.mostrarErroFormulario &&
                            (store.novoSistemaProtocolo ?? "").isEmpty,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                            'Sistema de Cultivo obrigatório',
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
                    forma(context),
                    Observer(builder: (_) {
                      return Visibility(
                        visible: store.mostrarErroFormulario &&
                            (store.novoFormaProtocolo ?? "").isEmpty,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                            'Forma de implantação obrigatório',
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
                    atividades(context),
                    Observer(builder: (_) {
                      return Visibility(
                        visible: store.mostrarErroFormulario &&
                            store.novasAtividadesProtocolo.isEmpty,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                            'Atividades são obrigatórias',
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
                    const SizedBox(height: 30),
                    saveButton(size),
                  ],
                ),
              ),
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
        'Criando novo \nProtocolo',
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
            onPressed: () {
              store.validarNovoProtocolo();
              if (!store.isValid) {
                toastError(
                    message:
                        "Preencha todos campos do formulario corretamente!");
                return;
              }
              store.registrarProtocolo();
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
        subtitle: store.novoNomeProtocolo?.isNotEmpty == true
            ? store.novoNomeProtocolo
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              store.novoNomeProtocolo?.isNotEmpty == true
                  ? store.novoNomeProtocolo!
                  : 'Preencher',
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
          store.setDotIndicator(0);
          bottomSheet(context, carouselController, controlerPages, store);
        },
      );
    });
  }

  Widget cultura(BuildContext context) {
    return Observer(builder: (_) {
      return AppFormSelectionTile(
        leading: const Icon(Icons.park),
        title: 'Cultura',
        subtitle: store.novaCulturaProtocolo?.nome,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              store.novaCulturaProtocolo?.nome ?? 'Preencher',
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
          bottomSheet(context, carouselController, controlerPages, store);
        },
      );
    });
  }

  Widget sistema(BuildContext context) {
    return Observer(builder: (_) {
      return AppFormSelectionTile(
        leading: const Icon(Icons.grid_view),
        title: 'Sistema de cultivo',
        subtitle: store.novoSistemaProtocolo?.isNotEmpty == true
            ? store.novoSistemaProtocolo
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              store.novoSistemaProtocolo?.isNotEmpty == true
                  ? store.novoSistemaProtocolo!
                  : 'Preencher',
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
          store.setDotIndicator(2);
          bottomSheet(context, carouselController, controlerPages, store);
        },
      );
    });
  }

  Widget forma(BuildContext context) {
    return Observer(builder: (_) {
      return AppFormSelectionTile(
        leading: const Icon(Icons.build_outlined),
        title: 'Forma de implantação',
        subtitle: store.novoFormaProtocolo?.isNotEmpty == true
            ? store.novoFormaProtocolo
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              store.novoFormaProtocolo?.isNotEmpty == true
                  ? store.novoFormaProtocolo!
                  : 'Preencher',
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
          store.setDotIndicator(3);
          bottomSheet(context, carouselController, controlerPages, store);
        },
      );
    });
  }

  Widget atividades(BuildContext context) {
    return Observer(builder: (_) {
      final count = store.novasAtividadesProtocolo.length;
      return AppFormSelectionTile(
        leading: const Icon(Icons.checklist),
        title: 'Atividades',
        subtitle: count > 0 ? '$count atividade(s) selecionada(s)' : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count > 0 ? '$count' : 'Preencher',
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
          store.setDotIndicator(4);
          bottomSheet(context, carouselController, controlerPages, store);
        },
      );
    });
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
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
                    tipo(context),
                    Observer(builder: (_) {
                      return Visibility(
                        visible: store.mostrarErroFormulario &&
                            (store.novoTipoProtocolo ?? "").isEmpty,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                            'Tipo obrigatório',
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
              child:
                  // store.isProtocoloListLoading
                  // ? const CircularProgressIndicator(
                  //     color: Colors.white,
                  //   )
                  // :
                  store.isEditing
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
                        ),
              onPressed: () {
                store.validarNovoProtocolo();
                if (!store.isValid) {
                  toastError(
                      message:
                          "Preencha todos campos do formulario corretamente!");
                  return;
                }
                store.registrarProtocolo();
              }, //store.registrarReservatorio(),
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
                    maxLines: 1,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                (store.novoNomeProtocolo ?? "").isNotEmpty
                    ? Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Observer(builder: (_) {
                                return Text(
                                  store.novoNomeProtocolo ?? "",
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    color: Constants.kPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              }),
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
              bottomSheet(context, carouselController, controlerPages, store);
            });
      }),
    );
  }

  InkWell cultura(BuildContext context) {
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
                    'Cultura',
                    maxLines: 1,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                store.novaCulturaProtocolo != null
                    ? Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                store.novaCulturaProtocolo?.nome ?? 'Preencher',
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
              store.setDotIndicator(1);
              bottomSheet(context, carouselController, controlerPages, store);
            });
      }),
    );
  }

  InkWell tipo(BuildContext context) {
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
                    'Tipo',
                    maxLines: 1,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                (store.novoTipoProtocolo ?? "").isNotEmpty
                    ? Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                store.novoTipoProtocolo ?? "",
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
              store.setDotIndicator(2);
              bottomSheet(context, carouselController, controlerPages, store);
            });
      }),
    );
  }

  InkWell sistema(BuildContext context) {
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
                    'Sistema de \ncultivo',
                    maxLines: 2,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                (store.novoSistemaProtocolo ?? "").isNotEmpty
                    ? Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                store.novoSistemaProtocolo ?? "",
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
              store.setDotIndicator(3);
              bottomSheet(context, carouselController, controlerPages, store);
            });
      }),
    );
  }

  InkWell forma(BuildContext context) {
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
                    'Forma de \nimplantação',
                    maxLines: 2,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                (store.novoFormaProtocolo ?? "").isNotEmpty
                    ? Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                store.novoFormaProtocolo ?? "",
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
              store.setDotIndicator(4);
              bottomSheet(context, carouselController, controlerPages, store);
            });
      }),
    );
  }

  InkWell atividades(BuildContext context) {
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
                    'Atividades',
                    maxLines: 2,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                store.novasAtividadesProtocolo.isNotEmpty
                    ? Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                store.novasAtividadesProtocolo.length
                                    .toString(),
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
              store.setDotIndicator(5);
              bottomSheet(context, carouselController, controlerPages, store);
            });
      }),
    );
  }
}

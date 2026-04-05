import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/protocolo_store.dart';
import 'package:osi_solucoes/features/presenter/views/protocolo/components/editar_page/editarBottomSheet.dart';

import '../../../../core/utils/toast.dart';

class EditarProtocoloPage extends StatefulWidget {
  const EditarProtocoloPage({
    super.key,
  });

  @override
  State<EditarProtocoloPage> createState() => _EditarProtocoloPageState();
}

class _EditarProtocoloPageState extends State<EditarProtocoloPage> {
  CarouselSliderController carouselController = CarouselSliderController();
  CarouselSliderController controlerPages = CarouselSliderController();
  ProtocoloStore store = GetIt.I<ProtocoloStore>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.buscarCulturas();
      store.buscarFasesDetalhes();
      store.prepararListaDetalhesFase();
      store.setMostrarErroFormulario(false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    store.limparProtocoloDetalhes();
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
                            store.novaCulturaProtocoloDetalhes?.nome == null,
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
                            store.novaCulturaProtocoloDetalhes?.nome == null,
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
        'Editar Informações do protocolo selecionado',
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
        'Editar Protocolo',
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
              onPressed: store.loteFoiAlterado == true
                  ? () {
                      if (!store.loteFoiAlterado) {
                        toastError(
                            message:
                                "Realize alguma alteração para atualizar o protocolo!");
                        return;
                      }
                      store.atualizarProtocolo();
                    }
                  : null,
              child: const Text(
                "Atualizar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                (store.novoNomeProtocoloDetalhes ?? "").isNotEmpty
                    ? Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Observer(builder: (_) {
                                return Text(
                                  store.novoNomeProtocoloDetalhes ??
                                      "Preencher",
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
                    : Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Observer(builder: (_) {
                                return Text(
                                  store.protocoloSelecionado!.nome ??
                                      "Preencher",
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
              ],
            ),
            onTap: () {
              store.setDotIndicatorEdit(0);
              editarBottomSheet(
                  context, carouselController, controlerPages, store);
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
                store.novaCulturaProtocoloDetalhes != null
                    ? Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                store.novaCulturaProtocoloDetalhes?.nome ??
                                    'Preencher',
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
                    : Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                store.protocoloSelecionado?.cultura?.nome ??
                                    "Preencher",
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
              ],
            ),
            onTap: () {
              store.setDotIndicatorEdit(1);
              editarBottomSheet(
                  context, carouselController, controlerPages, store);
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
                (store.novoTipoProtocoloDetalhes ?? "").isNotEmpty
                    ? Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                store.novoTipoProtocoloDetalhes ?? "",
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
                    : Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                store.protocoloSelecionado!.tipo_cultura ??
                                    "Preencher",
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
              ],
            ),
            onTap: () {
              store.setDotIndicatorEdit(2);
              editarBottomSheet(
                  context, carouselController, controlerPages, store);
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
                (store.novoSistemaProtocoloDetalhes ?? "").isNotEmpty
                    ? Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                store.novoSistemaProtocoloDetalhes ??
                                    "Preencher",
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
                    : Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                store.protocoloSelecionado!.sistema_cultivo ??
                                    "Preencher",
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
              ],
            ),
            onTap: () {
              store.setDotIndicatorEdit(3);
              editarBottomSheet(
                  context, carouselController, controlerPages, store);
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
                (store.novoFormaProtocoloDetalhes ?? "").isNotEmpty
                    ? Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                store.novoFormaProtocoloDetalhes ?? "Preencher",
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
                    : Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                store.protocoloSelecionado!.implantacao ??
                                    "Preencher",
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
              ],
            ),
            onTap: () {
              store.setDotIndicatorEdit(4);
              editarBottomSheet(
                  context, carouselController, controlerPages, store);
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
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          store.novasAtividadesDetalhesProtocolo.length
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
                ),
              ],
            ),
            onTap: () {
              store.setDotIndicatorEdit(5);
              editarBottomSheet(
                  context, carouselController, controlerPages, store);
            });
      }),
    );
  }
}

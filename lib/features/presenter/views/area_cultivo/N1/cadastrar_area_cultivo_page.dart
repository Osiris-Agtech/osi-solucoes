import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_selection_tile.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_primary_button.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/components/bottomSheet.dart';

class CadastrarAreaCultivo extends StatefulWidget {
  const CadastrarAreaCultivo({super.key});

  @override
  State<CadastrarAreaCultivo> createState() => _CadastrarAreaCultivoState();
}

class _CadastrarAreaCultivoState extends State<CadastrarAreaCultivo> {
  AreaCultivoStore store = GetIt.I<AreaCultivoStore>();
  CarouselSliderController carouselController = CarouselSliderController();
  CarouselSliderController controlerPages = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    store.buscarLocalizacoes();
    store.setShowTextFormField(false);
    store.setMostrarErroFormulario(false);
  }

  @override
  void dispose() {
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
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (store.novaAreaDescricao.text.isEmpty) {
            store.setShowTextFormField(false);
          }
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: appBar(),
            backgroundColor: Constants.kBackgroundColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                            store.novaAreaName.text.isEmpty,
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
                    localizacao(context),
                    const Divider(),
                    descricao(context),
                    // solucaoNutritiva(context),
                    // const Divider(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .4,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffF5F5F5),
                          ),
                          child: Observer(
                            builder: (_) {
                              return SizedBox(
                                width: double.infinity,
                                child: store.novaAreaDescricao.text.isEmpty &&
                                        !store.showTextFormField
                                    ? botaoDescricao()
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: TextFormField(
                                          autofocus: true,
                                          maxLines: 20,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none),
                                          controller: store.novaAreaDescricao,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
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
        'Criando Nova Área de Cultivo',
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

  Widget saveButton(Size size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: SizedBox(
        width: size.width * .8,
        child: Observer(builder: (_) {
          return AppPrimaryButton(
            label: store.isEditing ? 'Alterar' : 'Salvar',
            isLoading: store.isNovaAreaLoading,
            onPressed: () {
              if (store.validarCadastro()) {
                if (store.isEditing) {
                  store.alterarArea();
                } else {
                  store.registrarArea();
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
      final hasName = store.novaAreaName.text.isNotEmpty;
      return AppFormSelectionTile(
        leading: const Icon(Icons.label),
        title: 'Nome',
        subtitle: hasName ? store.novaAreaName.text : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              hasName ? store.novaAreaName.text : 'Preencher',
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
          bottomSheet(context, controlerPages, carouselController, store);
        },
      );
    });
  }

  Widget localizacao(BuildContext context) {
    return Observer(builder: (_) {
      final hasLoc = store.localizacaoSelecionada.endereco != null &&
          store.localizacaoSelecionada.endereco!.isNotEmpty;
      return AppFormSelectionTile(
        leading: const Icon(Icons.location_on),
        title: 'Localização',
        subtitle: hasLoc ? store.localizacaoSelecionada.endereco : null,
        trailing: hasLoc
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    store.localizacaoSelecionada.endereco!,
                    style: const TextStyle(
                      color: Constants.kPrimaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Icon(Icons.chevron_right,
                      color: Constants.kPrimaryColor),
                ],
              )
            : const Icon(Icons.chevron_right, color: Constants.kPrimaryColor),
        onTap: () {
          store.setDotIndicator(1);
          bottomSheet(context, controlerPages, carouselController, store);
        },
      );
    });
  }

  InkWell descricao(BuildContext context) {
    return InkWell(
      child: ListTile(
        leading: const Icon(Icons.description),
        title: const Text(
          'Descrição',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        onTap: () {
          // bottomSheet(context, controlerPages, carouselController, store);
        },
      ),
    );
  }

  Padding botaoDescricao() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          store.setShowTextFormField(true);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.add,
              color: Colors.green,
            ),
            Text('Adicionar descrição'),
            Text('(opcional)')
          ],
        ),
      ),
    );
  }
}

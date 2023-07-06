import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/utils/decimal_format.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/components/bottomSheet.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/components/customTextFormField.dart';
import '../../../../../core/constants/constants.dart';
import '../../routes/routes.dart';

class CadastrarSolucaoPage extends StatefulWidget {
  final bool isShortcut;
  const CadastrarSolucaoPage({
    Key? key,
    this.isShortcut = false,
  }) : super(key: key);

  @override
  State<CadastrarSolucaoPage> createState() => _CadastrarSolucaoPageState();
}

class _CadastrarSolucaoPageState extends State<CadastrarSolucaoPage>
    with TickerProviderStateMixin {
  CarouselController carouselController = CarouselController();
  CarouselController controlerPages = CarouselController();
  SolucaoStore store = GetIt.I<SolucaoStore>();
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    store.buscarFertilizantes();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    store.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () {},
        child: SafeArea(
          child: DefaultTabController(
            length: tabController.length,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: appBar(),
              backgroundColor: Constants.kBackgroundColor,
              body: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    titulo(),
                    const SizedBox(height: 20),
                    subtitulo(),
                    const SizedBox(height: 10),
                    _nome(context),
                    Observer(builder: (_) {
                      return Visibility(
                        visible: store.mostrarErroFormulario &&
                            store.novaSolucaoName.text.isEmpty,
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
                    _fertilizantes(context),
                    Observer(builder: (_) {
                      return Visibility(
                        visible: store.mostrarErroFormulario &&
                            store.expandedFertilizantes.isEmpty,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                            'Adicione fertilizante à lista',
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
                    Expanded(
                      child: Observer(builder: (_) {
                        if (store.expandedFertilizantes.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xffF5F5F5),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: avisoFertilizante(),
                              ),
                            ),
                          );
                        }

                        return _cardListWithData();
                      }),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: isKeyboardOpen ? null : _nextButton(size),
            ),
          ),
        ),
      ),
    );
  }

  _cardListWithData() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            16.0,
            16.0,
            16.0,
            8.0,
          ),
          child: TabBar(
            controller: tabController,
            unselectedLabelColor: const Color(0xFF929292),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            labelColor: Constants.kPrimaryColor,
            labelPadding: const EdgeInsets.all(0),
            indicatorPadding: const EdgeInsets.all(0),
            tabs: const [
              Tab(
                child: Text(
                  "Fertilizantes\nSelecionados",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Relação\nde Nutrientes",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              _fertilizanteCardList(),
              _relacaoList(),
            ],
          ),
        ),
      ],
    );
  }

  _fertilizanteCardList() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffF5F5F5),
        ),
        child: Observer(
          builder: (_) {
            if (store.expandedFertilizantes.isEmpty) {
              return SizedBox(
                width: double.infinity,
                child: avisoFertilizante(),
              );
            }
            return Observer(builder: (_) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: store.expandedFertilizantes.length,
                  itemBuilder: (context, indexExpended) {
                    return Padding(
                      padding: EdgeInsets.only(
                          top: indexExpended == 0 ? 16.0 : 4.0,
                          bottom: indexExpended ==
                                  store.expandedFertilizantes.length - 1
                              ? 16.0
                              : 0.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
                          child: ExpansionPanelList(
                            expandedHeaderPadding:
                                const EdgeInsets.only(bottom: 5),
                            elevation: 0,
                            expansionCallback: (_, bool isExpanded) {
                              store.setExpandedCard(indexExpended);
                            },
                            children: [
                              ExpansionPanel(
                                backgroundColor: Constants.kBackgroundColor,
                                canTapOnHeader: true,
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return headerCard(
                                    store.expandedFertilizantes[indexExpended],
                                  );
                                },
                                body: bodyCard(
                                  store.expandedFertilizantes[indexExpended],
                                  indexExpended,
                                ),
                                isExpanded: store
                                    .expandedFertilizantes[indexExpended]
                                    .isExpanded,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            });
          },
        ),
      ),
    );
  }

  _relacaoList() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffF5F5F5),
        ),
        child: Observer(
          builder: (_) {
            if (store.nutrientesCalculados.isEmpty) {
              return SizedBox(
                width: double.infinity,
                child: avisoFertilizante(),
              );
            }
            return Observer(builder: (_) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: store.nutrientesCalculados.length,
                  itemBuilder: (context, indexExpended) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: indexExpended == 0 ? 28 : 8,
                        bottom: indexExpended ==
                                store.nutrientesCalculados.length - 1
                            ? 28
                            : 8.0,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  store.nutrientesCalculados[indexExpended]
                                          .nutriente?.sigla ??
                                      'Não informado',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Constants.kText2,
                                  ),
                                ),
                                Text(
                                  getCurrency(store
                                          .nutrientesCalculados[indexExpended]
                                          .teor_nutriente ??
                                      '0.0'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Constants.kText2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: indexExpended !=
                                store.nutrientesCalculados.length - 1,
                            child: const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            });
          },
        ),
      ),
    );
  }

  bodyCard(ItemFertilizante itemFertilizante, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomTextFormField(
            value: itemFertilizante.quantidade,
            onEditingComplete: () {
              store.setExpandedCard(index);
            },
            onChanged: (String value) {
              store.setFertilizanteQuantidade(
                itemFertilizante.fertilizante.id ?? 0,
                value,
              );
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              store.removeFromExpendedList(
                  itemFertilizante.fertilizante.id ?? 0);
            },
            child: const Text(
              'Remover',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Constants.kErrorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  headerCard(ItemFertilizante itemFertilizante) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 0),
      dense: true,
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      title: Text(
        itemFertilizante.fertilizante.nome ?? 'Não informado',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Constants.kText2,
        ),
      ),
      subtitle: itemFertilizante.isExpanded
          ? null
          : Text(
              'Quantidade: ${itemFertilizante.quantidade} mg/L',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Constants.kGreyMedium,
              ),
            ),
    );
  }

  Widget subtitulo() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 30,
        right: 20,
      ),
      child: Text(
        'Cadastrar informações',
        style: TextStyle(
          fontSize: 14,
          color: Constants.kGreyText,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget titulo() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: Text(
        'Nova Solução Nutritiva',
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

  _nome(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: InkWell(
        child: Observer(builder: (_) {
          return ListTile(
            leading: const Icon(Icons.label),
            title: const Text(
              'Nome',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            trailing: store.novaSolucaoName.text.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        store.novaSolucaoName.text,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Constants.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Constants.kPrimaryColor,
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "Preencher",
                        style: TextStyle(
                          fontSize: 12,
                          color: Constants.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: Constants.kPrimaryColor,
                      ),
                    ],
                  ),
            onTap: () {
              store.setDotIndicator(0);
              bottomSheet(context, carouselController, controlerPages, store);
            },
          );
        }),
      ),
    );
  }

  _fertilizantes(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: InkWell(
        child: Observer(builder: (_) {
          return ListTile(
            leading: const Icon(Icons.invert_colors),
            title: const Text(
              'Fertilizantes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            trailing: store.selectedFertilizantes.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${store.selectedFertilizantes.length} unidades',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Constants.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Constants.kPrimaryColor,
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "Selecionar",
                        style: TextStyle(
                          fontSize: 12,
                          color: Constants.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: Constants.kPrimaryColor,
                      ),
                    ],
                  ),
            onTap: () {
              store.setDotIndicator(1);
              bottomSheet(context, carouselController, controlerPages, store);
            },
          );
        }),
      ),
    );
  }

  Padding avisoFertilizante() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/alert-triangle.svg",
            // color: Constants.kButtonGrey,
            height: 32,
          ),
          const Text(
            'Nenhum fertilizante\nselecionado',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _nextButton(Size size) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
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
          child: Observer(builder: (_) {
            if (store.isNovaSolucaoLoading) {
              return const CircularProgressIndicator(
                color: Constants.kBackgroundColor,
              );
            }

            return const Text(
              "Avançar",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            );
          }),
          onPressed: () {
            // Validate Page
            if (store.validateNewSN()) {
              store.setFertilizantesEscolhidos();
              Get.toNamed(Routes.cadastrarSolucaoConcentradaPage);
            }
          },
        ),
      ),
    );
  }
}

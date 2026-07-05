import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dtp;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_entity_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_delete_dialog.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';
import 'package:osi_solucoes/features/presenter/widgets/floating_actino_button.dart';

class SetorPage extends StatefulWidget {
  const SetorPage({super.key});
  @override
  SetorPageState createState() => SetorPageState();
}

class SetorPageState extends State<SetorPage> {
  SetorStore store = GetIt.I<SetorStore>();

  final dropDownKey = GlobalKey<DropdownSearchState<String>>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    store.setSearchSetorText('');
    store.buscarSetores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          backgroundColor: Constants.kSecondBackgroundColor,
          // floatingActionButton: const NewFloactingButton(),
          floatingActionButton: const NewFloatingActionButton(
            nivel: 2,
          ),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              primary: false,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _N2PageHeader(areaN1: store.areaSelecionada, store: store),
                Observer(builder: (_) {
                  if (store.isSetorListLoading) {
                    return const SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: AppStateKind.loading,
                        title: 'Carregando setores',
                        message:
                            'Aguarde enquanto buscamos os setores cadastrados.',
                      ),
                    );
                  }
                  if (store.setorList.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: AppStateKind.empty,
                        title: 'Nenhum setor cadastrado',
                        message:
                            'Cadastre um setor nesta área de cultivo para começar.',
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 10.0),
                          child: AppEntityCard(
                            leading: Image.asset(
                              "assets/icons/hydroponic1_icon.png",
                              height: 26,
                            ),
                            title: store.searchSetor[index].nome ?? '',
                            subtitle: '# ${store.searchSetor[index].id}',
                            metadata: [
                              Text(
                                'Lotes: ${store.searchSetor[index].lotes?.where((l) => l.ativo == true).length ?? 0}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Constants.kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            onTap: () {
                              final loteStore = GetIt.I<LoteStore>();
                              loteStore.setSetorSelecionado(
                                  store.searchSetor[index]);
                              Get.toNamed(Routes.lotePage);
                            },
                          ),
                        );
                      },
                      childCount: store.searchSetor.length,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _N2PageHeader extends StatefulWidget {
  final Area areaN1;
  const _N2PageHeader({
    super.key,
    required this.areaN1,
    required this.store,
  });

  final SetorStore store;

  @override
  State<_N2PageHeader> createState() => _N2PageHeaderState();
}

class _N2PageHeaderState extends State<_N2PageHeader> {
  AreaCultivoStore areaStore = GetIt.I<AreaCultivoStore>();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return AppPageHeaderSliver(
        title: widget.areaN1.nome ?? '',
        subtitle: 'Lista de setores cadastrados',
        onBack: () => Get.back(),
        pinned: true,
        actions: [
          PopupMenuButton<void>(
            icon: SvgPicture.asset(
              "assets/icons/settings_icon.svg",
              colorFilter: ColorFilter.mode(
                Constants.kButtonGrey,
                BlendMode.srcIn,
              ),
              height: 20,
            ),
            itemBuilder: (context) => <PopupMenuEntry<void>>[
              PopupMenuItem<void>(
                child: const Row(
                  children: [
                    Text('Editar'),
                  ],
                ),
                onTap: () async {
                  areaStore.setAreaEditing(widget.areaN1);
                  Get.toNamed(Routes.cadastrarAreaCultivoPage);
                },
              ),
              const PopupMenuDivider(),
              PopupMenuItem<void>(
                child: const Row(
                  children: [
                    Icon(Icons.delete_outline,
                        size: 18, color: Constants.kErrorColor),
                    SizedBox(width: 8),
                    Text(
                      'Deletar área',
                      style: TextStyle(color: Constants.kErrorColor),
                    ),
                  ],
                ),
                onTap: () => _confirmarDelecaoArea(context),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            widget.store.dropDownValue == "Data" ? 75 : 50,
          ),
          child: _N2FilterArea(store: widget.store),
        ),
      );
    });
  }

  Future<void> _confirmarDelecaoArea(BuildContext context) async {
    final nomeArea = widget.areaN1.nome ?? 'área';
    final confirmou = await AppDeleteDialog.show(
      context: context,
      title: 'Deletar área?',
      message: 'A área "$nomeArea", todos os setores, lotes e agendas vinculados serão desativados permanentemente.',
      infoText: 'Setores, lotes e agendas desta área também serão removidos em cascata.',
    );
    if (confirmou && context.mounted) {
      await areaStore.deletarAreaCascade(widget.areaN1.id!);
    }
  }
}

class _N2FilterArea extends StatelessWidget {
  final SetorStore store;
  const _N2FilterArea({required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: store.dropDownValue == "Data" ? 75 : 50,
      color: const Color(0xFFF8F8F6),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
      ),
      child: SizedBox(
        height: store.dropDownValue == "Data" ? 70 : 50,
        width: double.infinity,
        child: Row(
          children: [
            Observer(builder: (_) {
              return Padding(
                padding: const EdgeInsets.only(right: 15.0, left: 10),
                child: store.dropDownValue == "Nome"
                    ? const Icon(Icons.search)
                    : const Icon(Icons.calendar_month_outlined),
              );
            }),
            store.dropDownValue == "Nome" ? Container() : const Spacer(),
            Observer(
              builder: (_) {
                return store.dropDownValue == "Nome"
                    ? Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Buscar...",
                            hintStyle: TextStyle(
                              fontFamily: "Roboto",
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (newValue) {
                            store.setSearchSetorText(newValue);
                          },
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Text("De:"),
                              InkWell(
                                onTap: () {
                                  dtp.DatePicker.showDatePicker(
                                    context,
                                    currentTime: store.data1,
                                    locale: dtp.LocaleType.pt,
                                    showTitleActions: true,
                                    minTime: DateTime(2018, 3, 5),
                                    maxTime: DateTime(2030, 12, 30),
                                    onConfirm: (date) async {
                                      store.setData1(date);
                                      await store.buscarSetores();
                                    },
                                    theme: const dtp.DatePickerTheme(
                                      doneStyle: TextStyle(
                                        color: Constants.kPrimaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      "${store.data1.day} / ${store.data1.month} / ${store.data1.year}",
                                      style: const TextStyle(
                                        color: Constants.kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Até"),
                              InkWell(
                                onTap: () {
                                  dtp.DatePicker.showDatePicker(
                                    context,
                                    currentTime: store.data2,
                                    locale: dtp.LocaleType.pt,
                                    showTitleActions: true,
                                    minTime: DateTime(2018, 3, 5),
                                    maxTime: DateTime(2030, 12, 30),
                                    onConfirm: (date) async {
                                      store.setData2(date);
                                      await store.buscarSetores();
                                    },
                                    theme: const dtp.DatePickerTheme(
                                      doneStyle: TextStyle(
                                        color: Constants.kPrimaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      "${store.data2.day} / ${store.data2.month} / ${store.data2.year}",
                                      style: const TextStyle(
                                        color: Constants.kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
              },
            ),
            const Spacer(),
            Observer(builder: (_) {
              return Container(
                height: 30,
                width: 80,
                decoration: const BoxDecoration(
                  color: Constants.kPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton<String>(
                      alignment: Alignment.center,
                      value: store.dropDownValue,
                      dropdownColor: Constants.kPrimaryColor,
                      underline:
                          DropdownButtonHideUnderline(child: Container()),
                      iconSize: 0,
                      iconEnabledColor: Constants.kPrimaryColor,
                      elevation: 16,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (String? newValue) async {
                        if (newValue == store.dropDownValue) {
                          store.changeOrder();
                        } else {
                          store.setSearchSetorText('');
                        }
                        store.setDropDown(newValue!);
                        await store.buscarSetores();
                      },
                      items: <String>['Nome', 'Data']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Observer(builder: (_) {
                      return Icon(
                        store.order == "asc"
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        size: 14,
                        color: Colors.white,
                      );
                    }),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

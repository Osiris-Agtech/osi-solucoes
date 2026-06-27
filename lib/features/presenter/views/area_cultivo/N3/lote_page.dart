import 'package:carousel_slider/carousel_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datetime_picker;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/components/finalizar_page/bottomSheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_entity_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';
import 'package:osi_solucoes/features/presenter/widgets/floating_actino_button.dart';
import 'package:osi_solucoes/core/services/navigation_resource_args.dart';

class LotePage extends StatefulWidget {
  const LotePage({super.key});

  @override
  State<LotePage> createState() => _LotePageState();
}

class _LotePageState extends State<LotePage> {
  LoteStore loteStore = GetIt.I<LoteStore>();

  final dropDownKey = GlobalKey<DropdownSearchState<String>>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loteStore.setSearchLoteText('');
    loteStore.buscarLotes();
    super.initState();
  }

  @override
  void dispose() {
    loteStore.limparFinalizacao();
    super.dispose();
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
          floatingActionButton: const NewFloatingActionButton(
            nivel: 3,
          ),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              primary: false,
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppBar(setorN2: loteStore.setorSelecionado, store: loteStore),
                Observer(builder: (_) {
                  if (loteStore.isLoteListLoading) {
                    return const SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: AppStateKind.loading,
                        title: 'Carregando lotes',
                        message: 'Aguarde enquanto buscamos os lotes cadastrados.',
                      ),
                    );
                  }
                  if (loteStore.loteList.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: AppStateKind.empty,
                        title: 'Nenhum lote cadastrado',
                        message: 'Cadastre um lote neste setor para começar.',
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
                          child: AppEntityCard(
                            leading: const Icon(Icons.eco, color: Color(0xFF26C165), size: 26),
                            title: loteStore.searchLote[index].nome ?? '',
                            subtitle: '# ${loteStore.searchLote[index].id}',
                            description: 'Cultura: ${loteStore.searchLote[index].cultura?.nome ?? ""}',
                            onTap: () {
                              loteStore.selecionarLote(loteStore.searchLote[index]);
                              Get.toNamed(
                                Routes.detalhesLotePage,
                                arguments: NavigationResourceArgs(
                                  resourceId: loteStore.searchLote[index].id?.toString(),
                                  resourceType: 'lote',
                                  resourceName: loteStore.searchLote[index].nome,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: loteStore.searchLote.length,
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

// ignore: camel_case_types
class AppBar extends StatefulWidget {
  final Setor setorN2;
  const AppBar({
    super.key,
    required this.setorN2,
    required this.store,
  });

  final LoteStore store;

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  SetorStore setorStore = GetIt.I<SetorStore>();
  LoteStore loteStore = GetIt.I<LoteStore>();

  CarouselSliderController carouselController = CarouselSliderController();
  CarouselSliderController controlerPages = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return AnimatedContainer(
        duration: const Duration(seconds: 2),
        child: SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          toolbarHeight: widget.store.dropDownValue == "Data" ? 200 : 175,
          floating: true,
          automaticallyImplyLeading: false,
          forceElevated: true,
          elevation: 1,
          actions: [
            Align(
              alignment: const Alignment(0.6, -0.9),
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          loteStore.setDotIndicator(0);
                          loteStore.listaLotesParaFinalizar();
                          bottomSheet(
                              context, carouselController, controlerPages);
                        },
                        icon: const Icon(
                          Icons.done_all_outlined,
                          color: Constants.kPrimaryColor,
                        ),
                      ),
                      PopupMenuButton(
                        icon: SvgPicture.asset(
                          "assets/icons/settings_icon.svg",
                          colorFilter: ColorFilter.mode(
                            Constants.kButtonGrey,
                            BlendMode.srcIn,
                          ),
                          height: 20,
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: const [
                                Text('Editar'),
                              ],
                            ),
                            onTap: () async {
                              setorStore.setSetorEditing(widget.setorN2);
                              Get.toNamed(Routes.cadastrarSetorPage);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                  color: Constants.kPrimaryColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  widget.setorN2.nome ?? '',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                child: Text(
                  'Lista de lotes cadastrados',
                  style: const TextStyle(
                    color: Constants.kGreyMedium,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: widget.store.dropDownValue == "Data" ? 75 : 50,
                color: const Color(0xFFF8F8F6),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                ),
                child: SizedBox(
                  height: widget.store.dropDownValue == "Data" ? 70 : 50,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Observer(builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 15.0, left: 10),
                          child: widget.store.dropDownValue == "Nome"
                              ? const Icon(Icons.search)
                              : const Icon(Icons.calendar_month_outlined),
                        );
                      }),
                      widget.store.dropDownValue == "Nome"
                          ? Container()
                          : const Spacer(),
                      Observer(
                        builder: (_) {
                          return widget.store.dropDownValue == "Nome"
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
                                      widget.store.setSearchLoteText(newValue);
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
                                            datetime_picker.DatePicker
                                                .showDatePicker(
                                              context,
                                              currentTime: widget.store.data1,
                                              locale:
                                                  datetime_picker.LocaleType.pt,
                                              showTitleActions: true,
                                              minTime: DateTime(2018, 3, 5),
                                              maxTime: DateTime(2030, 12, 30),
                                              onConfirm: (date) async {
                                                widget.store.setData1(date);
                                                await widget.store
                                                    .buscarLotes();
                                              },
                                              theme: const datetime_picker
                                                  .DatePickerTheme(
                                                doneStyle: TextStyle(
                                                  color:
                                                      Constants.kPrimaryColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5,
                                              ),
                                              child: Text(
                                                "${widget.store.data1.day} / ${widget.store.data1.month} / ${widget.store.data1.year}",
                                                style: const TextStyle(
                                                  color:
                                                      Constants.kPrimaryColor,
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
                                            datetime_picker.DatePicker
                                                .showDatePicker(
                                              context,
                                              currentTime: widget.store.data2,
                                              locale:
                                                  datetime_picker.LocaleType.pt,
                                              showTitleActions: true,
                                              minTime: DateTime(2018, 3, 5),
                                              maxTime: DateTime(2030, 12, 30),
                                              onConfirm: (date) async {
                                                widget.store.setData2(date);
                                                await widget.store
                                                    .buscarLotes();
                                              },
                                              theme: const datetime_picker
                                                  .DatePickerTheme(
                                                doneStyle: TextStyle(
                                                  color:
                                                      Constants.kPrimaryColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5,
                                              ),
                                              child: Text(
                                                "${widget.store.data2.day} / ${widget.store.data2.month} / ${widget.store.data2.year}",
                                                style: const TextStyle(
                                                  color:
                                                      Constants.kPrimaryColor,
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
                                value: widget.store.dropDownValue,
                                dropdownColor: Constants.kPrimaryColor,
                                underline: DropdownButtonHideUnderline(
                                    child: Container()),
                                iconSize: 0,
                                iconEnabledColor: Constants.kPrimaryColor,
                                elevation: 16,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                style: const TextStyle(color: Colors.white),
                                onChanged: (String? newValue) async {
                                  if (newValue == widget.store.dropDownValue) {
                                    widget.store.changeOrder();
                                  } else {
                                    widget.store.setSearchLoteText('');
                                  }
                                  widget.store.setDropDown(newValue!);
                                  await widget.store.buscarLotes();
                                },
                                items: <String>[
                                  'Nome',
                                  'Data'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                }).toList(),
                              ),
                              Observer(builder: (_) {
                                return Icon(
                                  widget.store.order == "asc"
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
              ),
            ],
          ),
        ),
      );
    });
  }
}


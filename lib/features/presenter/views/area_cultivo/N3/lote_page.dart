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
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/components/finalizar_page/bottomSheet.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/components/topAppBarArea.dart';
import 'package:osi_solucoes/features/presenter/widgets/floating_actino_button.dart';
import 'package:osi_solucoes/core/services/navigation_analytics.dart';

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
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 200.0, left: 60, right: 60),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  if (loteStore.loteList.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 200.0, left: 60, right: 60),
                        child: Center(
                          child: Text(
                            "Não há lotes cadastrados neste setor",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff6F6464),
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Observer(builder: (_) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, top: 10),
                            child: CardLote(
                              lote: loteStore.searchLote[index],
                            ),
                          );
                        });
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
              TopAppBarArea(
                namePage1: "Setor: ",
                namePage2: widget.setorN2.nome ?? '',
                subtitle: "Lista de lotes cadastrados",
              ),
              const SizedBox(
                height: 30,
              ),
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

class CardLote extends StatefulWidget {
  final Lote lote;
  const CardLote({super.key, required this.lote});

  @override
  State<CardLote> createState() => _CardLoteState();
}

class _CardLoteState extends State<CardLote> {
  LoteStore store = GetIt.I<LoteStore>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        store.selecionarLote(widget.lote);
        // Rastrear navegação com ID e nome do recurso
        NavigationAnalytics.logNavigation(
          Routes.detalhesLotePage,
          resourceId: widget.lote.id?.toString(),
          resourceType: 'lote',
          resourceName: widget.lote.nome,
        );
        Get.toNamed(Routes.detalhesLotePage);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.eco,
                            size: 26,
                            color: Color(0xFF26C165),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "# ${widget.lote.id}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        bottom: 2.0,
                        top: 8.0,
                      ),
                      child: Text(
                        widget.lote.nome ?? '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Constants.kGreyText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Cultura: ",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "${widget.lote.cultura?.nome}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Constants.kPrimaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Constants.kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

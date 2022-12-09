import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/cadastrar_area_cultivo_page.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/lote_page.dart';
import 'package:osi_solucoes/features/presenter/widgets/floating_actino_button.dart';
import '../../home/components/top_app_bar.dart';

class SetorPage extends StatefulWidget {
  const SetorPage({Key? key}) : super(key: key);
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
                AppBar(areaN1: store.areaSelecionada, store: store),
                Observer(builder: (_) {
                  if (store.isSetorListLoading) {
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
                  if (store.setorList.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 200.0, left: 60, right: 60),
                        child: Center(
                          child: Text(
                            "Não há setores cadastrados nesta área de cultivo",
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
                            child: CardSetor(
                              setor: store.searchSetor[index],
                            ),
                          );
                        });
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

// ignore: camel_case_types
class AppBar extends StatefulWidget {
  final Area areaN1;
  const AppBar({
    Key? key,
    required this.areaN1,
    required this.store,
  }) : super(key: key);

  final SetorStore store;

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  AreaCultivoStore areaStore = GetIt.I<AreaCultivoStore>();
  SetorStore store = GetIt.I<SetorStore>();
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return AnimatedContainer(
        duration: const Duration(seconds: 2),
        child: SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          toolbarHeight: store.dropDownValue == "Data" ? 200 : 175,
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: PopupMenuButton(
                      icon: SvgPicture.asset(
                        "assets/icons/settings_icon.svg",
                        color: Constants.kButtonGrey,
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
                            await areaStore.setAreaEditing(widget.areaN1);
                            Get.to(
                              () => const CadastrarAreaCultivo(),
                              transition: Transition.rightToLeft,
                            );
                          },
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: const [
                              Text('Deletar'),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopAppBar(
                namePage: widget.areaN1.nome ?? '',
                subtitle: "Lista de setores cadastrados",
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
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
                      store.dropDownValue == "Nome"
                          ? Container()
                          : const Spacer(),
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
                                            DatePicker.showDatePicker(
                                              context,
                                              currentTime: store.data1,
                                              locale: LocaleType.pt,
                                              showTitleActions: true,
                                              minTime: DateTime(2018, 3, 5),
                                              maxTime: DateTime(2030, 12, 30),
                                              onConfirm: (date) async {
                                                store.setData1(date);
                                                await store.buscarSetores();
                                              },
                                              theme: const DatePickerTheme(
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
                                                "${store.data1.day} / ${store.data1.month} / ${store.data1.year}",
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
                                            DatePicker.showDatePicker(
                                              context,
                                              currentTime: store.data2,
                                              locale: LocaleType.pt,
                                              showTitleActions: true,
                                              minTime: DateTime(2018, 3, 5),
                                              maxTime: DateTime(2030, 12, 30),
                                              onConfirm: (date) async {
                                                store.setData2(date);
                                                await store.buscarSetores();
                                              },
                                              theme: const DatePickerTheme(
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
                                                "${store.data2.day} / ${store.data2.month} / ${store.data2.year}",
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
                                value: store.dropDownValue,
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
                                  if (newValue == store.dropDownValue) {
                                    store.changeOrder();
                                  } else {
                                    store.setSearchSetorText('');
                                  }
                                  store.setDropDown(newValue!);
                                  await store.buscarSetores();
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
              ),
            ],
          ),
        ),
      );
    });
  }
}

class CardSetor extends StatefulWidget {
  final Setor setor;
  const CardSetor({Key? key, required this.setor}) : super(key: key);

  @override
  State<CardSetor> createState() => _CardSetorState();
}

class _CardSetorState extends State<CardSetor> {
  LoteStore loteStore = GetIt.I<LoteStore>();
  SetorStore setorStore = GetIt.I<SetorStore>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        loteStore.setSetorSelecionado(widget.setor);
        Get.to(
          () => const LotePage(),
          transition: Transition.rightToLeft,
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset(
                            "assets/icons/hydroponic1_icon.png",
                            height: 25,
                          ),
                          onPressed: null,
                        ),
                        Text(
                          "# ${widget.setor.id}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            widget.setor.nome ?? '',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Constants.kGreyText,
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Lotes: ",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "${widget.setor.lotes?.length ?? 0}",
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

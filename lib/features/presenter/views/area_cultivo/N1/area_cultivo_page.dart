import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N1/cadastrar_area_cultivo_page.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N2/setor_page.dart';
import '../../../viewmodels/area_cultivo_store.dart';
import '../../home/components/top_app_bar.dart';

class AreaCultivoPage extends StatefulWidget {
  const AreaCultivoPage({Key? key}) : super(key: key);
  @override
  AreaCultivoPageState createState() => AreaCultivoPageState();
}

class AreaCultivoPageState extends State<AreaCultivoPage> {
  AreaCultivoStore store = GetIt.I<AreaCultivoStore>();

  final dropDownKey = GlobalKey<DropdownSearchState<String>>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    store.buscarArea();
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
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          backgroundColor: Constants.kSecondBackgroundColor,
          floatingActionButton: const NewFloactingButton(),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              primary: false,
              physics: const BouncingScrollPhysics(),
              slivers: [
                appBar(store: store),
                Observer(builder: (_) {
                  if (store.isAreaLoading) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 200, left: 60, right: 60),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  if (store.areaList.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 200, left: 60, right: 60),
                        child: Center(
                          child: Text(
                            'Nenhuma área de cultivo cadastrada',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                  return showList();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverList showList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 5),
            child: CardArea(
              area: store.areaList[index],
            ),
          );
        },
        childCount: store.areaList.length,
      ),
    );
  }
}

class CardArea extends StatefulWidget {
  const CardArea({Key? key, required this.area}) : super(key: key);
  final Area area;

  @override
  State<CardArea> createState() => _CardAreaState();
}

class _CardAreaState extends State<CardArea> {
  SetorStore setorStore = GetIt.I<SetorStore>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setorStore.setAreaSelecionada(widget.area);
        Get.to(
          () => const SetorPage(),
          transition: Transition.rightToLeftWithFade,
        );
      },
      child: SizedBox(
        height: 185,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.8,
                alignment: Alignment.bottomRight,
                image: AssetImage("assets/images/greenhouse_background.png"),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            "assets/icons/cultivo_icon.svg",
                            height: 25,
                          ),
                          onPressed: null,
                        ),
                      ),
                      Text("# ${widget.area.id}",
                          style: const TextStyle(fontSize: 12)),
                      const Spacer(),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 5.0),
                      //   child: IconButton(
                      //     onPressed: () {},
                      //     icon: SvgPicture.asset(
                      //         "assets/icons/settings_black_icon.svg"),
                      //     color: Colors.black,
                      //   ),
                      // )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, bottom: 10),
                  child: Text(
                    widget.area.nome!,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: null,
                          icon: SvgPicture.asset(
                              "assets/icons/location_icon.svg")),
                      SizedBox(
                        width: 190,
                        child: Text(
                          '${widget.area.localizacao?.endereco}, ${widget.area.localizacao?.bairro}, ${widget.area.localizacao?.cidade} - ${widget.area.localizacao?.estado}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: IconButton(
                          icon: const Icon(Icons.chevron_right_rounded),
                          color: Constants.kPrimaryColor,
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55),
                  child: Text(
                    "${widget.area.setores?.length ?? 0} Setores",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 55),
                //   child: Text("${widget.area.setores?.length ?? 0} Lotes"),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewFloactingButton extends StatelessWidget {
  const NewFloactingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: SpeedDial(
        elevation: 10,
        backgroundColor: Constants.kPrimaryColor,
        icon: Icons.add,
        activeIcon: Icons.close,
        spaceBetweenChildren: 0,
        // childMargin: EdgeInsets.all(10),
        spacing: 10,
        iconTheme: const IconThemeData(size: 35),
        children: [
          SpeedDialChild(
            child: Image.asset(
              "assets/icons/hydroponic2_icon.png",
              height: 70,
            ),
            label: "Novo Lote",
            labelStyle: const TextStyle(fontSize: 18),
            onTap: () {},
          ),
          SpeedDialChild(
            child: Image.asset(
              "assets/icons/hydroponic1_icon.png",
              height: 70,
            ),
            label: "Novo Setor",
            labelStyle: const TextStyle(fontSize: 18),
            onTap: () {},
          ),
          SpeedDialChild(
            child: Image.asset(
              "assets/icons/greenhouse1_icon.png",
              height: 100,
            ),
            label: "Nova Área",
            labelStyle: const TextStyle(fontSize: 18),
            onTap: () => Get.to(
              () => const CadastrarAreaCultivo(),
              transition: Transition.rightToLeft,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class appBar extends StatelessWidget {
  const appBar({
    Key? key,
    required this.store,
  }) : super(key: key);

  final AreaCultivoStore store;

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
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopAppBar(
                path: "/Home/",
                namePage: "Áreas de Cultivo",
                subtitle: "Lista de áreas cadastrados",
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
                      Observer(builder: (_) {
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
                                          DatePicker.showDatePicker(context,
                                              locale: LocaleType.pt,
                                              showTitleActions: true,
                                              minTime: DateTime(2018, 3, 5),
                                              maxTime: DateTime(2030, 12, 30),
                                              onConfirm: (date) {
                                            store.setData1(date);
                                          });
                                        },
                                        child: Card(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5),
                                          child: Text(
                                              "${store.data1.day} / ${store.data1.month} / ${store.data1.year}",
                                              style: const TextStyle(
                                                  color:
                                                      Constants.kPrimaryColor)),
                                        )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Até"),
                                      InkWell(
                                        onTap: () {
                                          DatePicker.showDatePicker(context,
                                              locale: LocaleType.pt,
                                              showTitleActions: true,
                                              minTime: DateTime(2018, 3, 5),
                                              maxTime: DateTime(2030, 12, 30),
                                              onConfirm: (date) {
                                            store.setData2(date);
                                          });
                                        },
                                        child: Card(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5),
                                          child: Text(
                                              "${store.data2.day} / ${store.data2.month} / ${store.data2.year}",
                                              style: const TextStyle(
                                                  color:
                                                      Constants.kPrimaryColor)),
                                        )),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                      }),
                      const Spacer(),
                      Observer(builder: (_) {
                        return Container(
                          height: 30,
                          width: 70,
                          decoration: const BoxDecoration(
                            color: Constants.kPrimaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Center(
                            child: DropdownButton<String>(
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
                              onChanged: (String? newValue) {
                                store.setDropDown(newValue!);
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

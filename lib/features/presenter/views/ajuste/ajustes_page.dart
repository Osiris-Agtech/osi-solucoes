import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/ajuste/resultadoajuste_page.dart';

import '../../viewmodels/ajustes_store.dart';
import '../home/components/top_app_bar.dart';

class AjustesPage extends StatefulWidget {
  final String title;
  const AjustesPage({Key? key, this.title = 'AjustesPage'}) : super(key: key);
  @override
  AjustesPageState createState() => AjustesPageState();
}

class AjustesPageState extends State<AjustesPage> {
  // final ModulosStore modulosStore = Modular.get();
  // final AjustesStore store = Modular.get();
  AjustesStore store = GetIt.I<AjustesStore>();
  final formKey = GlobalKey<FormState>();
  final dropDownKey = GlobalKey<DropdownSearchState<String>>();

  @override
  Widget build(BuildContext context) {
    const snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        "Campo 'Buscar Reservatório...' obrigatório!",
        style: TextStyle(color: Constants.kErrorColor),
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          backgroundColor: Constants.kSecondBackgroundColor,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                store.reservatorio.text.isNotEmpty
                    ? Get.to(
                        () => const ResultadoajustePage(),
                        transition: Transition.rightToLeft,
                      )
                    : ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              backgroundColor: Constants.kPrimaryColor,
              label: const Text(
                'Calcular',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.white,
                  toolbarHeight: 175,
                  floating: true,
                  automaticallyImplyLeading: false,
                  forceElevated: true,
                  elevation: 1,
                  flexibleSpace: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TopAppBar(
                        path: "/Home/",
                        namePage: "Ajustes",
                        subtitle: "Selecione e ajuste seu reservatório",
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                          height: 50,
                          color: const Color(0xFFF8F8F6),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04,
                          ),
                          child: DropdownSearch<String>(
                            key: dropDownKey,
                            mode: Mode.MENU,
                            showSelectedItems: true,
                            items: store.listaReservatorios,
                            dropDownButton: const Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                              color: Constants.kPrimaryColor,
                            ),
                            dropdownSearchDecoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIconConstraints: const BoxConstraints(
                                  maxHeight: 50, maxWidth: 50),
                              contentPadding: const EdgeInsets.only(top: 15),
                              alignLabelWithHint: true,
                              hintText: "Buscar Reservatório...",
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(right: 5.0, left: 10),
                                child: SvgPicture.asset(
                                  "assets/icons/reservatorio_icon.svg",
                                ),
                              ),
                            ),
                            onChanged: (data) {
                              print;
                              store.setReservatorio(data!);
                            },
                            showSearchBox: true,
                            showAsSuffixIcons: true,
                          )),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.023,
                          right: MediaQuery.of(context).size.width * 0.058,
                          left: MediaQuery.of(context).size.width * 0.058,
                          bottom: 0),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width * 0.015),
                            child: const Text(
                              'Obrigatório',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xB2333333),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.058,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.025),
                                child: Column(children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: const [
                                              Text(
                                                "C. Elétrico ",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text("Atual",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 30,
                                            width: 100,
                                            child: TextFormField(
                                              controller: store.cEletricoAtual,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          bottom: 10),
                                                  hintText: "S.m/mm2",
                                                  hintStyle: TextStyle(
                                                    fontWeight: FontWeight.w100,
                                                    color: Colors.black38,
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                      const Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: Constants.kPrimaryColor,
                                        ),
                                      )),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text(
                                                "C. Elétrico ",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text("Desejado",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 30,
                                            width: 90,
                                            child: TextFormField(
                                              controller:
                                                  store.cEletricoDesejado,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          bottom: 10),
                                                  hintText: "S.m/mm2",
                                                  hintStyle: TextStyle(
                                                    fontWeight: FontWeight.w100,
                                                    color: Colors.black38,
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.025),
                                    child: const MySeparator(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.019),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  "Volume ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                Text("Atual",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                              width: 100,
                                              child: TextFormField(
                                                controller: store.volumeAtual,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                bottom: 10),
                                                        hintText: "S.m/mm2",
                                                        hintStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w100,
                                                          color: Colors.black38,
                                                        )),
                                              ),
                                            )
                                          ],
                                        ),
                                        const Center(
                                            child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 20,
                                            color: Constants.kPrimaryColor,
                                          ),
                                        )),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  "Volume ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                Text("Desejado",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                              width: 90,
                                              child: TextFormField(
                                                controller:
                                                    store.volumeDesejado,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                bottom: 10),
                                                        hintText: "S.m/mm2",
                                                        hintStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w100,
                                                          color: Colors.black38,
                                                        )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.03,
                                left:
                                    MediaQuery.of(context).size.width * 0.015),
                            child: const Text(
                              'Opcional',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xB2333333),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top:
                                    MediaQuery.of(context).size.height * 0.015),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.042,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.015),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Text("Registrar ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                            )),
                                        Text("PH",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      height: 30,
                                      width: 88,
                                      child: TextFormField(
                                        controller: store.pH,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                            alignLabelWithHint: true,
                                            contentPadding:
                                                EdgeInsets.only(bottom: 10),
                                            hintText: "8.4",
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight.w100,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black38,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01,
                                bottom: 75),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.042,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.015),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Text("Registrar ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                            )),
                                        Text("Temperatura",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      height: 30,
                                      width: 88,
                                      child: Observer(builder: (_) {
                                        return DropdownButton<int>(
                                          isExpanded: true,
                                          iconEnabledColor:
                                              Constants.kPrimaryColor,
                                          value: store.selectedItem,
                                          items: store.quantityList
                                              .map((int e) =>
                                                  DropdownMenuItem<int>(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .center,
                                                    value: e,
                                                    child: Text(
                                                      "$e ºC",
                                                      style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (int? newValue) {
                                            store.newValueItem(newValue!);
                                          },
                                        );
                                      }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(
              // top: MediaQuery.of(context).size.height * 0.025,
              right: MediaQuery.of(context).size.width * 0.012),
          width: 123,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              primary: Constants.kPrimaryColor,
            ),
            child: const Text(
              'Calcular',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              Get.to(
                () => const ResultadoajustePage(),
                transition: Transition.rightToLeft,
              );
              // Modular.to.pushReplacementNamed("/resultadoAjuste/");
            },
          ),
        ),
      ],
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  // ignore: use_key_in_widget_constructors
  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 3.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/components/topAppBarArea.dart';
import 'package:osi_solucoes/features/presenter/widgets/floating_actino_button.dart';

import '../area_cultivo/N3/detalhes_lote_page.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({Key? key}) : super(key: key);

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  LoteStore loteStore = GetIt.I<LoteStore>();

  @override
  void initState() {
    loteStore.buscarLotesFinalizados();
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
          floatingActionButton: const NewFloatingActionButton(
            nivel: 3,
          ),
          body: CustomScrollView(
            primary: false,
            physics: const BouncingScrollPhysics(),
            slivers: [
              const AppBar(),
              Observer(builder: (_) {
                if (loteStore.isLoteListLoading) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 200.0, left: 60, right: 60),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
                if (loteStore.lotesFinalizados.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 200.0, left: 60, right: 60),
                      child: Center(
                        child: Text(
                          "Não há lotes finalizados ainda!",
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
                          child: CardLoteFinalizado(
                            lote: loteStore.lotesFinalizados[index],
                          ),
                        );
                      });
                    },
                    childCount: loteStore.lotesFinalizados.length,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class AppBar extends StatefulWidget {
  const AppBar({Key? key}) : super(key: key);

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  SetorStore setorStore = GetIt.I<SetorStore>();
  LoteStore loteStore = GetIt.I<LoteStore>();

  CarouselController carouselController = CarouselController();
  CarouselController controlerPages = CarouselController();
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      child: SliverAppBar(
        pinned: true,
        backgroundColor: Colors.white,
        toolbarHeight: 124,
        floating: true,
        automaticallyImplyLeading: false,
        forceElevated: true,
        elevation: 1,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            TopAppBarArea(
              namePage1: "Lotes Finalizados",
              namePage2: '',
              subtitle: "Lista de lotes já colhidos",
            ),
            SizedBox(
              height: 30,
            ),
            // Container(
            //   height: widget.store.dropDownValue == "Data" ? 75 : 50,
            //   color: const Color(0xFFF8F8F6),
            //   padding: EdgeInsets.symmetric(
            //     horizontal: MediaQuery.of(context).size.width * 0.04,
            //   ),
            //   child: SizedBox(
            //     height: widget.store.dropDownValue == "Data" ? 70 : 50,
            //     width: double.infinity,
            //     child: Row(
            //       children: [
            //         Observer(builder: (_) {
            //           return Padding(
            //             padding: const EdgeInsets.only(right: 15.0, left: 10),
            //             child: widget.store.dropDownValue == "Nome"
            //                 ? const Icon(Icons.search)
            //                 : const Icon(Icons.calendar_month_outlined),
            //           );
            //         }),
            //         widget.store.dropDownValue == "Nome"
            //             ? Container()
            //             : const Spacer(),
            //         Observer(
            //           builder: (_) {
            //             return widget.store.dropDownValue == "Nome"
            //                 ? Expanded(
            //                     child: TextFormField(
            //                       decoration: const InputDecoration(
            //                         hintText: "Buscar...",
            //                         hintStyle: TextStyle(
            //                           fontFamily: "Roboto",
            //                         ),
            //                         border: InputBorder.none,
            //                       ),
            //                       onChanged: (newValue) {
            //                         widget.store.setSearchLoteText(newValue);
            //                       },
            //                     ),
            //                   )
            //                 : Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Row(
            //                         children: [
            //                           const Text("De:"),
            //                           InkWell(
            //                             onTap: () {
            //                               DatePicker.showDatePicker(
            //                                 context,
            //                                 currentTime: widget.store.data1,
            //                                 locale: LocaleType.pt,
            //                                 showTitleActions: true,
            //                                 minTime: DateTime(2018, 3, 5),
            //                                 maxTime: DateTime(2030, 12, 30),
            //                                 onConfirm: (date) async {
            //                                   widget.store.setData1(date);
            //                                   await widget.store
            //                                       .buscarLotes();
            //                                 },
            //                                 theme: const DatePickerTheme(
            //                                   doneStyle: TextStyle(
            //                                     color:
            //                                         Constants.kPrimaryColor,
            //                                     fontSize: 16,
            //                                   ),
            //                                 ),
            //                               );
            //                             },
            //                             child: Card(
            //                               child: Padding(
            //                                 padding:
            //                                     const EdgeInsets.symmetric(
            //                                   horizontal: 10.0,
            //                                   vertical: 5,
            //                                 ),
            //                                 child: Text(
            //                                   "${widget.store.data1.day} / ${widget.store.data1.month} / ${widget.store.data1.year}",
            //                                   style: const TextStyle(
            //                                     color:
            //                                         Constants.kPrimaryColor,
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       Row(
            //                         children: [
            //                           const Text("Até"),
            //                           InkWell(
            //                             onTap: () {
            //                               DatePicker.showDatePicker(
            //                                 context,
            //                                 currentTime: widget.store.data2,
            //                                 locale: LocaleType.pt,
            //                                 showTitleActions: true,
            //                                 minTime: DateTime(2018, 3, 5),
            //                                 maxTime: DateTime(2030, 12, 30),
            //                                 onConfirm: (date) async {
            //                                   widget.store.setData2(date);
            //                                   await widget.store
            //                                       .buscarLotes();
            //                                 },
            //                                 theme: const DatePickerTheme(
            //                                   doneStyle: TextStyle(
            //                                     color:
            //                                         Constants.kPrimaryColor,
            //                                     fontSize: 16,
            //                                   ),
            //                                 ),
            //                               );
            //                             },
            //                             child: Card(
            //                               child: Padding(
            //                                 padding:
            //                                     const EdgeInsets.symmetric(
            //                                   horizontal: 10.0,
            //                                   vertical: 5,
            //                                 ),
            //                                 child: Text(
            //                                   "${widget.store.data2.day} / ${widget.store.data2.month} / ${widget.store.data2.year}",
            //                                   style: const TextStyle(
            //                                     color:
            //                                         Constants.kPrimaryColor,
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   );
            //           },
            //         ),
            //         const Spacer(),
            //         Observer(builder: (_) {
            //           return Container(
            //             height: 30,
            //             width: 80,
            //             decoration: const BoxDecoration(
            //               color: Constants.kPrimaryColor,
            //               borderRadius: BorderRadius.all(Radius.circular(5)),
            //             ),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               children: [
            //                 DropdownButton<String>(
            //                   alignment: Alignment.center,
            //                   value: widget.store.dropDownValue,
            //                   dropdownColor: Constants.kPrimaryColor,
            //                   underline: DropdownButtonHideUnderline(
            //                       child: Container()),
            //                   iconSize: 0,
            //                   iconEnabledColor: Constants.kPrimaryColor,
            //                   elevation: 16,
            //                   borderRadius:
            //                       const BorderRadius.all(Radius.circular(5)),
            //                   style: const TextStyle(color: Colors.white),
            //                   onChanged: (String? newValue) async {
            //                     if (newValue == widget.store.dropDownValue) {
            //                       widget.store.changeOrder();
            //                     } else {
            //                       widget.store.setSearchLoteText('');
            //                     }
            //                     widget.store.setDropDown(newValue!);
            //                     await widget.store.buscarLotes();
            //                   },
            //                   items: <String>[
            //                     'Nome',
            //                     'Data'
            //                   ].map<DropdownMenuItem<String>>((String value) {
            //                     return DropdownMenuItem<String>(
            //                       value: value,
            //                       child: Text(
            //                         value,
            //                       ),
            //                     );
            //                   }).toList(),
            //                 ),
            //                 Observer(builder: (_) {
            //                   return Icon(
            //                     widget.store.order == "asc"
            //                         ? Icons.arrow_upward_rounded
            //                         : Icons.arrow_downward_rounded,
            //                     size: 14,
            //                     color: Colors.white,
            //                   );
            //                 }),
            //               ],
            //             ),
            //           );
            //         }),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CardLoteFinalizado extends StatefulWidget {
  final Lote lote;
  const CardLoteFinalizado({Key? key, required this.lote}) : super(key: key);

  @override
  State<CardLoteFinalizado> createState() => _CardLoteState();
}

class _CardLoteState extends State<CardLoteFinalizado> {
  LoteStore store = GetIt.I<LoteStore>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        store.selecionarLote(widget.lote);
        Get.to(() => const DetalhesLotePage(enableEditing: false));
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
                          Expanded(
                            child: Text(
                              "# ${widget.lote.id}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Constants.kGreyLight,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "Finalizado",
                              style: TextStyle(
                                color: Constants.kGreyText,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/models/atividade/atividade_model.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart';
import 'dart:convert' show jsonDecode, utf8;

import 'package:osi_solucoes/features/presenter/views/home/components/top_app_bar.dart';

import '../../../../core/constants/constants.dart';
import '../../viewmodels/caderno_campo_store.dart';

class DetalhesCadernoCampoPage extends StatefulWidget {
  final String title;
  const DetalhesCadernoCampoPage({Key? key, this.title = 'CadernoCampoPage'})
      : super(key: key);
  @override
  DetalhesCadernoCampoPageState createState() =>
      DetalhesCadernoCampoPageState();
}

class DetalhesCadernoCampoPageState extends State<DetalhesCadernoCampoPage> {
  CadernoCampoStore store = GetIt.I<CadernoCampoStore>();
  AuthController authController = GetIt.I<AuthController>();
  final scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      store.buscarAtividades();
    });
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
          backgroundColor: Constants.kSecondBackgroundColor,
          body: CustomScrollView(
            controller: scrollController,
            primary: false,
            physics: const BouncingScrollPhysics(),
            slivers: [
              const AppBar(),
              Observer(builder: (_) {
                if (store.isLoteListLoading) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 200.0, left: 60, right: 60),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
                if (store.loteSelecionado.lotes_atividades != null &&
                    store.loteSelecionado.lotes_atividades!.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 200.0, left: 60, right: 60),
                      child: Center(
                        child: Text(
                          "Não há atividades cadastradas neste lote",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                    ),
                    child: Timeline.tileBuilder(
                      controller: scrollController,
                      shrinkWrap: true,
                      theme: TimelineThemeData(
                        nodePosition: 0,
                        color: const Color(0xff989898),
                        // indicatorTheme: const IndicatorThemeData(
                        //   position: 0,
                        //   size: 20.0,
                        // ),
                        connectorTheme: const ConnectorThemeData(
                          thickness: 2.5,
                        ),
                      ),
                      builder: TimelineTileBuilder.connected(
                        itemCount: store.getLotesAtividadesFilter.length,
                        contentsBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              top: 20,
                              right: 20,
                            ),
                            child: SingleChildScrollView(
                              child: Observer(builder: (_) {
                                return Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16.0,
                                      16.0,
                                      0.0,
                                      16.0,
                                    ),
                                    child: ExpansionPanelList(
                                      expandedHeaderPadding:
                                          const EdgeInsets.only(bottom: 5),
                                      elevation: 0,
                                      expansionCallback: (__, bool isExpanded) {
                                        store.setExpandedCard(index);
                                      },
                                      children: [
                                        ExpansionPanel(
                                          backgroundColor:
                                              Constants.kBackgroundColor,
                                          canTapOnHeader: true,
                                          headerBuilder: (BuildContext context,
                                              bool isExpanded) {
                                            return headerCard(
                                              store
                                                  .getLotesAtividadesFilter[
                                                      index]
                                                  .atividade,
                                              store
                                                  .getLotesAtividadesFilter[
                                                      index]
                                                  .usuario,
                                            );
                                          },
                                          body: bodyCard(store
                                              .getLotesAtividadesFilter[index]
                                              .atividade),
                                          isExpanded: store.expandedCard[index],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                        indicatorBuilder: (_, index) {
                          return const DotIndicator(
                            // position: 0.04,
                            color: Constants.kPrimaryColor,
                          );
                        },
                        connectorBuilder: (_, index, ___) =>
                            const DashedLineConnector(
                          color: Constants.kPrimaryColor,
                          dash: 4,
                          gap: 4,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  bodyCard(Atividade? atividade) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Text(
        utf8.decode(
          jsonDecode(atividade?.descricao ?? '[]').cast<int>(),
        ),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Constants.kText2,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  headerCard(Atividade? atividade, Usuario? usuario) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                atividade?.nome ?? 'Não informado',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Constants.kContentColorLightTheme,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(right: 0),
                dense: true,
                leading: const Icon(
                  Icons.account_circle,
                  size: 40,
                ),
                minLeadingWidth: 0,
                minVerticalPadding: 0,
                horizontalTitleGap: 10,
                title: Text(
                  usuario?.nome ?? 'Não informado',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Constants.kText2,
                  ),
                ),
                subtitle: Text(
                  usuario?.selected_conta?.cargo?.cargo ?? 'Não informado',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Constants.kText2.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat("dd MMM y", 'pt_br')
                      .format(
                        atividade?.created_at ?? DateTime.now(),
                      )
                      .capitalize ??
                  '',
              style: const TextStyle(
                color: Constants.kGreyText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              DateFormat("HH:mm", 'pt_br')
                      .format(
                        atividade?.created_at ?? DateTime.now(),
                      )
                      .capitalize ??
                  '',
              style: const TextStyle(
                color: Constants.kGreyText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  expandedCard(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          utf8.decode(
            jsonDecode(store.loteSelecionado.lotes_atividades?[index].atividade
                        ?.descricao ??
                    '[]')
                .cast<int>(),
          ),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Constants.kGreyText,
            fontStyle: FontStyle.italic,
          ),
          overflow: store.expandedCard[index] ? null : TextOverflow.fade,
          maxLines: store.expandedCard[index] ? null : 4,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: const Icon(
              Icons.expand_more,
              color: Constants.kPrimaryColor,
              size: 36,
            ),
            onTap: () {
              store.setExpandedCard(index);
            },
          ),
        ),
      ],
    );
  }
}

// ignore: camel_case_types
class AppBar extends StatefulWidget {
  const AppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  CadernoCampoStore store = GetIt.I<CadernoCampoStore>();
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      child: SliverAppBar(
        pinned: true,
        backgroundColor: Colors.white,
        toolbarHeight: 180,
        floating: true,
        automaticallyImplyLeading: false,
        forceElevated: true,
        elevation: 1,
        // actions: [
        //   Align(
        //     alignment: const Alignment(0.6, -0.9),
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 16.0),
        //       child: Theme(
        //         data: Theme.of(context).copyWith(
        //           highlightColor: Colors.transparent,
        //           splashColor: Colors.transparent,
        //         ),
        //         child: PopupMenuButton(
        //           icon: SvgPicture.asset(
        //             "assets/icons/settings_icon.svg",
        //             color: Constants.kButtonGrey,
        //             height: 20,
        //           ),
        //           itemBuilder: (context) => [
        //             PopupMenuItem(
        //               child: Row(
        //                 children: const [
        //                   Text('Editar'),
        //                 ],
        //               ),
        //               onTap: () async {
        //                 // await setorStore.setSetorEditing(widget.setorN2);
        //                 // Get.to(
        //                 //   () => const CadastrarSetorPage(),
        //                 //   transition: Transition.rightToLeft,
        //                 // );
        //               },
        //             ),
        //             PopupMenuItem(
        //               child: Row(
        //                 children: const [
        //                   Text('Deletar'),
        //                 ],
        //               ),
        //               onTap: () {},
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopAppBar(
              namePage: '${store.loteSelecionado.nome}',
              subtitle: "Linha do tempo do lote",
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              color: const Color(0xFFF8F8F6),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
              ),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 15.0, left: 10),
                      child: Icon(Icons.search),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Buscar...",
                          hintStyle: TextStyle(
                            fontFamily: "Roboto",
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: store.setSearchAtividade,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

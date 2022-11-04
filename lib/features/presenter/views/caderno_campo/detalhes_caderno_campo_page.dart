import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:timelines/timelines.dart';

import 'package:osi_solucoes/features/presenter/views/home/components/top_app_bar.dart';
import 'package:osi_solucoes/features/presenter/widgets/floating_actino_button.dart';

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
    super.initState();
    store.buscarAtividades();
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
          floatingActionButton: const NewFloatingActionButton(
            nivel: 3,
          ),
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
                          "Não há lotes cadastrados neste setor",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Timeline.tileBuilder(
                      controller: scrollController,
                      theme: TimelineTheme.of(context).copyWith(
                        color: Constants.kPrimaryColor,
                        nodePosition: 0,
                      ),
                      shrinkWrap: true,
                      builder: TimelineTileBuilder.fromStyle(
                        connectorStyle: ConnectorStyle.dashedLine,
                        contentsBuilder: (context, index) => Card(
                          elevation: 0,
                          color: Constants.kSecondBackgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      '${store.loteSelecionado.lotes_atividades?[index].atividade!.nome}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text('Data'),
                                ],
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.only(right: 0),
                                dense: true,
                                leading: const Icon(Icons.person),
                                title: Text(
                                  '${store.loteSelecionado.lotes_atividades?[index].usuario!.nome}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  '${store.loteSelecionado.lotes_atividades?[index].usuario?.selected_conta?.cargo?.cargo}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                    'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don'),
                              )
                            ],
                          ),
                        ),
                        itemCount:
                            store.loteSelecionado.lotes_atividades?.length ?? 0,
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
                        // await setorStore.setSetorEditing(widget.setorN2);
                        // Get.to(
                        //   () => const CadastrarSetorPage(),
                        //   transition: Transition.rightToLeft,
                        // );
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
        ],
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopAppBar(
              namePage: 'Nome do lote',
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

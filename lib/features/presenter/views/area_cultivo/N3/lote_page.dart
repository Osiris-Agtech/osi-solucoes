import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N2/cadastrar_setor_page.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/detalhes_lote_page.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/top_app_bar.dart';
import 'package:osi_solucoes/features/presenter/widgets/floating_actino_button.dart';

class LotePage extends StatefulWidget {
  const LotePage({Key? key}) : super(key: key);

  @override
  State<LotePage> createState() => _LotePageState();
}

class _LotePageState extends State<LotePage> {
  LoteStore loteStore = GetIt.I<LoteStore>();

  final dropDownKey = GlobalKey<DropdownSearchState<String>>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loteStore.buscarLotes();
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
                              lote: loteStore.loteList[index],
                            ),
                          );
                        });
                      },
                      childCount: loteStore.loteList.length,
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
    Key? key,
    required this.setorN2,
    required this.store,
  }) : super(key: key);

  final LoteStore store;

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  SetorStore setorStore = GetIt.I<SetorStore>();
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      child: SliverAppBar(
        pinned: true,
        backgroundColor: Colors.white,
        toolbarHeight: 170,
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
                        await setorStore.setSetorEditing(widget.setorN2);
                        Get.to(
                          () => const CadastrarSetorPage(),
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
        ],
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopAppBar(
              namePage: widget.setorN2.nome ?? '',
              subtitle: "Lista de lotes cadastrados",
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

class CardLote extends StatefulWidget {
  final Lote lote;
  const CardLote({Key? key, required this.lote}) : super(key: key);

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
        Get.to(
          () => const DetalhesLotePage(),
          transition: Transition.rightToLeft,
        );
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

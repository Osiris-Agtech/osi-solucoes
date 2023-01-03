import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/top_app_bar.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/detalhes_solucao.dart';
import 'package:osi_solucoes/features/presenter/widgets/floating_actino_button.dart';
import 'package:osi_solucoes/features/presenter/widgets/get_bottom_sheet.dart';

class SolucaoPage extends StatefulWidget {
  const SolucaoPage({Key? key}) : super(key: key);

  @override
  State<SolucaoPage> createState() => _SolucaoPage();
}

class _SolucaoPage extends State<SolucaoPage> {
  SolucaoStore solucaoStore = GetIt.I<SolucaoStore>();

  final dropDownKey = GlobalKey<DropdownSearchState<String>>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    solucaoStore.buscarSolucoes();
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
                AppBar(store: solucaoStore),
                Observer(builder: (_) {
                  if (solucaoStore.isSolucaoListLoading) {
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
                  if (solucaoStore.solucaoList.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 200.0, left: 60, right: 60),
                        child: Center(
                          child: Text(
                            "Não há receitas cadastradas neste setor",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      children: List.generate(
                          solucaoStore.solucaoList.length,
                          (index) => CardReceita(
                                solucaoNutritiva:
                                    solucaoStore.searchSolucao[index],
                              )),
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
  const AppBar({
    Key? key,
    required this.store,
  }) : super(key: key);

  final SolucaoStore store;

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
        toolbarHeight: 180,
        floating: true,
        automaticallyImplyLeading: false,
        forceElevated: true,
        elevation: 1,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopAppBar(
              namePage: 'Minhas Soluções\nNutritivas',
              subtitle: "Lista de receitas cadastrados",
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: const Color(0xFFF8F8F6),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
              ),
              child: SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Buscar...",
                      hintStyle: TextStyle(
                        fontFamily: "Roboto",
                      ),
                      border: InputBorder.none,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class CardReceita extends StatefulWidget {
  final SolucaoNutritiva solucaoNutritiva;
  const CardReceita({Key? key, required this.solucaoNutritiva})
      : super(key: key);

  @override
  State<CardReceita> createState() => _CardReceitaState();
}

class _CardReceitaState extends State<CardReceita> {
  SolucaoStore store = GetIt.I<SolucaoStore>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        store.selecionarSolucao(widget.solucaoNutritiva);
        store.buscarDetalhesSolucao();
        getBottomSheet(const DetalhesSolucao());
      },
      child: Card(
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                "assets/icons/solucoes_nutritivas_icon.svg",
                color: Constants.kButtonGrey,
                height: 35,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.solucaoNutritiva.nome ?? '',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Constants.kGreyText),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  'Reservatórios\nativos: ${widget.solucaoNutritiva.reservatorios?.length ?? 0} '),
            ],
          ),
        ),
      ),
    );
  }
}

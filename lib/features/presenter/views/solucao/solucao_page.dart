import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/lote_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';
import 'package:osi_solucoes/features/presenter/views/area_cultivo/N3/detalhes_lote_page.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/top_app_bar.dart';
import 'package:osi_solucoes/features/presenter/widgets/floating_actino_button.dart';

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
                  if (solucaoStore.isReceitaListLoading) {
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
                  if (solucaoStore.receitaList.isEmpty) {
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
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Observer(builder: (_) {
                          return const Padding(
                            padding:
                                EdgeInsets.only(left: 16.0, right: 16, top: 10),
                            child: Text('teste'),
                          );
                        });
                      },
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
        toolbarHeight: 175,
        floating: true,
        automaticallyImplyLeading: false,
        forceElevated: true,
        elevation: 1,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopAppBar(
              namePage: 'nome page',
              subtitle: "Lista de receitas cadastrados",
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              color: const Color(0xFFF8F8F6),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
              ),
              child: SizedBox(
                  width: double.infinity,
                  child: Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Buscar...",
                        hintStyle: TextStyle(
                          fontFamily: "Roboto",
                        ),
                        border: InputBorder.none,
                      ),
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
  LoteStore store = GetIt.I<LoteStore>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        // store.selecionarLote(widget.lote);
        // Get.to(
        //   () => const DetalhesLotePage(),
        //   transition: Transition.rightToLeft,
        // );
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
                        children: const [
                          Icon(
                            Icons.eco,
                            size: 26,
                            color: Color(0xFF26C165),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Nome receita",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 8.0,
                        bottom: 2.0,
                        top: 8.0,
                      ),
                      child: Text(
                        "cultivos ativos",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Constants.kGreyText,
                        ),
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

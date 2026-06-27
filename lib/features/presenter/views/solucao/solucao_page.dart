import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/utils/responsive_breakpoints.dart';
import 'package:osi_solucoes/core/utils/spacing.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/solucao_store.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/cadastrar_solucao_page.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/components/solucao_page_header.dart';
import 'package:osi_solucoes/features/presenter/views/solucao/components/solucao_receita_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';

class SolucaoPage extends StatefulWidget {
  const SolucaoPage({super.key});

  @override
  State<SolucaoPage> createState() => _SolucaoPage();
}

class _SolucaoPage extends State<SolucaoPage> {
  SolucaoStore solucaoStore = GetIt.I<SolucaoStore>();

  final dropDownKey = GlobalKey<DropdownSearchState<String>>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    solucaoStore.setsearchSolucaoText('');
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
          floatingActionButton: FloatingActionButton(
            heroTag: 'fab_solucao',
            onPressed: () {
              Get.to(
                () => const CadastrarSolucaoPage(),
                transition: Transition.rightToLeft,
              );
            },
            backgroundColor: Constants.kPrimaryColor,
            child: const Icon(
              Icons.add,
              size: 32,
            ),
          ),
          backgroundColor: Constants.kSecondBackgroundColor,
          body: Form(
            key: formKey,
            child: CustomScrollView(
              primary: false,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SolucaoPageHeader(store: solucaoStore),
                Observer(builder: (_) {
                  if (solucaoStore.isSolucaoListLoading) {
                    return const SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: AppStateKind.loading,
                        title: 'Carregando soluções',
                        message: 'Aguarde enquanto a lista é atualizada.',
                      ),
                    );
                  }
                  if (solucaoStore.searchSolucao.isEmpty) {
                    final hasOriginalData = solucaoStore.solucaoList.isNotEmpty;
                    final hasSearch = solucaoStore.searchSolucaoText.isNotEmpty;

                    return SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: hasOriginalData && hasSearch
                            ? AppStateKind.searchEmpty
                            : AppStateKind.empty,
                        title: hasOriginalData && hasSearch
                            ? 'Nenhuma solução encontrada'
                            : 'Nenhuma solução cadastrada',
                        message: hasOriginalData && hasSearch
                            ? 'Ajuste a busca para localizar soluções cadastradas.'
                            : 'Não há soluções cadastradas na sua conta.',
                      ),
                    );
                  }

                  return SliverToBoxAdapter(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final columns =
                            ResponsiveBreakpoints.gridColumns(context);
                        final aspectRatio =
                            constraints.maxWidth > 800 ? 1.5 : 1.32;
                        return Padding(
                          padding: Spacing.all(context),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: columns,
                            crossAxisSpacing: Spacing.sm,
                            mainAxisSpacing: Spacing.sm,
                            childAspectRatio: aspectRatio,
                            children: List.generate(
                              solucaoStore.searchSolucao.length,
                              (index) => SolucaoReceitaCard(
                                solucaoNutritiva:
                                    solucaoStore.searchSolucao[index],
                              ),
                            ),
                          ),
                        );
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

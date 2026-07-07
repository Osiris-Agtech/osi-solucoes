import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/models/lotesAtividades/lotes_atividades_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:intl/intl.dart';
import 'dart:convert' show jsonDecode, utf8;

import 'package:osi_solucoes/features/presenter/widgets/common/app_panel_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_search_bar.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';

import '../../../../core/constants/constants.dart';
import '../../widgets/common/app_floating_action_button.dart';
import '../../routes/routes.dart';
import '../../viewmodels/caderno_campo_store.dart';

class DetalhesCadernoCampoPage extends StatefulWidget {
  final String title;
  const DetalhesCadernoCampoPage({super.key, this.title = 'CadernoCampoPage'});
  @override
  DetalhesCadernoCampoPageState createState() =>
      DetalhesCadernoCampoPageState();
}

class DetalhesCadernoCampoPageState extends State<DetalhesCadernoCampoPage> {
  CadernoCampoStore store = GetIt.I<CadernoCampoStore>();
  AuthController authController = GetIt.I<AuthController>();
  final scrollController = ScrollController();
  final Set<int> _expandedIndices = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.buscarAtividades();
    });
    super.initState();
  }

  @override
  void dispose() {
    store.limparLoteSelecionado();
    super.dispose();
  }

  void _toggleExpand(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
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
          floatingActionButton: AppFloatingActionButton.add(
            heroTag: 'nova_atividade_lote',
            onPressed: () {
              Get.toNamed(Routes.cadastroCadernoCampoPage);
            },
            bottom: 18,
          ),
          body: CustomScrollView(
            controller: scrollController,
            primary: false,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _DetalhesCadernoHeader(store: store),
              Observer(builder: (_) {
                if (store.isLoteListLoading) {
                  return const SliverToBoxAdapter(
                    child: AppStatePanel(
                      stateKind: AppStateKind.loading,
                      title: 'Carregando atividades...',
                    ),
                  );
                }

                final atividadesFiltradas =
                    store.getLotesAtividadesFilter;

                if (atividadesFiltradas.isEmpty) {
                  if (store.loteSelecionado.lotes_atividades == null ||
                      store.loteSelecionado.lotes_atividades!.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: AppStateKind.empty,
                        title: 'Nenhuma atividade encontrada',
                        message:
                            'Não há atividades cadastradas neste lote.',
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(
                    child: AppStatePanel(
                      stateKind: AppStateKind.empty,
                      title: 'Nenhum resultado',
                      message:
                          'Nenhuma atividade corresponde à sua busca.',
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = atividadesFiltradas[index];
                      final isExpanded =
                          _expandedIndices.contains(index);
                      return _ActivityCard(
                        item: item,
                        isExpanded: isExpanded,
                        onToggle: () => _toggleExpand(index),
                      );
                    },
                    childCount: atividadesFiltradas.length,
                  ),
                );
              }),
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final LotesAtividades item;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _ActivityCard({
    required this.item,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final atividade = item.atividade;
    final usuario = item.usuario;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: AppPanelCard(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  atividade?.nome ?? 'Não informado',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color:
                                        Constants.kContentColorLightTheme,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              if (item.atividade?.privado == true) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Constants.kGreyLight
                                        .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.auto_awesome,
                                          size: 12,
                                          color: Constants.kGreyMedium),
                                      SizedBox(width: 3),
                                      Text(
                                        'Sistema',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Constants.kGreyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(width: 8),
                              Text(
                                DateFormat("dd MMM y", 'pt_br')
                                        .format(atividade?.created_at ??
                                            DateTime.now())
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
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.account_circle,
                                size: 28,
                                color: Constants.kGreyMedium,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                usuario?.nome ?? 'Não informado',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Constants.kGreyText,
                                ),
                              ),
                              if (usuario?.selected_conta?.cargo
                                      ?.cargo !=
                                  null) ...[
                                const SizedBox(width: 4),
                                Text(
                                  '(${usuario!.selected_conta!.cargo!.cargo})',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Constants.kGreyText2,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Constants.kPrimaryColor,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded && atividade?.descricao != null) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Text(
                  utf8.decode(
                    jsonDecode(atividade!.descricao!).cast<int>(),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Constants.kText2,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetalhesCadernoHeader extends StatelessWidget {
  final CadernoCampoStore store;

  const _DetalhesCadernoHeader({required this.store});

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return AppPageHeaderSliver(
        title: store.loteSelecionado.nome ?? 'Detalhes do Lote',
        subtitle: 'Linha do tempo do lote',
        onBack: () => Get.back(),
        expandedHeight: 220,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppSearchBar(
                  hintText: 'Buscar atividade...',
                  onChanged: store.setSearchAtividade,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome,
                        size: 14, color: Constants.kGreyMedium),
                    const SizedBox(width: 6),
                    const Text(
                      'Registros do sistema',
                      style: TextStyle(
                        fontSize: 12,
                        color: Constants.kGreyMedium,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 24,
                      child: Switch.adaptive(
                        value: store.mostrarRegistrosSistema,
                        onChanged: (_) =>
                            store.toggleMostrarRegistrosSistema(),
                        activeTrackColor: Constants.kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

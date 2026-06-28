import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_dropdown.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_entity_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_search_bar.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../widgets/common/app_floating_action_button.dart';
import '../../../../core/services/navigation_resource_args.dart';
import '../../viewmodels/caderno_campo_store.dart';

class CadernoCampoPage extends StatefulWidget {
  final String title;
  const CadernoCampoPage({super.key, this.title = 'CadernoCampoPage'});
  @override
  CadernoCampoPageState createState() => CadernoCampoPageState();
}

class CadernoCampoPageState extends State<CadernoCampoPage> {
  CadernoCampoStore store = GetIt.I<CadernoCampoStore>();

  final dropDownKey = GlobalKey<DropdownSearchState<String>>();
  final formKey = GlobalKey<FormState>();
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    store.buscarLotesByConta();
    store.buscarAreasList();
    super.initState();
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    key.currentState?.dispose();
    store.limparLotes();
    super.dispose();
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
            heroTag: 'nova_nota',
            onPressed: () {
              Get.toNamed(Routes.cadastroCadernoCampoPage);
            },
            bottom: 18,
          ),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              primary: false,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _CadernoCampoHeader(store: store),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Observer(builder: (_) {
                            return AppDropdown<Area>(
                              value: store.dropButtonArea.id != null
                                  ? store.dropButtonArea
                                  : null,
                              hintText: 'Por Área',
                              items: store.areaList.map((Area area) {
                                return DropdownMenuItem<Area>(
                                  value: area,
                                  child: Text(area.nome ?? '-'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  key.currentState?.reset();
                                  store.selecionarDropButtonSetor(
                                      Setor()); // Resetar a seleção do setor
                                  store.selecionarDropButtonArea(value);
                                  store.buscarLotesByArea();
                                }
                              },
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Observer(builder: (_) {
                            return AppDropdown<Setor>(
                              value: store.dropButtonSetor.id != null
                                  ? store.dropButtonSetor
                                  : null,
                              hintText: 'No Setor',
                              items: (store.dropButtonArea.setores ?? [])
                                  .map((Setor setor) {
                                return DropdownMenuItem<Setor>(
                                  value: setor,
                                  child: Text(setor.nome!),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  store.selecionarDropButtonSetor(value);
                                  store.buscarLotesBySetor();
                                }
                              },
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Observer(builder: (_) {
                  if (store.isLoteListLoading) {
                    return SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: AppStateKind.loading,
                        title: 'Carregando lotes...',
                      ),
                    );
                  }
                  if (store.loteList.isEmpty) {
                    return SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: AppStateKind.empty,
                        title: 'Nenhum lote cadastrado',
                        message:
                            'Cadastre um lote no caderno de campo para começar.',
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 10.0),
                          child: AppEntityCard(
                            leading: const Icon(Icons.eco,
                                color: Color(0xFF26C165), size: 26),
                            title: store.getLotesFilter[index].nome ?? '',
                            subtitle:
                                '# ${store.getLotesFilter[index].id}',
                            description:
                                'Cultura: ${store.getLotesFilter[index].cultura?.nome ?? ""}',
                            metadata: [
                              if (store.getLotesFilter[index]
                                      .registro_data !=
                                  null)
                                Text(
                                  'Registro: ${DateFormat("dd/MM/y", "pt_br").format(store.getLotesFilter[index].registro_data!)}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Constants.kGreyText2),
                                ),
                              if (store.getLotesFilter[index]
                                      .colheita_data !=
                                  null)
                                Text(
                                  'Colheita: ${DateFormat("dd/MM/y", "pt_br").format(store.getLotesFilter[index].colheita_data!)}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Constants.kGreyText2),
                                ),
                            ],
                            onTap: () {
                              store.setLoteSelecionado(
                                  store.getLotesFilter[index]);
                              Get.toNamed(
                                Routes.detalhesCadernoCampoPage,
                                arguments: NavigationResourceArgs(
                                  resourceId: store
                                      .getLotesFilter[index].id
                                      ?.toString(),
                                  resourceType: 'caderno_campo',
                                  resourceName: store
                                      .getLotesFilter[index].nome,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: store.getLotesFilter.length,
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
class _CadernoCampoHeader extends StatelessWidget {
  final CadernoCampoStore store;

  const _CadernoCampoHeader({required this.store});

  @override
  Widget build(BuildContext context) {
    return AppPageHeaderSliver(
      title: 'Caderno de Campo',
      subtitle: 'Lista de cadernos de campo',
      onBack: () => Get.back(),
      expandedHeight: 180,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppSearchBar(
            hintText: 'Buscar lote...',
            onChanged: store.setSearchLote,
          ),
        ),
      ),
    );
  }
}



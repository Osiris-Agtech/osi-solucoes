import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_search_bar.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
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
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: FloatingActionButton(
              heroTag: 'NovaNota',
              onPressed: () {
                Get.toNamed(Routes.cadastroCadernoCampoPage);
              },
              backgroundColor: Constants.kPrimaryColor,
              child: const Icon(Icons.add),
            ),
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
                            return DropdownButtonFormField<Area>(
                              initialValue: store.dropButtonArea.id != null
                                  ? store.dropButtonArea
                                  : null,
                              hint: const Text(
                                'Por Área',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              isExpanded: true,
                              iconEnabledColor: Constants.kPrimaryColor,
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
                            return DropdownButtonFormField<Setor>(
                              key: key,
                              initialValue: store.dropButtonSetor.id != null
                                  ? store.dropButtonSetor
                                  : null,
                              hint: const Text(
                                'No Setor',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              isExpanded: true,
                              iconEnabledColor: Constants.kPrimaryColor,
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
                        return Observer(builder: (_) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, top: 10),
                            child: CardLote(
                              lote: store.getLotesFilter[index],
                            ),
                          );
                        });
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

class CardLote extends StatefulWidget {
  final Lote lote;
  const CardLote({super.key, required this.lote});

  @override
  State<CardLote> createState() => _CardLoteState();
}

class _CardLoteState extends State<CardLote> {
  CadernoCampoStore store = GetIt.I<CadernoCampoStore>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        store.setLoteSelecionado(widget.lote);
        Get.toNamed(
          Routes.detalhesCadernoCampoPage,
          arguments: NavigationResourceArgs(
            resourceId: widget.lote.id?.toString(),
            resourceType: 'caderno_campo',
            resourceName: widget.lote.nome,
          ),
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
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.calendar_month_rounded,
                    color: Constants.kText2,
                    size: 16,
                  ),
                  const Text(
                    'Registro',
                    style: TextStyle(
                      color: Constants.kGreyText,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.lote.registro_data != null
                        ? DateFormat("dd/MM/y", 'pt_br')
                                .format(
                                  widget.lote.registro_data!,
                                )
                                .capitalize ??
                            '--/--/--'
                        : '--/--/--',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Colheita',
                    style: TextStyle(
                      color: Constants.kGreyText,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.lote.colheita_data != null
                        ? DateFormat("dd/MM/y", 'pt_br')
                                .format(
                                  widget.lote.colheita_data!,
                                )
                                .capitalize ??
                            '--/--/--'
                        : '--/--/--',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
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

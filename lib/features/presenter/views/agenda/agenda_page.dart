import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/agenda_store.dart';
import 'package:osi_solucoes/features/presenter/views/agenda/components/agenda_item.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../models/lote/lote_model.dart';
import '../../models/usuario/usuario_model.dart';
import '../../states/agenda_page_enum.dart';
import '../../widgets/get_bottom_sheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';
import 'components/detalhes_bottomSheet.dart';

class AgendaPage extends StatefulWidget {
  final String title;
  final int? loteId;
  const AgendaPage({super.key, this.loteId, this.title = 'AgendaPage'});
  @override
  AgendaPageState createState() => AgendaPageState();
}

class AgendaPageState extends State<AgendaPage> {
  final ScrollController _scrollController = ScrollController();
  final AgendaStore store = GetIt.I<AgendaStore>();

  @override
  void initState() {
    super.initState();
    store.setInitialStateForFilter();
    store.onDaySelected(null);
    store.setPageState(AgendaState.loading);
    store.buscarUsuariosConta().then(
          (value) => store.buscarLotesConta().then(
                (value) => store.buscarAtividades().then((value) {
                  store.setPageState(AgendaState.loaded);
                  if (widget.loteId != null) {
                    store.setFiltroLote(null, loteId: widget.loteId);
                  }
                }),
              ),
        );
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
          floatingActionButton: FloatingActionButton(
            heroTag: 'fab_agenda',
            onPressed: () {
              store.limparDadosDaAtividade();
              store.setShowEditPage(true);
              getBottomSheet(const DetalhesBottomSheet());
            },
            child: const Icon(Icons.add),
          ),
          body: PrimaryScrollController(
            controller: _scrollController,
            child: Scrollbar(
              radius: const Radius.circular(12),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  sliverAppBar(context),
                  agenda(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        bottom: 16.0,
                        left: 24.0,
                        right: 24.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Atividades',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: Observer(builder: (_) {
                                  return DropdownButtonFormField<AgendaFilter>(
                                    initialValue: store.filter,
                                    hint: const Text(
                                      'Filtro',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    icon: const Icon(Icons.filter_list_rounded),
                                    iconEnabledColor: Constants.kPrimaryColor,
                                    items: AgendaFilter.values
                                        .map((AgendaFilter filtro) {
                                      return DropdownMenuItem<AgendaFilter>(
                                        value: filtro,
                                        child: Text(
                                            (filtro == AgendaFilter.todos
                                                    ? 'Exibir '
                                                    : '') +
                                                filtro.name),
                                      );
                                    }).toList(),
                                    onChanged: store.setFiltro,
                                  );
                                }),
                              ),
                            ],
                          ),
                          Observer(builder: (_) {
                            if (store.filter == AgendaFilter.todos) {
                              return const SizedBox.shrink();
                            }

                            if (store.filter == AgendaFilter.lote) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: DropdownButtonFormField<Lote>(
                                  initialValue: store.filtroLote,
                                  hint: const Text(
                                    'Selecionar Lote',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                  isExpanded: true,
                                  iconEnabledColor: Constants.kPrimaryColor,
                                  items: store.lotesConta.map((Lote lote) {
                                    return DropdownMenuItem<Lote>(
                                      value: lote,
                                      child: Text(
                                          '${lote.nome} - ${lote.setor?.nome ?? ''}'),
                                    );
                                  }).toList(),
                                  onChanged: store.setFiltroLote,
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: DropdownButtonFormField<Usuario>(
                                initialValue: store.filtroResponsavel,
                                hint: const Text(
                                  'Selecionar Responsável',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                                isExpanded: true,
                                iconEnabledColor: Constants.kPrimaryColor,
                                items:
                                    store.usuariosConta.map((Usuario usuario) {
                                  return DropdownMenuItem<Usuario>(
                                    value: usuario,
                                    child: Text(
                                        '${usuario.nome} (${usuario.selected_conta?.cargo?.cargo})'),
                                  );
                                }).toList(),
                                onChanged: store.setFiltroResponsavel,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  Observer(builder: (_) {
                    if (store.state == AgendaState.loading) {
                      return _loadingList();
                    }

                    if (store.filter == AgendaFilter.lote) {
                      if (store.filtrarPorLote.isEmpty) {
                        return _emptyList(
                          'Nenhuma atividade encontrada',
                          'Não há atividades para este lote.',
                        );
                      }
                      return _showList();
                    }

                    if (store.atividadeList.isEmpty) {
                      return _emptyList(
                        'Nenhuma atividade encontrada',
                        'Não há atividades cadastradas em sua conta.',
                      );
                    }
                    return _showList();
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppPageHeaderSliver sliverAppBar(BuildContext context) {
    return AppPageHeaderSliver(
      title: 'Agenda',
      subtitle: 'Acompanhamento de ações da produção',
      onBack: () => Get.back(),
      expandedHeight: 120,
    );
  }

  SliverToBoxAdapter agenda() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Observer(builder: (context) {
          return TableCalendar(
            selectedDayPredicate: (day) => isSameDay(store.selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              store.onDaySelected(selectedDay);
              store.setInitialStateForFilter();
            },
            locale: 'pt_BR',
            firstDay: DateTime.now().subtract(const Duration(days: 10 * 365)),
            lastDay: DateTime.now().add(const Duration(days: 10 * 365)),
            focusedDay: store.selectedDay ??
                DateTime.now(), // Use o focusedDay do store
            daysOfWeekHeight: 24,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextFormatter: (date, locale) {
                String s = DateFormat.yMMMM(locale).format(date);
                return s[0].toUpperCase() + s.substring(1);
              },
              titleTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Constants.kPrimaryColor,
              ),
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: Constants.kPrimaryColor,
              ),
              rightChevronIcon: const Icon(Icons.chevron_right,
                  color: Constants.kPrimaryColor),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextFormatter: (date, locale) =>
                  DateFormat.E(locale).format(date)[0].toUpperCase(),
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Constants.kGreyLight,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Constants.kPrimaryColor,
                shape: BoxShape.circle,
              ),
            ),
            eventLoader: store.getEventsForDay,
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, date, event) {
                return Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Constants.kPrimaryColor,
                  ),
                  width: 7.0,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  SliverToBoxAdapter _showList() {
    return SliverToBoxAdapter(
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        decoration: const BoxDecoration(
          color: Constants.kCardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: store.listaParaSerUsada.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100.0),
                  child: AppStatePanel(
                    stateKind: AppStateKind.empty,
                    title: 'Nenhuma atividade para esta data',
                    message:
                        'Não há atividades cadastradas para o dia selecionado.',
                    isCompact: true,
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: store.listaParaSerUsada.length,
                itemBuilder: (context, index) {
                  return agendaItem(
                    isFirst: index == 0,
                    isLast: index == store.listaParaSerUsada.length - 1,
                    agenda: store.listaParaSerUsada[index],
                    store: store,
                  );
                },
              ),
      ),
    );
  }

  SliverToBoxAdapter _emptyList(String title, String message) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: Constants.kCardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: AppStatePanel(
          stateKind: AppStateKind.empty,
          title: title,
          message: message,
        ),
      ),
    );
  }

  SliverToBoxAdapter _loadingList() {
    return const SliverToBoxAdapter(
      child: AppStatePanel(
        stateKind: AppStateKind.loading,
        title: 'Carregando agenda...',
      ),
    );
  }
}

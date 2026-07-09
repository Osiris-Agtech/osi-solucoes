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
import '../../widgets/common/app_floating_action_button.dart';
import '../../models/lote/lote_model.dart';
import '../../models/usuario/usuario_model.dart';
import '../../states/agenda_page_enum.dart';
import '../../widgets/get_bottom_sheet.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_dropdown.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';
import 'components/editar_atividade_sheet.dart';

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
          floatingActionButton: AppFloatingActionButton.add(
            heroTag: 'nova_atividade',
            onPressed: () {
              store.limparDadosDaAtividade();
              getBottomSheet(const EditarAtividadeSheet());
            },
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Atividades',
                                    style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Observer(builder: (_) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: AgendaFilter.values.map((AgendaFilter filtro) {
                                    final isSelected = store.filter == filtro;
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: FilterChip(
                                        label: Text(
                                          filtro == AgendaFilter.todos ? 'Todos' :
                                          filtro == AgendaFilter.lote ? 'Por Lote' : 'Por Responsável',
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Constants.kText2,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        selected: isSelected,
                                        onSelected: (_) => store.setFiltro(filtro),
                                        selectedColor: Constants.kPrimaryColor,
                                        backgroundColor: Constants.kCardColor,
                                        checkmarkColor: Colors.white,
                                        side: BorderSide.none,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }),
                            Observer(builder: (_) {
                              if (store.filter == AgendaFilter.todos) return const SizedBox.shrink();

                              if (store.filter == AgendaFilter.lote) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: AppDropdown<Lote>(
                                    value: store.filtroLote,
                                    hintText: 'Selecionar Lote',
                                    items: store.lotesConta.map((Lote lote) {
                                      return DropdownMenuItem<Lote>(
                                        value: lote,
                                        child: Text('${lote.nome} - ${lote.setor?.nome ?? ''}'),
                                      );
                                    }).toList(),
                                    onChanged: store.setFiltroLote,
                                  ),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: AppDropdown<Usuario>(
                                  value: store.filtroResponsavel,
                                  hintText: 'Selecionar Responsável',
                                  items: store.usuariosConta.map((Usuario usuario) {
                                    return DropdownMenuItem<Usuario>(
                                      value: usuario,
                                      child: Text('${usuario.nome} (${usuario.selected_conta?.cargo?.cargo})'),
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
                      return _skeletonList();
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
        child: Column(
          children: [
            Observer(builder: (context) {
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  store.onDaySelected(DateTime.now());
                },
                icon: const Icon(Icons.today, size: 18),
                label: const Text('Hoje'),
                style: TextButton.styleFrom(
                  foregroundColor: Constants.kPrimaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ],
        ),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppStatePanel(
                        stateKind: AppStateKind.empty,
                        title: 'Nenhuma atividade para esta data',
                        message:
                            'Não há atividades cadastradas para o dia selecionado.',
                        isCompact: true,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          store.limparDadosDaAtividade();
                          getBottomSheet(const EditarAtividadeSheet());
                        },
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Criar atividade'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.kPrimaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppStatePanel(
                stateKind: AppStateKind.empty,
                title: title,
                message: message,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  store.limparDadosDaAtividade();
                  getBottomSheet(const EditarAtividadeSheet());
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Criar atividade'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.kPrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _skeletonList() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: List.generate(4, (index) => _SkeletonItem()),
        ),
      ),
    );
  }
}

class _SkeletonItem extends StatefulWidget {
  @override
  State<_SkeletonItem> createState() => _SkeletonItemState();
}

class _SkeletonItemState extends State<_SkeletonItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 180,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Constants.kGreyLight.withValues(alpha: _animation.value),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 17.5,
                            backgroundColor: Constants.kGreyLight.withValues(alpha: _animation.value),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 120,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Constants.kGreyLight.withValues(alpha: _animation.value),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 80,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Constants.kGreyLight.withValues(alpha: _animation.value),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Constants.kGreyLight.withValues(alpha: _animation.value),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

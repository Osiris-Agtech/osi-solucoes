import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/agenda_store.dart';
import 'package:osi_solucoes/features/presenter/views/agenda/components/agenda_item.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../states/agenda_page_states_enum.dart';
import '../home/components/top_app_bar.dart';

class AgendaPage extends StatefulWidget {
  final String title;
  const AgendaPage({Key? key, this.title = 'AgendaPage'}) : super(key: key);
  @override
  AgendaPageState createState() => AgendaPageState();
}

class AgendaPageState extends State<AgendaPage> {
  final ScrollController _scrollController = ScrollController();
  final AgendaStore store = GetIt.I<AgendaStore>();

  @override
  void initState() {
    super.initState();
    store.onDaySelected(null);
    store.buscarAtividades();
    store.buscarUsuariosConta();
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
          backgroundColor: Constants.kBackgroundColor,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Atividades',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Tooltip(
                            message:
                                "Atividades já realizadas\npossuem o ícone de check",
                            padding: EdgeInsets.all(8),
                            triggerMode: TooltipTriggerMode.tap,
                            child: Icon(
                              Icons.info_outline,
                              color: Constants.kPrimaryColor,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Observer(builder: (_) {
                    if (store.state == AgendaState.loading) {
                      return _loadingList();
                    }
                    if (store.atividadeList.isEmpty) {
                      return _emptyList();
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

  SliverAppBar sliverAppBar(BuildContext context) {
    return const SliverAppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 100, //MediaQuery.of(context).size.height * 0.17,
      // collapsedHeight: 200, //MediaQuery.of(context).size.height * 0.17,
      floating: true,
      automaticallyImplyLeading: false,
      forceElevated: true,
      elevation: 0,
      flexibleSpace: TopAppBar(
        path: "/Home/",
        namePage: "Agenda",
        subtitle: "Acompanhamento de ações da produção",
        // onPressed: () {
        //   Get.offNamed(Routes.homePage, (route) => false);
        // },
      ),
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

  _showList() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: Constants.kCardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: store.selectedDay != null && store.filteredAtividades.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 100.0),
                  child: Text(
                    'Não há atividades\ncadastradas para esta data',
                    style: TextStyle(
                      fontSize: 14,
                      color: Constants.kText2,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: store.selectedDay != null
                    ? store.filteredAtividades.length
                    : store.atividadeList.length,
                itemBuilder: (context, index) {
                  return agendaItem(
                    isFirst: index == 0,
                    isLast: index ==
                        (store.selectedDay != null
                                    ? store.filteredAtividades
                                    : store.atividadeList)
                                .length -
                            1,
                    agenda: store.selectedDay != null
                        ? store.filteredAtividades[index]
                        : store.atividadeList[index],
                    store: store,
                  );
                },
              ),
      ),
    );
  }

  _emptyList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 120.0),
              child: Text(
                'Não há protocolos\ncadastrados em sua conta',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff6F6464),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _loadingList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 120.0),
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

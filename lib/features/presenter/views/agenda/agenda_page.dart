import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/agenda_store.dart';
import 'package:osi_solucoes/features/presenter/views/agenda/components/agenda_item.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
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
    store.buscarAtividades();
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
          body: PrimaryScrollController(
            controller: _scrollController,
            child: Scrollbar(
              radius: const Radius.circular(12),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  sliverAppBar(context),
                  agenda(),
                  Observer(builder: (_) {
                    if (store.isAcoesListLoading) {
                      return loadingList();
                    }
                    if (store.atividadeList.isEmpty) {
                      return emptyList();
                    }
                    return showList();
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
    return SliverAppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 120, //MediaQuery.of(context).size.height * 0.17,
      // collapsedHeight: 200, //MediaQuery.of(context).size.height * 0.17,
      floating: true,
      automaticallyImplyLeading: false,
      forceElevated: true,
      elevation: 1,
      flexibleSpace: TopAppBar(
        path: "/Home/",
        namePage: "Agenda",
        subtitle: "Acompanhamento de ações da produção",
        onPressed: () {
          Get.offNamedUntil(Routes.homePage, (route) => false);
        },
      ),
    );
  }

  SliverToBoxAdapter agenda() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Observer(
          // Use o Observer aqui
          builder: (_) => TableCalendar(
            selectedDayPredicate: (day) => isSameDay(store.selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              store.onDaySelected(selectedDay, focusedDay);
            },
            locale: 'pt_BR',
            firstDay: DateTime.now().subtract(const Duration(days: 10 * 365)),
            lastDay: DateTime.now().add(const Duration(days: 10 * 365)),
            focusedDay: store.focusedDay, // Use o focusedDay do store
            daysOfWeekHeight: 24,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextFormatter: (date, locale) {
                String s = DateFormat.yMMMM(locale).format(date);
                return s[0].toUpperCase() + s.substring(1);
              },
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: Constants.kPrimaryColor,
              ),
              rightChevronIcon: const Icon(
                Icons.chevron_right,
                color: Constants.kGreyText,
              ),
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
                color: Constants.kGreyText,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, date, event) {
                return Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Constants.kGreyText,
                  ),
                  width: 7.0,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  SliverList showList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return agendaItem(index: index, store: store);
        },
        childCount: store.atividadeList.length,
      ),
    );
  }

  SliverList emptyList() {
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

  SliverList loadingList() {
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

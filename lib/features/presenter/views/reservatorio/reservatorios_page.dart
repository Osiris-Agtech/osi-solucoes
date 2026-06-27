import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/views/reservatorio/cadastrar_reservatorio/components/reservatorioItem.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_search_bar.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';

import '../../../../core/constants/constants.dart';
import '../../viewmodels/reservatorios_store.dart';

class ReservatoriosPage extends StatefulWidget {
  final String title;
  const ReservatoriosPage({super.key, this.title = 'ReservatoriosPage'});
  @override
  ReservatoriosPageState createState() => ReservatoriosPageState();
}

class ReservatoriosPageState extends State<ReservatoriosPage> {
  ReservatoriosStore store = GetIt.I<ReservatoriosStore>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    store.setSearchReservatorioText('');
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
          backgroundColor: Constants.kSecondBackgroundColor,
          body: PrimaryScrollController(
            controller: _scrollController,
            child: Scrollbar(
              radius: const Radius.circular(12),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  sliverAppBar(context),
                  Observer(builder: (_) {
                    if (store.isReservatorioListLoading) {
                      return loadingList();
                    }
                    if (store.reservatorioList.isEmpty) {
                      return emptyList();
                    }
                    if (store.searchReservatorio.isEmpty) {
                      return emptySearchList();
                    }
                    return showList();
                  }),
                ],
              ),
            ),
          ),
          floatingActionButton: floatingButton(),
        ),
      ),
    );
  }

  FloatingActionButton floatingButton() {
    return FloatingActionButton(
      heroTag: "NovoReservatório",
      onPressed: () {
        store.setIsEditing(false);
        Get.toNamed(Routes.cadastrarReservatoriosPage);
      },
      backgroundColor: Constants.kPrimaryColor,
      child: const Icon(
        Icons.add,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  SliverList showList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return reservatorioItem(index, store);
        },
        childCount: store.searchReservatorio.length,
      ),
    );
  }

  SliverList emptyList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const AppStatePanel(
            stateKind: AppStateKind.empty,
            title: 'Não há reservatórios cadastrados',
            message: 'Cadastre um reservatório para acompanhar seus cultivos.',
          ),
        ],
      ),
    );
  }

  SliverList emptySearchList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const AppStatePanel(
            stateKind: AppStateKind.searchEmpty,
            title: 'Nenhum reservatório encontrado',
            message: 'Revise o termo buscado ou limpe a busca para ver todos.',
          ),
        ],
      ),
    );
  }

  SliverList loadingList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const AppStatePanel(
            stateKind: AppStateKind.loading,
            title: 'Carregando reservatórios',
            message: 'Aguarde enquanto buscamos os dados cadastrados.',
          ),
        ],
      ),
    );
  }

  AppPageHeaderSliver sliverAppBar(BuildContext context) {
    return AppPageHeaderSliver(
      title: 'Meus Reservatórios',
      subtitle: 'Lista de reservatórios cadastrados',
      onBack: () {
        Get.offNamedUntil(Routes.homePage, (route) => false);
      },
      floating: true,
      expandedHeight: 180,
      bottom: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          60, //MediaQuery.of(context).size.height * 0.06,
        ),
        child: filterWidget(context),
      ),
    );
  }

  Container filterWidget(BuildContext context) {
    return Container(
      height: 60,
      color: const Color(0xFFF8F8F6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: AppSearchBar(
        hintText: 'Buscar reservatório...',
        onChanged: store.setSearchReservatorioText,
      ),
    );
  }
}

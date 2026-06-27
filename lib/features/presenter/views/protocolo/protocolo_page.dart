import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';

import '../../../../core/constants/constants.dart';
import '../../viewmodels/protocolo_store.dart';
import '../../widgets/common/app_page_header_sliver.dart';
import '../../widgets/common/app_search_bar.dart';
import '../../widgets/common/app_state_panel.dart';
import 'components/detalhes_page/protocoloItem.dart';

class ProtocoloPage extends StatefulWidget {
  final String title;
  const ProtocoloPage({super.key, this.title = 'ProtocoloPage'});
  @override
  ProtocoloPageState createState() => ProtocoloPageState();
}

class ProtocoloPageState extends State<ProtocoloPage> {
  ProtocoloStore store = GetIt.I<ProtocoloStore>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // store.setSearchReservatorioText('');
    store.buscarProtocolos();
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
                    if (store.isProtocoloListLoading) {
                      return loadingList();
                    }
                    if (store.protocoloList.isEmpty) {
                      return emptyList();
                    }
                    if (store.getProtocoloGroup.isEmpty) {
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
      heroTag: "NovoProtocolo",
      onPressed: () {
        Get.toNamed(Routes.cadastrarProtocoloPage);
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
          return protocoloItem(index: index);
        },
        childCount: store.getProtocoloGroup.length,
      ),
    );
  }

  SliverToBoxAdapter emptyList() {
    return const SliverToBoxAdapter(
      child: AppStatePanel(
        stateKind: AppStateKind.empty,
        title: 'Nenhum protocolo cadastrado',
        message: 'Não há protocolos cadastrados em sua conta.',
      ),
    );
  }

  SliverToBoxAdapter emptySearchList() {
    return const SliverToBoxAdapter(
      child: AppStatePanel(
        stateKind: AppStateKind.searchEmpty,
        title: 'Nenhum protocolo encontrado',
        message: 'Ajuste a busca para localizar protocolos cadastrados.',
      ),
    );
  }

  SliverToBoxAdapter loadingList() {
    return const SliverToBoxAdapter(
      child: AppStatePanel(
        stateKind: AppStateKind.loading,
        title: 'Carregando protocolos',
        message: 'Aguarde enquanto a lista é atualizada.',
      ),
    );
  }

  AppPageHeaderSliver sliverAppBar(BuildContext context) {
    return AppPageHeaderSliver(
      title: 'Meus Protocolos',
      subtitle: 'Lista de protocolos cadastrados',
      expandedHeight: 180,
      floating: true,
      onBack: () => Get.back(),
      bottom: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          60,
        ),
        child: filterWidget(context),
      ),
    );
  }

  Container filterWidget(BuildContext context) {
    return Container(
      height: 60,
      color: const Color(0xFFF8F8F6),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: 7,
      ),
      child: AppSearchBar(
        hintText: 'Buscar protocolo...',
        onChanged: store.setSeachProtocoloPage,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Constants.kPrimaryColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'nome',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}

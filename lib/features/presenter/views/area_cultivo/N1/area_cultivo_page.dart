import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/floating_actino_button.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_entity_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_icon_tile.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_search_bar.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';

class AreaCultivoPage extends StatefulWidget {
  const AreaCultivoPage({super.key});
  @override
  AreaCultivoPageState createState() => AreaCultivoPageState();
}

class AreaCultivoPageState extends State<AreaCultivoPage> {
  AreaCultivoStore store = GetIt.I<AreaCultivoStore>();

  final dropDownKey = GlobalKey<DropdownSearchState<String>>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    store.setSearchAreaText('');
    store.buscarArea();
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
          // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          backgroundColor: Constants.kSecondBackgroundColor,
          floatingActionButton: const NewFloatingActionButton(
            nivel: 1,
          ),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              primary: false,
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppPageHeaderSliver(
                  title: 'Áreas de Cultivo',
                  subtitle: 'Lista de áreas cadastradas',
                  onBack: () => Get.back(),
                  expandedHeight: 180,
                  bottom: PreferredSize(
                    preferredSize: const Size(double.infinity, 60),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: AppSearchBar(
                        hintText: 'Buscar área...',
                        onChanged: store.setSearchAreaText,
                      ),
                    ),
                  ),
                ),
                _AreaCultivoHeader(store: store),
                Observer(builder: (_) {
                  if (store.isAreaLoading) {
                    return const SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: AppStateKind.loading,
                        title: 'Carregando áreas',
                        message: 'Aguarde enquanto buscamos as áreas cadastradas.',
                      ),
                    );
                  }
                  if (store.areaList.isEmpty) {
                    return SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: AppStateKind.empty,
                        title: 'Nenhuma área cadastrada',
                        message: 'Cadastre uma área de cultivo para começar.',
                      ),
                    );
                  }
                  return showList();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Observer showList() {
    return Observer(builder: (_) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 10),
              child: CardArea(
                area: store.searchArea[index],
              ),
            );
          },
          childCount: store.searchArea.length,
        ),
      );
    });
  }
}

class CardArea extends StatelessWidget {
  const CardArea({super.key, required this.area});
  final Area area;

  @override
  Widget build(BuildContext context) {
    final setorStore = GetIt.I<SetorStore>();

    return AppEntityCard(
      leading: AppIconTile(
        asset: 'assets/icons/cultivo_icon.svg',
        color: Constants.kPrimaryColor,
        size: 44,
        iconSize: 24,
      ),
      title: area.nome ?? '',
      subtitle: '# ${area.id}',
      description: area.localizacao?.endereco != null
          ? '${area.localizacao?.endereco}, ${area.localizacao?.bairro}, ${area.localizacao?.cidade} - ${area.localizacao?.estado}'
          : 'Endereço não informado',
      metadata: [
        Text(
          '${area.setores?.length ?? 0} Setores',
          style: const TextStyle(
            fontSize: 14,
            color: Constants.kPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
      onTap: () {
        setorStore.setAreaSelecionada(area);
        Get.toNamed(Routes.setorPage);
      },
    );
  }
}

class _AreaCultivoHeader extends StatelessWidget {
  final AreaCultivoStore store;

  const _AreaCultivoHeader({required this.store});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: store.dropDownValue,
                  isExpanded: true,
                  icon: const Icon(Icons.expand_more, color: Constants.kPrimaryColor),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Constants.kText2,
                  ),
                  onChanged: (String? newValue) async {
                    if (newValue == store.dropDownValue) {
                      store.changeOrder();
                    } else {
                      store.setSearchAreaText('');
                    }
                    store.setDropDown(newValue!);
                    await store.buscarArea();
                  },
                  items: ['Nome', 'Data'].map((v) {
                    return DropdownMenuItem(value: v, child: Text(v));
                  }).toList(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                store.order == 'asc'
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 20,
                color: Constants.kPrimaryColor,
              ),
              onPressed: () async {
                store.changeOrder();
                await store.buscarArea();
              },
            ),
          ],
        ),
      ),
    );
  }
}

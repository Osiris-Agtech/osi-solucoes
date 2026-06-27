import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/area_cultivo_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/features/presenter/widgets/floating_actino_button.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
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
                  subtitle: 'Lista de áreas cadastrados',
                  onBack: () => Get.back(),
                  expandedHeight: 180,
                ),
                _AreaCultivoHeader(store: store),
                Observer(builder: (_) {
                  if (store.isAreaLoading) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 200, left: 60, right: 60),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
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

class CardArea extends StatefulWidget {
  const CardArea({super.key, required this.area});
  final Area area;

  @override
  State<CardArea> createState() => _CardAreaState();
}

class _CardAreaState extends State<CardArea> {
  SetorStore setorStore = GetIt.I<SetorStore>();
  AreaCultivoStore store = GetIt.I<AreaCultivoStore>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setorStore.setAreaSelecionada(widget.area);
        Get.toNamed(Routes.setorPage);
      },
      child: SizedBox(
        height: 185,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.8,
                alignment: Alignment.bottomRight,
                image: AssetImage("assets/images/greenhouse_background.png"),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  "assets/icons/cultivo_icon.svg",
                                  height: 25,
                                ),
                                onPressed: null,
                              ),
                            ),
                            Text(
                              "# ${widget.area.id}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Constants.kGreyText,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, bottom: 10),
                        child: Text(
                          widget.area.nome!,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Constants.kText2.withValues(alpha: .9),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                top: 3.0,
                                right: 8.0,
                              ),
                              child: Opacity(
                                opacity: 0.8,
                                child: SvgPicture.asset(
                                  "assets/icons/location_icon.svg",
                                  height: 18,
                                  colorFilter: ColorFilter.mode(
                                    Constants.kGreyText,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 190,
                              child: Text(
                                widget.area.localizacao?.endereco != null
                                    ? '${widget.area.localizacao?.endereco}, ${widget.area.localizacao?.bairro}, ${widget.area.localizacao?.cidade} - ${widget.area.localizacao?.estado}'
                                    : 'Endereço não informado',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Constants.kGreyText,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 55),
                        child: Text(
                          "${widget.area.setores?.length ?? 0} Setores",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Constants.kGreyText,
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Constants.kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
              child: DropdownButton<String>(
                value: store.dropDownValue,
                isExpanded: true,
                underline: const SizedBox(),
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

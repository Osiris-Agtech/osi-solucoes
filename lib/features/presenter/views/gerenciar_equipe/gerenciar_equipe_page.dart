import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_badge.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_entity_card.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_page_header_sliver.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_search_bar.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_state_panel.dart';

import '../../../../core/constants/constants.dart';
import '../../viewmodels/gerenciar_equipe_store.dart';

class GerenciarEquipePage extends StatefulWidget {
  const GerenciarEquipePage({super.key});

  @override
  State<GerenciarEquipePage> createState() => _GerenciarEquipePage();
}

class _GerenciarEquipePage extends State<GerenciarEquipePage> {
  GerenciarEquipeStore gerenciarEquipeStore = GetIt.I<GerenciarEquipeStore>();

  final dropDownKey = GlobalKey<DropdownSearchState<String>>();
  final formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    gerenciarEquipeStore.buscarUsuarios();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
          backgroundColor: Constants.kCardColor,
          floatingActionButton: FloatingActionButton(
            heroTag: 'fab_gerenciar_equipe',
            onPressed: () {
              Get.toNamed(Routes.cadastrarUsuarioPage);
            },
            backgroundColor: Constants.kPrimaryColor,
            child: const Icon(Icons.add, size: 32),
          ),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              controller: ScrollController(),
              primary: false,
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppPageHeaderSliver(
                  title: 'Gerenciar Equipe',
                  subtitle: 'Lista de colaboradores',
                  expandedHeight: 180,
                  onBack: () => Get.back(),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(56),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppSearchBar(
                        controller: _searchController,
                        onChanged: (value) =>
                            gerenciarEquipeStore.setsearchUserText(value),
                        onClear: () {
                          _searchController.clear();
                          gerenciarEquipeStore.setsearchUserText('');
                        },
                        hintText: 'Pesquisar',
                      ),
                    ),
                  ),
                ),
                Observer(builder: (_) {
                  if (gerenciarEquipeStore.isUserListLoading) {
                    return const SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: AppStateKind.loading,
                        title: 'Carregando usuários...',
                      ),
                    );
                  }
                  if (gerenciarEquipeStore.userList.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: AppStateKind.empty,
                        title: 'Nenhum usuário cadastrado',
                        message: 'Cadastre um usuário para começar',
                      ),
                    );
                  }
                  if (gerenciarEquipeStore.searchUserText.isNotEmpty &&
                      gerenciarEquipeStore.searchUser.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: AppStatePanel(
                        stateKind: AppStateKind.searchEmpty,
                        title: 'Nenhum resultado encontrado',
                        message: 'Tente alterar o termo da busca',
                      ),
                    );
                  }
                  if (gerenciarEquipeStore.searchUserText.isEmpty) {
                    return SliverToBoxAdapter(
                      child: ListView.builder(
                        itemCount: gerenciarEquipeStore.userMap.length,
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final section = gerenciarEquipeStore.userMap[index];
                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: const Divider(
                                        color: Constants.kGreyText2,
                                        height: 2,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    section.key,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 10,
                                      color: Constants.kText2,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: const Divider(
                                        color: Constants.kGreyText2,
                                        height: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: GridView.count(
                                  childAspectRatio: 1.3,
                                  controller: ScrollController(),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                  children: List.generate(
                                    section.values.length,
                                    (indexUser) => _buildUserCard(
                                      section.values[indexUser],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverGrid.count(
                      childAspectRatio: 1.4,
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      children: List.generate(
                        gerenciarEquipeStore.searchUser.length,
                        (index) => _buildUserCard(
                          gerenciarEquipeStore.searchUser[index],
                        ),
                      ),
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

  Widget _buildUserCard(Usuario user) {
    return AppEntityCard(
      leading: const Icon(
        Icons.account_circle,
        color: Constants.kButtonGrey,
        size: 35,
      ),
      title: user.nome ?? '',
      subtitle: user.selected_conta?.cargo?.cargo ?? '',
      badges: [
        AppBadge(
          label: user.ativo == true ? 'ATIVO' : 'INATIVO',
          tone:
              user.ativo == true ? AppBadgeTone.success : AppBadgeTone.neutral,
          icon: Icons.circle,
        ),
      ],
      onTap: () {
        gerenciarEquipeStore.setUsuarioSelecionado(user);
        Get.toNamed(Routes.detalhesUsuarioPage);
      },
    );
  }
}

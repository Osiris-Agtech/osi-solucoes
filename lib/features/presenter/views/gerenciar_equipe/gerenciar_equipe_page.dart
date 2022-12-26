import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/top_app_bar.dart';
import 'package:osi_solucoes/features/presenter/widgets/floating_actino_button.dart';

import '../../../../core/constants/constants.dart';
import '../../viewmodels/gerenciar_equipe_store.dart';

class GerenciarEquipePage extends StatefulWidget {
  const GerenciarEquipePage({Key? key}) : super(key: key);

  @override
  State<GerenciarEquipePage> createState() => _GerenciarEquipePage();
}

class _GerenciarEquipePage extends State<GerenciarEquipePage> {
  final scrollController = ScrollController();

  //mudar conta para usuario
  GerenciarEquipeStore gerenciarEquipeStore = GetIt.I<GerenciarEquipeStore>();

  final dropDownKey = GlobalKey<DropdownSearchState<String>>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    gerenciarEquipeStore.buscarUsuarios();
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
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          backgroundColor: Constants.kSecondBackgroundColor,
          floatingActionButton: const NewFloatingActionButton(
            nivel: 3,
          ),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              controller: scrollController,
              primary: false,
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppBar(store: gerenciarEquipeStore),
                Observer(builder: (_) {
                  if (gerenciarEquipeStore.isSolucaoListLoading) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 200.0, left: 60, right: 60),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  if (gerenciarEquipeStore.userList.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 200.0, left: 60, right: 60),
                        child: Center(
                          child: Text(
                            "Não há usuário cadastrados",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                  if (gerenciarEquipeStore.searchUserText.isEmpty) {
                    return SliverToBoxAdapter(
                      child: ListView.builder(
                        itemCount: gerenciarEquipeStore.userMap.length,
                        controller: scrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: const Divider(
                                        color: Constants.kGreyText2,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    gerenciarEquipeStore.userMap[index].key,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: const Divider(
                                        color: Constants.kGreyText2,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: GridView.count(
                                  childAspectRatio: 1.3,
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                  children: List.generate(
                                    gerenciarEquipeStore
                                        .userMap[index].values.length,
                                    (indexUser) => CardUsuario(
                                      user: gerenciarEquipeStore
                                          .userMap[index].values[indexUser],
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
                        (index) => CardUsuario(
                          user: gerenciarEquipeStore.searchUser[index],
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
}

// ignore: camel_case_types
class AppBar extends StatefulWidget {
  const AppBar({
    Key? key,
    required this.store,
  }) : super(key: key);

  final GerenciarEquipeStore store;

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  GerenciarEquipeStore gerenciarEquipeStore = GetIt.I<GerenciarEquipeStore>();
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      child: SliverAppBar(
        pinned: true,
        backgroundColor: Colors.white,
        toolbarHeight: 180,
        floating: true,
        automaticallyImplyLeading: false,
        forceElevated: true,
        elevation: 1,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopAppBar(
              namePage: 'Gereciar Equipe',
              subtitle: "Lista de colaboradores",
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: TextFormField(
                onChanged: (value) =>
                    gerenciarEquipeStore.setsearchUserText(value),
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Pesquisar',
                  hintStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardUsuario extends StatefulWidget {
  final Usuario user;
  const CardUsuario({Key? key, required this.user}) : super(key: key);

  @override
  State<CardUsuario> createState() => _CardUsuarioState();
}

class _CardUsuarioState extends State<CardUsuario> {
  GerenciarEquipeStore store = GetIt.I<GerenciarEquipeStore>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {},
      child: Card(
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.account_circle,
                    color: Constants.kButtonGrey,
                    size: 35,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 10,
                          color: Constants.kGreyText,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color:
                                widget.user.ativo != null && widget.user.ativo!
                                    ? Constants.kGreyText2
                                    : Constants.kPrimaryColor,
                            size: 10,
                          ),
                          Text(
                            widget.user.ativo != null && widget.user.ativo!
                                ? ' Inativo'
                                : ' Ativo',
                            style: const TextStyle(
                              fontSize: 9,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.user.nome ?? '',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Constants.kGreyText),
              ),
              Text(
                widget.user.selected_conta?.cargo?.cargo ?? '',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Constants.kPrimaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

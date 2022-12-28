import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/repositories/gerenciarEquipe/gerenciar_equipe.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/user_map_model.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import "package:collection/collection.dart";

import '../../../core/utils/toast.dart';

part 'gerenciar_equipe_store.g.dart';

class GerenciarEquipeStore = _GerenciarEquipeBase with _$GerenciarEquipeStore;

abstract class _GerenciarEquipeBase with Store {
  //####################### START LISTAGEM DE USUARIOS ##########################

  @observable
  int value = 0;

  @observable
  bool isSolucaoListLoading = false;

  @observable
  List<Usuario> userList = [];

  @observable
  List<UserMap> userMap = [];

  @action
  void increment() {
    value++;
  }

  @action
  buscarUsuarios() async {
    AuthController authController = GetIt.I<AuthController>();
    GerenciarEquipeRepository gerenciarEquipeRepository =
        GetIt.I<GerenciarEquipeRepository>();
    isSolucaoListLoading = true;

    var usuarios = await gerenciarEquipeRepository
        .buscarUsuarios(authController.usuario.selected_conta!.conta!.id!);

    usuarios.fold(
      (err) {
        userList = ObservableList.of([]);
        toastError(message: err.message);
      },
      (data) async {
        userList = ObservableList.of(data);
        // Encontrando a conta logada na lista de contas do usuario
        for (var user in userList) {
          int index = user.contas!.indexWhere((element) =>
              element.conta!.id ==
              authController.usuario.selected_conta!.conta!.id);
          if (index != -1) {
            user.selected_conta = user.contas?[index];
          }
        }
        // Separando os usuarios por cargo
        var map = groupBy(
            userList, (Usuario obj) => obj.selected_conta?.cargo?.cargo);
        userMap.clear();
        map.forEach(
          (key, value) {
            userMap.add(
              UserMap(
                key: key ?? '',
                values: value,
              ),
            );
          },
        );
        userMap = List.from(userMap);
      },
    );

    isSolucaoListLoading = false;
  }
  //####################### END LISTAGEM DE USUARIOS ##########################

  //####################### START PESQUISAR ##########################
  @observable
  String searchUserText = '';

  @action
  setsearchUserText(String value) => searchUserText = value;

  @computed
  List<Usuario> get searchUser {
    List<Usuario> result = userList
        .where((element) =>
            element.nome
                ?.toLowerCase()
                .contains(searchUserText.toLowerCase()) ??
            false)
        .toList();

    return result;
  }

  //####################### END PESQUISAR ##########################

  @observable
  Usuario? usuarioSelecionado;

  @action
  setUsuarioSelecionado(Usuario value) => usuarioSelecionado = value;
}

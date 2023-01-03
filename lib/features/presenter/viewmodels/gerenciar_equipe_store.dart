import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/repositories/gerenciarEquipe/gerenciar_equipe.dart';
import 'package:osi_solucoes/features/presenter/models/cargo/cargo_model.dart';
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
  //####################### START DETALHES DO USUARIO  ##########################
  @observable
  Usuario usuarioSelecionado = Usuario();

  @observable
  bool? ativoIsChanged;

  @observable
  List<Cargo> cargosList = [];

  @observable
  Cargo? cargoSelecionadoDetalhesPage;

  @action
  setUsuarioSelecionado(Usuario value) => usuarioSelecionado = value;

  @action
  setAtivo(bool value) => ativoIsChanged = value;

  @action
  clearDatalhes() {
    ativoIsChanged = null;
    cargoSelecionado = null;
    cargoSelecionadoDetalhesPage = null;
    cargosList = [];
  }

  @action
  setInitialCargo() {
    cargoSelecionadoDetalhesPage = null;
    for (var element in cargosList) {
      if (element.id == usuarioSelecionado.selected_conta?.cargo?.id) {
        cargoSelecionadoDetalhesPage = element;
      }
    }
  }

  @action
  setCargoDetalhesPage(Cargo cargo) => cargoSelecionadoDetalhesPage = cargo;

  @action
  buscarCargos() async {
    GerenciarEquipeRepository gerenciarEquipeRepository =
        GetIt.I<GerenciarEquipeRepository>();
    isSolucaoListLoading = true;

    var cargos = await gerenciarEquipeRepository.buscarCargos();

    cargos.fold(
      (err) {
        cargosList = ObservableList.of([]);
        toastError(message: err.message);
      },
      (data) async {
        cargosList = ObservableList.of(data);
      },
    );

    isSolucaoListLoading = false;
  }
  //####################### END DETALHES DO USUARIO  ##########################
  //####################### START CADASTRAR USUARIO  ##########################

  @observable
  Cargo? cargoSelecionado;

  @action
  setCargo(Cargo cargo) => cargoSelecionado = cargo;
  //####################### END CADASTRAR USUARIO  ##########################

}

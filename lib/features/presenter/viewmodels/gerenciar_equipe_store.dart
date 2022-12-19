import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/repositories/gerenciarEquipe/gerenciar_equipe.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

import '../../../core/utils/toast.dart';

part 'gerenciar_equipe_store.g.dart';

class GerenciarEquipeStore = _GerenciarEquipeBase with _$GerenciarEquipeStore;

abstract class _GerenciarEquipeBase with Store {
  @observable
  int value = 0;

  @observable
  bool isSolucaoListLoading = false;

  //mudar conta para usuario
  @observable
  List<Usuario> userList = [];

  @observable
  String searchSolucaoText = '';

  @action
  void increment() {
    value++;
  }

  @action
  setsearchSolucaoText(String value) => searchSolucaoText = value;

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
        for (var user in userList) {
          int index = user.contas!.indexWhere((element) =>
              element.conta!.id ==
              authController.usuario.selected_conta!.conta!.id);
          if (index != -1) {
            user.selected_conta = user.contas?[index];
          }
        }
      },
    );

    isSolucaoListLoading = false;
  }

  // @computed
  // List<SolucaoNutritiva> get searchSolucao {
  //   List<SolucaoNutritiva> result = solucaoList
  //       .where((element) =>
  //           element.nome
  //               ?.toLowerCase()
  //               .contains(searchSolucaoText.toLowerCase()) ??
  //           false)
  //       .toList();

  //   return result;
  // }
}

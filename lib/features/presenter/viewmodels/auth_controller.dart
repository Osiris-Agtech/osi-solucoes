import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';

import '../models/usuario/usuario_model.dart';

part 'auth_controller.g.dart';

class AuthController = _AuthControllerBase with _$AuthController;

abstract class _AuthControllerBase with Store {
  @observable
  Usuario usuario = Usuario();

  @observable
  bool isDevelop = false;

  @observable
  int developCount = 0;

  @action
  setUser(Usuario user) => usuario = user;

  @action
  setIsDevelop() {
    if (developCount == 9) {
      isDevelop = !isDevelop;
      developCount = 0;

      if (isDevelop) {
        toastSuccess(message: "Modo Desenvolvimento");
      } else {
        toastError(message: "Modo Produção");
      }
    } else {
      developCount++;
    }
  }
}

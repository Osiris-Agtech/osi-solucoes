import 'package:mobx/mobx.dart';

import '../models/usuario/usuario_model.dart';

part 'auth_controller.g.dart';

class AuthController = AuthControllerBase with _$AuthController;

abstract class AuthControllerBase with Store {
  @observable
  Usuario usuario = Usuario();

  @action
  Usuario setUser(Usuario user) => usuario = user;

  // @observable
  // bool isDevelop = false;

  // @observable
  // int developCount = 0;

  // @action
  // setIsDevelop() {
  //   if (developCount == 9) {
  //     isDevelop = !isDevelop;
  //     developCount = 0;

  //     if (isDevelop) {
  //       toastSuccess(message: "Modo Desenvolvimento");
  //     } else {
  //       toastError(message: "Modo Produção");
  //     }
  //   } else {
  //     developCount++;
  //   }
  // }
}

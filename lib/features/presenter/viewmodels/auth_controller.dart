import 'package:mobx/mobx.dart';

import '../models/usuario/usuario_model.dart';

part 'auth_controller.g.dart';

class AuthController = _AuthControllerBase with _$AuthController;

abstract class _AuthControllerBase with Store {
  @observable
  Usuario usuario = Usuario();

  @action
  setUser(Usuario user) => usuario = user;
}

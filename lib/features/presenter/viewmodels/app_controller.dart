import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../models/usuario/usuario_model.dart';

part 'app_controller.g.dart';

@Injectable()
class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase with Store implements Disposable {
  @observable
  Usuario usuario = Usuario();

  @action
  setUser(Usuario user) => usuario = user;

  @override
  void dispose() {}
}

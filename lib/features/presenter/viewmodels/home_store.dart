import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/auth_controller.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  AuthController authController = GetIt.I<AuthController>();

  @observable
  bool isNotified = false;

  @action
  toggleNotified() => isNotified = !isNotified;

  @observable
  bool isCollapsed = true;

  @action
  setIsCollaped() => isCollapsed = !isCollapsed;
}

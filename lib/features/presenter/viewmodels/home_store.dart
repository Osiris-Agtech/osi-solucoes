import 'package:osi_solucoes/features/presenter/viewmodels/app_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  @observable
  late AppController appController = Modular.get();

  @observable
  bool isNotified = false;

  @action
  toggleNotified() => isNotified = !isNotified;

  @observable
  bool isCollapsed = true;

  @action
  setIsCollaped() => isCollapsed = !isCollapsed;
}

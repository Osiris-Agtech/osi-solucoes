import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  @observable
  bool isNotified = true;

  @action
  toggleNotified() {
    isNotified = !isNotified;
  }

  @observable
  bool isCollapsed = true;

  @action
  setIsCollaped() => isCollapsed = !isCollapsed;
}

import 'dart:core';

import 'package:mobx/mobx.dart';

part 'agenda_store.g.dart';

class AgendaStore = _AgendaStoreBase with _$AgendaStore;

abstract class _AgendaStoreBase with Store {
  @observable
  bool showEditPage = false;

  @action
  setShowEditPage(bool value) => showEditPage = value;
}

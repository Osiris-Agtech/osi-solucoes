import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

part 'reservatorios_store.g.dart';

class ReservatoriosStore = _ReservatoriosStoreBase with _$ReservatoriosStore;

abstract class _ReservatoriosStoreBase with Store {
// ------------------------ NOVO RESERVATÓRIO ----------------------------------

  SolucaoNutritiva solucaoTest = SolucaoNutritiva(
    id: 1,
    nome: "Furlani",
    c_eletrica: 1.8,
    created_at: DateTime.now(),
    reservatorios: [],
  );

  @observable
  Reservatorio novoReservatorio = Reservatorio();

  @observable
  SolucaoNutritiva solucaoNutritiva = SolucaoNutritiva();

  @observable
  bool isSolucaoNutritivaValid = false;

  @observable
  TextEditingController novoReservatorioName = TextEditingController();

  @observable
  TextEditingController novoReservatorioVolume = TextEditingController();

  @action
  setSolucaoNutritiva(SolucaoNutritiva solucao) {
    solucaoNutritiva = solucao;
    isSolucaoNutritivaValid = true;
  }

  limparNovoReservatorio() {
    isSolucaoNutritivaValid = false;
    novoReservatorio = Reservatorio();
    solucaoNutritiva = SolucaoNutritiva();
    novoReservatorioName.clear();
    novoReservatorioVolume.clear();
  }
}

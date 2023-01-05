import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/solucoes/solucoes_repository.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizanteNutriente/fertilizanteNutrienteMap_model.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizanteNutriente/fertilizanteNutriente_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import "package:collection/collection.dart";

part 'solucao_store.g.dart';

class SolucaoStore = _SolucaoStoreBase with _$SolucaoStore;

abstract class _SolucaoStoreBase with Store {
  @observable
  int value = 0;

  @observable
  bool isSolucaoListLoading = false;

  @observable
  bool isSolucaoDetalhesLoading = false;

  @observable
  List<SolucaoNutritiva> solucaoList = [];

  @observable
  List<FertilizanteNutrienteMap> nutrientesList = [];

  @observable
  SolucaoNutritiva solucaoSelecionada = SolucaoNutritiva();

  @observable
  TextEditingController condutividadeEletrica = TextEditingController();

  @observable
  String searchSolucaoText = '';

  @action
  void increment() {
    value++;
  }

  @action
  setsearchSolucaoText(String value) => searchSolucaoText = value;

  @action
  selecionarSolucao(SolucaoNutritiva solucaoNutritiva) =>
      solucaoSelecionada = solucaoNutritiva;

  @action
  buscarSolucoes() async {
    AuthController authController = GetIt.I<AuthController>();
    SolucaoRepository solucaoRepository = GetIt.I<SolucaoRepository>();
    isSolucaoListLoading = true;

    var solucoes = await solucaoRepository
        .buscarSolucoes(authController.usuario.selected_conta!.conta!.id!);

    solucoes.fold(
      (err) {
        solucaoList = ObservableList.of([]);
        toastError(message: err.message);
      },
      (data) async {
        solucaoList = ObservableList.of(data);
      },
    );

    isSolucaoListLoading = false;
  }

  @action
  buscarDetalhesSolucao() async {
    SolucaoRepository solucaoRepository = GetIt.I<SolucaoRepository>();
    isSolucaoDetalhesLoading = true;

    var solucoes =
        await solucaoRepository.detalhesSolucao(solucaoSelecionada.id!);

    solucoes.fold(
      (err) {
        toastError(message: err.message);
        nutrientesList.clear();
      },
      (data) async {
        solucaoSelecionada = data;
        nutrientesList.clear();
        for (SolucaoFertilizanteConcentrada fertilizante
            in solucaoSelecionada.solucoes_fertilizantes_concentradas ?? []) {
          var map = groupBy(
              fertilizante.fertilizante!.fertilizantes_nutrientes!,
              (FertilizanteNutriente obj) =>
                  obj.nutriente?.sigla ?? 'Não informado');
          map.forEach(
            (key, value) {
              int index =
                  nutrientesList.indexWhere((element) => element.key == key);
              if (index != -1) {
                double teor = double.parse(
                        nutrientesList[index].values[0].teor_nutriente ??
                            '0.0') +
                    double.parse(value[0].teor_nutriente ?? '0.0');
                nutrientesList[index].values[0].teor_nutriente =
                    teor.toString();
                return;
              }
              nutrientesList
                  .add(FertilizanteNutrienteMap(key: key, values: value));
            },
          );
        }
        nutrientesList = List.from(nutrientesList);
      },
    );

    isSolucaoDetalhesLoading = false;
  }

  @computed
  List<SolucaoNutritiva> get searchSolucao {
    List<SolucaoNutritiva> result = solucaoList
        .where((element) =>
            element.nome
                ?.toLowerCase()
                .contains(searchSolucaoText.toLowerCase()) ??
            false)
        .toList();

    return result;
  }
}

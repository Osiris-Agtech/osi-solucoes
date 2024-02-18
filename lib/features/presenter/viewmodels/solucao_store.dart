import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:sigma_hort_gestao_producao/core/utils/toast.dart';
import 'package:sigma_hort_gestao_producao/features/data/repositories/solucoes/solucoes_repository.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/fertilizanteNutriente/fertilizanteNutrienteMap_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/fertilizanteNutriente/fertilizanteNutriente_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/viewmodels/auth_controller.dart';
import "package:collection/collection.dart";

part 'solucao_store.g.dart';

class SolucaoStore = _SolucaoStoreBase with _$SolucaoStore;

abstract class _SolucaoStoreBase with Store {
  @observable
  int value = 0;

  @observable
  bool mostrarErroFormulario = false;

  @observable
  bool isSolucaoListLoading = false;

  @observable
  bool isNovaSolucaoLoading = false;

  @observable
  bool isFertilizanteListLoading = false;

  @observable
  bool isSolucaoDetalhesLoading = false;

  @observable
  int dotIndicator = 1;

  @observable
  SolucaoNutritiva novaSolucao = SolucaoNutritiva();

  @observable
  List<SolucaoNutritiva> solucaoList = [];

  @observable
  List<SelecaoFertilizante> fertilizanteList = [];

  @observable
  List<ItemFertilizante> expandedFertilizantes = [];

  @observable
  List<String> quantidadeFertilizantes = [];

  @observable
  List<FertilizanteNutrienteMap> nutrientesList = [];

  @observable
  TextEditingController novaSolucaoName = TextEditingController();

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
  setDotIndicator(int value) {
    if (value >= 0 && value <= 1) {
      dotIndicator = value;
    }
  }

  @action
  setExpandedCard(int index) {
    expandedFertilizantes[index].isExpanded =
        !expandedFertilizantes[index].isExpanded;
    expandedFertilizantes = List.from(expandedFertilizantes);
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
        // toastError(message: err.message);
      },
      (data) async {
        solucaoList = ObservableList.of(data);
      },
    );

    isSolucaoListLoading = false;
  }

  @action
  removeFromExpendedList(int id) {
    expandedFertilizantes
        .removeWhere((element) => element.fertilizante.id == id);

    int index =
        fertilizanteList.indexWhere((element) => element.fertilizante.id == id);
    if (index != -1) {
      fertilizanteList[index].selected = false;
    }

    fertilizanteList = List.from(fertilizanteList);
    expandedFertilizantes = List.from(expandedFertilizantes);
  }

  @action
  changeSelecaoFertilizante(int index, bool value) {
    // Seção para expansão dos Cards
    int indexList = expandedFertilizantes.indexWhere((element) =>
        element.fertilizante.id == fertilizanteList[index].fertilizante.id);

    if (indexList != -1) {
      expandedFertilizantes.removeAt(indexList);
    }

    fertilizanteList[index].selected = value;
    fertilizanteList = List.from(fertilizanteList);

    if (value) {
      int indexComputedList = selectedFertilizantes.indexWhere(
          (element) => element.id == fertilizanteList[index].fertilizante.id);
      expandedFertilizantes.insert(
        indexComputedList,
        ItemFertilizante(
          fertilizante: selectedFertilizantes[indexComputedList],
          quantidade: '0',
        ),
      );
    }
    expandedFertilizantes = List.from(expandedFertilizantes);
  }

  @action
  setFertilizanteQuantidade(int id, String value) {
    int index = expandedFertilizantes
        .indexWhere((element) => element.fertilizante.id == id);
    if (index != -1) {
      expandedFertilizantes[index].quantidade = value;
      expandedFertilizantes = List.from(expandedFertilizantes);
    }
  }

  @action
  buscarFertilizantes() async {
    SolucaoRepository solucaoRepository = GetIt.I<SolucaoRepository>();
    isFertilizanteListLoading = true;
    fertilizanteList = [];
    expandedFertilizantes = [];
    quantidadeFertilizantes = [];

    var fertilizantes = await solucaoRepository.buscarFertilizantes();

    fertilizantes.fold(
      (err) {
        fertilizanteList = ObservableList.of([]);
        // toastError(message: err.message);
      },
      (data) async {
        for (var item in data) {
          fertilizanteList.add(
            SelecaoFertilizante(
              selected: false,
              fertilizante: item,
            ),
          );
        }
        expandedFertilizantes = List.from(expandedFertilizantes);
        quantidadeFertilizantes = List.from(quantidadeFertilizantes);
        fertilizanteList = List.from(fertilizanteList);
      },
    );

    isFertilizanteListLoading = false;
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

  @action
  validarFertilizantes() {
    if (expandedFertilizantes.isEmpty) {
      toastError(
          message: 'Selecione pelo menos um fertilizante para a solução');
      return false;
    }

    for (var item in expandedFertilizantes) {
      if (double.parse(
              item.quantidade.replaceAll('.', '').replaceAll(',', '.')) <=
          0) {
        toastError(
            message: 'Preencha o valor em todos os fertilizantes selecionados');
        return false;
      }
    }
    return true;
  }

  @action
  validarCadastro() {
    bool validate = novaSolucaoName.text.isNotEmpty && validarFertilizantes();

    mostrarErroFormulario = !validate;
    return validate;
  }

  @action
  cadastrarSolucaoNutritiva() async {
    isNovaSolucaoLoading = true;
    SolucaoRepository solucaoRepository = GetIt.I<SolucaoRepository>();
    AuthController authController = GetIt.I<AuthController>();

    SolucaoNutritiva novaSolucao = SolucaoNutritiva(
      nome: novaSolucaoName.text,
      c_eletrica: calcularCoeficienteEletrico().toString(),
      solucoes_fertilizantes_concentradas:
          generateSolucaoFertilizanteConcentrada(),
    );

    var fertilizantes = await solucaoRepository.registrarSolucaoNutritiva(
        novaSolucao, authController.usuario.selected_conta!.conta!.id!);

    fertilizantes.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        Get.back();
        buscarSolucoes();
      },
    );

    isNovaSolucaoLoading = false;
  }

  @action
  double calcularCoeficienteEletrico() {
    double coeficiente = 0.0;
    for (var item in expandedFertilizantes) {
      coeficiente += double.parse(item.fertilizante.c_eletrica ?? '0.0') *
          double.parse(
              item.quantidade.replaceAll('.', '').replaceAll(',', '.'));
    }
    return coeficiente;
  }

  @action
  generateSolucaoFertilizanteConcentrada() {
    List<SolucaoFertilizanteConcentrada> list = [];
    for (var item in expandedFertilizantes) {
      list.add(
        SolucaoFertilizanteConcentrada(
          fertilizante: item.fertilizante,
          quantidade: item.quantidade.replaceAll('.', '').replaceAll(',', '.'),
        ),
      );
    }
    return list;
  }

  @action
  clearAll() {
    novaSolucaoName.clear();
    expandedFertilizantes.clear();
    quantidadeFertilizantes.clear();
  }

  @computed
  List<Fertilizante> get selectedFertilizantes {
    List<Fertilizante> list = [];
    for (var item in fertilizanteList) {
      if (item.selected) {
        list.add(item.fertilizante);
      }
    }

    return list;
  }

  @computed
  List<FertilizanteNutriente> get nutrientesCalculados {
    List<FertilizanteNutriente> list = [];
    int indexSelectedFertilizantes = 0;

    for (Fertilizante fertilizante in selectedFertilizantes) {
      for (FertilizanteNutriente item
          in fertilizante.fertilizantes_nutrientes ?? []) {
        /// Verifica se o nitriente já existe na lista final
        int index = list.indexWhere(
          (element) => element.nutriente?.sigla == item.nutriente?.sigla,
        );

        /// Caso exista
        if (index != -1) {
          /// Somar o teor do nitriente que já está na lista, com o nutriente
          ///
          list[index].teor_nutriente =
              (double.parse(list[index].teor_nutriente ?? '0.0') +
                      (double.parse(item.teor_nutriente ?? '0.0') *
                              double.parse(
                                expandedFertilizantes[
                                        indexSelectedFertilizantes]
                                    .quantidade
                                    .replaceAll('.', '')
                                    .replaceAll(',', '.'),
                              )) /
                          100)
                  .toStringAsFixed(2);
        } else {
          list.add(
            FertilizanteNutriente(
              nutriente: item.nutriente,
              teor_nutriente: ((double.parse(item.teor_nutriente ?? '0.0') *
                          double.parse(
                            expandedFertilizantes[indexSelectedFertilizantes]
                                .quantidade
                                .replaceAll('.', '')
                                .replaceAll(',', '.'),
                          )) /
                      100)
                  .toStringAsFixed(2),
            ),
          );
        }
      }
      indexSelectedFertilizantes++;
    }
    list.sort(
      (a, b) => double.parse(b.teor_nutriente ?? '0.0').compareTo(
        double.parse(a.teor_nutriente ?? '0.0'),
      ),
    );
    // list.sort((a, b) {
    //   double valueA = double.parse(a.teor_nutriente ?? '0');
    //   double valueB = double.parse(b.teor_nutriente ?? '0');
    //   if (valueA >
    //       double.parse(b.teor_nutriente ?? '0')) return -1;
    // });
    return list;
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

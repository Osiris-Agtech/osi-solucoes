import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/solucoes/solucoes_repository.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizanteNutriente/fertilizanteNutrienteMap_model.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizanteNutriente/fertilizanteNutriente_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoConcentrada/solucaoConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import "package:collection/collection.dart";
import 'package:osi_solucoes/features/presenter/viewmodels/reservatorios_store.dart';

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
  List<SolucaoFertilizanteConcentrada> solucaoConcentradaListDetalhes = [];

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
  setMostrarErroFormulario(bool value) => mostrarErroFormulario = value;

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
  double calcularQuantidadeFertilizanteConcentrada({
    required double quantidadeOriginal,
    required double volumeConcentrada,
    required double fator,
  }) {
    return volumeConcentrada * quantidadeOriginal * fator / 1000;
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
        solucaoConcentradaListDetalhes = [];
        nutrientesList.clear();
        for (SolucaoFertilizanteConcentrada fertilizante
            in solucaoSelecionada.solucoes_fertilizantes_concentradas ?? []) {
          if (fertilizante.concentrada != null) {
            if (solucaoConcentradaListDetalhes.indexWhere((solucao) =>
                    solucao.concentrada?.id == fertilizante.concentrada?.id) ==
                -1) {
              solucaoConcentradaListDetalhes.add(fertilizante);
            }
          }

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

        //----------------------------------------------------------------------------

        double teorNitrogenio = double.tryParse(nutrientesList
                    .firstWhereOrNull((element) => element.key == 'N')
                    ?.values[0]
                    .teor_nutriente ??
                '1.0') ??
            1.0;

        for (var i = 0; i < nutrientesList.length; i++) {
          if (nutrientesList[i].key == 'N-NO3-') {
            nutrientesList[i].values[0].teor_nutriente = ((double.tryParse(
                            nutrientesList[i].values[0].teor_nutriente ??
                                '0.0') ??
                        0.0) *
                    teorNitrogenio)
                .toString();
          }

          if (nutrientesList[i].key == 'N-NH4+') {
            nutrientesList[i].values[0].teor_nutriente = ((double.tryParse(
                            nutrientesList[i].values[0].teor_nutriente ??
                                '0.0') ??
                        0.0) *
                    teorNitrogenio)
                .toString();
          }
        }

        //----------------------------------------------------------------------------

        nutrientesList = List.from(nutrientesList);
        solucaoConcentradaListDetalhes =
            List.from(solucaoConcentradaListDetalhes);
      },
    );

    isSolucaoDetalhesLoading = false;
  }

  @action
  multiplicarTeorNitratoEAmonia() {
    double teorNitrogenio = double.tryParse(nutrientesList
                .firstWhereOrNull((element) => element.key == 'N')
                ?.values[0]
                .teor_nutriente ??
            '1.0') ??
        1.0;

    for (var i = 0; i < nutrientesList.length; i++) {
      if (nutrientesList[i].key == 'N-NO3-') {
        nutrientesList[i].values[0].teor_nutriente = ((double.tryParse(
                        nutrientesList[i].values[0].teor_nutriente ?? '0.0') ??
                    0.0) *
                teorNitrogenio)
            .toString();
      }

      if (nutrientesList[i].key == 'N-NH4+') {
        nutrientesList[i].values[0].teor_nutriente = ((double.tryParse(
                        nutrientesList[i].values[0].teor_nutriente ?? '0.0') ??
                    0.0) *
                teorNitrogenio)
            .toString();
      }
    }
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
  cadastrarSolucaoNutritiva({bool isShortcut = false}) async {
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
      novaSolucao,
      authController.usuario.selected_conta!.conta!.id!,
      solucaoConcentradaList.isNotEmpty,
    );

    fertilizantes.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        if (isShortcut) {
          ReservatoriosStore reservatoriosStore = GetIt.I<ReservatoriosStore>();
          await reservatoriosStore.buscarSolucoes();
          await reservatoriosStore.setSolucaoNutritiva(data);
          Get.close(1);
        }

        Get.close(2);
        clearAll();
        if (!isShortcut) buscarSolucoes();
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

    if (solucaoConcentradaList.isEmpty) {
      for (var item in expandedFertilizantes) {
        list.add(
          SolucaoFertilizanteConcentrada(
            fertilizante: item.fertilizante,
            quantidade:
                item.quantidade.replaceAll('.', '').replaceAll(',', '.'),
          ),
        );
      }
    } else {
      for (var item in expandedFertilizantes) {
        int concentradaIndex = solucaoConcentradaList.indexWhere((element) {
          SolucaoFertilizanteConcentrada? fertilizante =
              element.solucoes_fertilizantes_concentradas!.singleWhereOrNull(
            (element) => element.fertilizante?.id == item.fertilizante.id,
          );

          if (fertilizante != null) return true;
          return false;
        });

        list.add(
          SolucaoFertilizanteConcentrada(
            fertilizante: item.fertilizante,
            concentrada: solucaoConcentradaList[concentradaIndex],
            quantidade:
                item.quantidade.replaceAll('.', '').replaceAll(',', '.'),
          ),
        );
      }
    }

    return list;
  }

  @action
  validateNewSN() {
    bool validate =
        novaSolucaoName.text.isNotEmpty && expandedFertilizantes.isNotEmpty;

    for (var item in expandedFertilizantes) {
      try {
        if (item.quantidade.isEmpty ||
            double.parse(
                    item.quantidade.replaceAll('.', '').replaceAll(',', '.')) ==
                0) {
          validate = false;
          toastError(
              message:
                  'A quantidade do fertilizante não pode ser 0, verifique sua lista e preencha corretamente.');
          return validate;
        }
      } catch (e) {
        e.printError();
        validate = false;
        toastError(
            message:
                'Quantidade do fertilizante com valor inválido, verifique sua lista e preencha corretamente.');
        return validate;
      }
    }

    mostrarErroFormulario = !validate;
    return validate;
  }

  @action
  bool validarCadastroConcentrada() {
    if (fatorConcentracao.text.isEmpty && solucaoConcentradaList.isNotEmpty) {
      toastError(message: 'Preencha o fator de concentração');
      return false;
    }

    for (var item in solucaoConcentradaList) {
      if ((item.nome ?? '').isEmpty) {
        toastError(
            message: 'Preencha o nome em todas as soluções concentradas');
        return false;
      }

      if ((item.solucoes_fertilizantes_concentradas ?? []).isEmpty) {
        toastError(
            message:
                'Solução concentrada precisa ter pelo menos um fertilizante');
        return false;
      }
    }

    return true;
  }

  @action
  clearAll() {
    novaSolucaoName.clear();
    expandedFertilizantes.clear();
    quantidadeFertilizantes.clear();
    solucaoConcentradaList.clear();
    fatorConcentracao.clear();
    volumeConcentracao.clear();
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

    //--------------------------------------------------------------------------

    double teorNitrogenio = double.tryParse(list
                .firstWhereOrNull((element) => element.nutriente?.sigla == 'N')
                ?.teor_nutriente ??
            '1.0') ??
        1.0;

    for (var i = 0; i < list.length; i++) {
      if (list[i].nutriente?.sigla == 'N-NO3-') {
        list[i].teor_nutriente =
            ((double.tryParse(list[i].teor_nutriente ?? '0.0') ?? 0.0) *
                    teorNitrogenio)
                .toString();
      }

      if (list[i].nutriente?.sigla == 'N-NH4+') {
        list[i].teor_nutriente =
            ((double.tryParse(list[i].teor_nutriente ?? '0.0') ?? 0.0) *
                    teorNitrogenio)
                .toString();
      }
    }

    //--------------------------------------------------------------------------
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

  // #################### INICIO CADASTRO SOLUÇÃO CONCENTRADA #######################
  @observable
  List<SelecaoFertilizante> fertilizantesEscolhidos = [];

  @observable
  TextEditingController fatorConcentracao = TextEditingController();

  @observable
  TextEditingController volumeConcentracao = TextEditingController();

  @observable
  List<SolucaoConcentrada> solucaoConcentradaList = [];

  // @observable
  // List<int> compatibilidadeConcentrada = [];

  @action
  setFertilizantesEscolhidos() {
    fertilizantesEscolhidos = [];
    for (var item in expandedFertilizantes) {
      fertilizantesEscolhidos.add(
        SelecaoFertilizante(
          selected: false,
          fertilizante: item.fertilizante,
        ),
      );
    }
    fertilizantesEscolhidos = List.from(fertilizantesEscolhidos);
  }

  @action
  changeSelecaoFertilizantesEscolhidos(int index, bool value) {
    fertilizantesEscolhidos[index].selected = value;
    fertilizantesEscolhidos = List.from(fertilizantesEscolhidos);
  }

  @action
  addFertilizanteParaSolucao(int indexSolucaoConcentrada) {
    for (var item in showFertilizantesNaoUtilizados) {
      if (item.selected) {
        if (solucaoConcentradaList[indexSolucaoConcentrada]
                .solucoes_fertilizantes_concentradas ==
            null) {
          solucaoConcentradaList[indexSolucaoConcentrada]
              .solucoes_fertilizantes_concentradas = [];
        }
        solucaoConcentradaList[indexSolucaoConcentrada]
            .solucoes_fertilizantes_concentradas!
            .add(SolucaoFertilizanteConcentrada(
                fertilizante: item.fertilizante));
      }
    }
    solucaoConcentradaList = List.from(solucaoConcentradaList);
    Get.back();
  }

  @action
  criarSolucaoConcentrada() async {
    SolucaoRepository solucaoRepository = GetIt.I<SolucaoRepository>();

    for (var i = 0; i < solucaoConcentradaList.length; i++) {
      SolucaoConcentrada novaConcentrada = SolucaoConcentrada(
        nome: solucaoConcentradaList[i].nome,
        fator_concentracao: double.tryParse(fatorConcentracao.text),
        volume: double.tryParse(volumeConcentracao.text) ?? 1,
      );

      var solucaoConcentrada = await solucaoRepository
          .cadastrarSolucaoConcentrada(novaSolucaoConcentrada: novaConcentrada);

      solucaoConcentrada.fold(
        (err) {
          toastError(message: err.message);
        },
        (data) async {
          solucaoConcentradaList[i].id = data.id;
        },
      );
    }
    return;
  }

  @action
  clearSolucaoConcentrada() {
    solucaoConcentradaList = [];
    fatorConcentracao = TextEditingController();
    volumeConcentracao = TextEditingController();
  }

  @action
  setNomeSolucaoConcentrada(String nomeSolucaoConcentrada, int index) {
    if (nomeSolucaoConcentrada.isEmpty) return;
    solucaoConcentradaList[index].nome = nomeSolucaoConcentrada.trim();
    solucaoConcentradaList = List.from(solucaoConcentradaList);
  }

  @action
  addToSolucaoConcentradaList() {
    solucaoConcentradaList.add(SolucaoConcentrada());
    solucaoConcentradaList = List.from(solucaoConcentradaList);
    setFertilizantesEscolhidos();
  }

  @action
  deleteSolucaoConcentradaToTheList(int index) {
    solucaoConcentradaList.removeAt(index);
    solucaoConcentradaList = List.from(solucaoConcentradaList);
    setFertilizantesEscolhidos();
  }

  @computed
  List<SelecaoFertilizante> get showFertilizantesNaoUtilizados {
    List<SelecaoFertilizante> list = fertilizantesEscolhidos;
    // Para cada solução concentrada na lista
    for (var solucaoConcentrada in solucaoConcentradaList) {
      // Para cada fertilizante na solução concentrada
      for (SolucaoFertilizanteConcentrada item
          in solucaoConcentrada.solucoes_fertilizantes_concentradas ?? []) {
        int index = list.indexWhere(
            (element) => element.fertilizante.id == item.fertilizante?.id);
        if (index != -1) {
          list.removeAt(index);
        }
      }
    }

    return list;
  }

  @computed
  List<SelecaoFertilizante> get showSelectedFertilizantes {
    List<SelecaoFertilizante> list = [];
    for (var item in showFertilizantesNaoUtilizados) {
      if (item.selected) {
        list.add(item);
      }
    }

    return list;
  }

  @action
  bool checkCompatibilidade(
      {required int number, required int indexConcentrada}) {
    bool isCompatible = false;
    List<SelecaoFertilizante> list = List.from(showSelectedFertilizantes);

    for (SolucaoFertilizanteConcentrada item
        in solucaoConcentradaList[indexConcentrada]
                .solucoes_fertilizantes_concentradas ??
            []) {
      list.add(
        SelecaoFertilizante(
          selected: true,
          fertilizante: item.fertilizante!,
        ),
      );
    }

    switch (number) {
      case 0:
        isCompatible = true;
        break;
      case 1:
        int index = list
            .indexWhere((element) => element.fertilizante.compatibilidade == 2);
        if (index != -1) {
          isCompatible = false;
        } else {
          isCompatible = true;
        }
        break;
      case 2:
        int index = list
            .indexWhere((element) => element.fertilizante.compatibilidade == 1);
        if (index != -1) {
          isCompatible = false;
        } else {
          isCompatible = true;
        }
        break;
      default:
        isCompatible = true;
        break;
    }

    return isCompatible;
  }
}

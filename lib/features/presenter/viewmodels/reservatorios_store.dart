import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/reservatorio/reservatorio_repository.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizanteNutriente/fertilizanteNutriente_model.dart';
import 'package:osi_solucoes/features/presenter/models/relacaoNutriente/relacaoNutriente_model.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

part 'reservatorios_store.g.dart';

class ReservatoriosStore = _ReservatoriosStoreBase with _$ReservatoriosStore;

abstract class _ReservatoriosStoreBase with Store {
  ReservatorioRepository reservatorioRepository =
      GetIt.I<ReservatorioRepository>();
  AuthController authController = GetIt.I<AuthController>();

// ###################### RESERVATÓRIO DETALHES ################################

  @observable
  Reservatorio reservatorioDetalhes = Reservatorio();

  @observable
  List<SolucaoFertilizanteConcentrada> solucaoNutritivaList = [];

  @observable
  List<SolucaoFertilizanteConcentrada> solucaoConcentradaList = [];

  @observable
  double indexDotDetalhe = 0.0;

  @action
  setIndexDotDetalhe(double value) => indexDotDetalhe = value;

  @action
  setReservatorioDetalhes(Reservatorio reservatorio) {
    reservatorioDetalhes = reservatorio;
  }

  @action
  buscarReservatorioDetalhes() async {
    var reservatorios = await reservatorioRepository
        .buscarReservatorioDetalhes(reservatorioDetalhes.id!);

    reservatorios.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        reservatorioDetalhes = data;
        solucaoNutritivaList = [];
        solucaoConcentradaList = [];
        reservatorioDetalhes.solucao?.solucoes_fertilizantes_concentradas
            ?.forEach(
          (element) {
            solucaoNutritivaList.add(element);
            if (element.concentrada != null) {
              if (solucaoConcentradaList.indexWhere((solucao) =>
                      solucao.concentrada?.id == element.concentrada?.id) ==
                  -1) {
                solucaoConcentradaList.add(element);
              }
            }
          },
        );
      },
    );

    solucaoNutritivaList = List.from(solucaoNutritivaList);
    solucaoConcentradaList = List.from(solucaoConcentradaList);
  }

// ######################## NOVO RESERVATÓRIO ##################################

  @observable
  bool mostrarErroFormulario = false;

  @observable
  bool isSolucaoListLoading = false;

  @observable
  bool isReservatorioListLoading = false;

  @observable
  bool isNovoReservatorioLoading = false;

  @observable
  bool isDetalhesSolucaoLoading = false;

  @observable
  bool isEditing = false;

  @observable
  SolucaoNutritiva? solucaoDetalhes;

  @observable
  List<FertilizanteNutriente> teorNutrientes = [];

  @observable
  List<RelacaoNutriente> relacaoNutrientes = [];

  @observable
  ObservableList<SolucaoNutritiva> solucaoList =
      ObservableList<SolucaoNutritiva>.of([]);

  @observable
  List<Reservatorio> reservatorioList = [];

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

  @observable
  TextEditingController pesquisarReceita = TextEditingController();

  @observable
  int dotIndicator = 1;

  @observable
  String searchReservatorioText = '';

  @action
  setSearchReservatorioText(String value) => searchReservatorioText = value;

  @computed
  List<Reservatorio> get searchReservatorio {
    List<Reservatorio> result = reservatorioList
        .where((element) =>
            element.nome
                ?.toLowerCase()
                .contains(searchReservatorioText.toLowerCase()) ??
            false)
        .toList();

    return result;
  }

  @action
  setDotIndicator(int value) {
    if (value >= 0 && value <= 2) {
      dotIndicator = value;
    }
  }

  @action
  setIsEditing(bool value) => isEditing = value;

  @action
  setMostrarErroFormulario(bool value) => mostrarErroFormulario = value;

  @action
  setSolucaoDetalhes(SolucaoNutritiva solucao) async {
    solucaoDetalhes = solucao;

    isDetalhesSolucaoLoading = true;

    var detalhes = await reservatorioRepository.detalhesSolucao(solucao.id!);

    teorNutrientes.clear();
    relacaoNutrientes.clear();

    detalhes.fold(
      (l) => toastError(message: l.message),
      (r) {
        solucaoDetalhes = r;

        // ADICIONA À LISTA "teorNutrientes" TODOS OS NUTRIENTES UTILIZADOS NA SOLUÇÃO NUTRITIVA
        solucaoDetalhes?.solucoes_fertilizantes_concentradas
            ?.forEach((element) {
          element.fertilizante?.fertilizantes_nutrientes?.forEach((nutriente) {
            int index = -1;

            for (var i = 0; i < teorNutrientes.length; i++) {
              if (teorNutrientes[i].nutriente?.id == nutriente.nutriente?.id) {
                index = i;
              }
            }

            if (index == -1) {
              teorNutrientes.add(nutriente);
            } else {
              teorNutrientes[index].teor_nutriente =
                  (double.parse(teorNutrientes[index].teor_nutriente!) +
                          double.parse(nutriente.teor_nutriente!))
                      .toString();
            }
          });
        });

        // RELAÇÃO NUTRIENTE
        var k = teorNutrientes.firstWhere(
          (element) => element.nutriente?.sigla == "K",
          orElse: () => FertilizanteNutriente(),
        );
        var n = teorNutrientes.firstWhere(
          (element) => element.nutriente?.sigla == "N",
          orElse: () => FertilizanteNutriente(),
        );
        var ca = teorNutrientes.firstWhere(
          (element) => element.nutriente?.sigla == "Ca",
          orElse: () => FertilizanteNutriente(),
        );
        var mg = teorNutrientes.firstWhere(
          (element) => element.nutriente?.sigla == "Mg",
          orElse: () => FertilizanteNutriente(),
        );
        var no3 = teorNutrientes.firstWhere(
          (element) => element.nutriente?.sigla == "NO3",
          orElse: () => FertilizanteNutriente(),
        );
        var nh4 = teorNutrientes.firstWhere(
          (element) => element.nutriente?.sigla == "NH4",
          orElse: () => FertilizanteNutriente(),
        );

        // K/N
        if (k.nutriente != null && n.nutriente != null) {
          relacaoNutrientes.add(
            RelacaoNutriente(
              relacao: "K/N",
              valor: double.parse(k.teor_nutriente!) /
                  double.parse(n.teor_nutriente!),
            ),
          );
        }

        // Ca/Mg
        if (ca.nutriente != null && mg.nutriente != null) {
          relacaoNutrientes.add(
            RelacaoNutriente(
              relacao: "Ca/Mg",
              valor: double.parse(ca.teor_nutriente!) /
                  double.parse(mg.teor_nutriente!),
            ),
          );
        }

        // K/Mg
        if (k.nutriente != null && mg.nutriente != null) {
          relacaoNutrientes.add(
            RelacaoNutriente(
              relacao: "K/Mg",
              valor: double.parse(k.teor_nutriente!) /
                  double.parse(mg.teor_nutriente!),
            ),
          );
        }

        // K/Ca
        if (k.nutriente != null && ca.nutriente != null) {
          relacaoNutrientes.add(
            RelacaoNutriente(
              relacao: "K/Ca",
              valor: double.parse(k.teor_nutriente!) /
                  double.parse(ca.teor_nutriente!),
            ),
          );
        }

        // NO3/NH4
        if (no3.nutriente != null && nh4.nutriente != null) {
          relacaoNutrientes.add(
            RelacaoNutriente(
              relacao: "NO3/NH4",
              valor: double.parse(no3.teor_nutriente!) /
                  double.parse(nh4.teor_nutriente!),
            ),
          );
        }
      },
    );

    isDetalhesSolucaoLoading = false;
  }

  @action
  setSolucaoNutritiva(SolucaoNutritiva solucao) {
    solucaoNutritiva = solucao;
    isSolucaoNutritivaValid = true;
  }

  @action
  desvincularSolucaoNutritiva() {
    solucaoNutritiva = SolucaoNutritiva();
    isSolucaoNutritivaValid = false;
  }

  @action
  buscarReservatorios() async {
    isReservatorioListLoading = true;

    var reservatorios = await reservatorioRepository
        .buscarReservatorios(authController.usuario.selected_conta!.conta!.id!);

    reservatorios.fold(
      (err) {
        reservatorioList = List.from([]);
      },
      (data) async {
        reservatorioList = List.from(data);
        reservatorioList = List.from(reservatorioList);
      },
    );

    isReservatorioListLoading = false;
  }

  @action
  buscarSolucoes() async {
    isSolucaoListLoading = true;

    var solucoes = await reservatorioRepository
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
  validarReservatorio() {
    bool validate = novoReservatorioName.text.isNotEmpty &&
        novoReservatorioVolume.text.isNotEmpty;

    mostrarErroFormulario = !validate;
    return validate;
  }

  @action
  registrarReservatorio() async {
    isNovoReservatorioLoading = true;

    novoReservatorio = Reservatorio(
      nome: novoReservatorioName.text,
      volume: novoReservatorioVolume.text,
      solucao: solucaoNutritiva,
      conta: authController.usuario.selected_conta?.conta,
    );

    var registrarReservatorio =
        await reservatorioRepository.registrarReservatorio(novoReservatorio);

    registrarReservatorio.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: "Cadastrado com sucesso");
        buscarReservatorios();
        limparNovoReservatorio();
        Get.close(1);
      },
    );

    isNovoReservatorioLoading = false;
  }

  @action
  carregarDadosReservatorio(Reservatorio reservatorio) {
    novoReservatorioName = TextEditingController(text: reservatorio.nome ?? '');
    novoReservatorioVolume =
        TextEditingController(text: reservatorio.volume ?? '');
    if (reservatorio.solucao?.id != null) {
      setSolucaoNutritiva(reservatorio.solucao!);
    }
  }

  @action
  updateReservatorio() async {
    isNovoReservatorioLoading = true;

    novoReservatorio = Reservatorio(
      id: reservatorioDetalhes.id,
      nome: novoReservatorioName.text,
      volume: novoReservatorioVolume.text,
      solucao: solucaoNutritiva,
      conta: authController.usuario.selected_conta?.conta,
    );

    var updateReservatorio = await reservatorioRepository.updateReservatorio(
        novoReservatorio: novoReservatorio);

    updateReservatorio.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: "Alterado com sucesso");
        buscarReservatorioDetalhes();
        buscarReservatorios();
        limparNovoReservatorio();
        Get.close(1);
      },
    );

    isNovoReservatorioLoading = false;
  }

  @action
  limparNovoReservatorio() {
    isSolucaoNutritivaValid = false;
    isEditing = false;
    novoReservatorio = Reservatorio();
    solucaoNutritiva = SolucaoNutritiva();
    novoReservatorioName.clear();
    novoReservatorioVolume.clear();
  }
}

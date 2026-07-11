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
import 'package:osi_solucoes/features/presenter/viewmodels/home_store.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/setor_store.dart';
import 'package:osi_solucoes/core/services/user_action_trace.dart';

part 'reservatorios_store.g.dart';

class ReservatoriosStore = ReservatoriosStoreBase with _$ReservatoriosStore;

abstract class ReservatoriosStoreBase with Store {
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
  double setIndexDotDetalhe(double value) => indexDotDetalhe = value;

  @action
  void setReservatorioDetalhes(Reservatorio reservatorio) {
    reservatorioDetalhes = reservatorio;
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
  Future<void> buscarReservatorioDetalhes({int? reservatorioId}) async {
    final id = reservatorioId ?? reservatorioDetalhes.id;

    if (id == null) {
      toastError(message: 'Reservatório inválido');
      return;
    }

    var reservatorios = await reservatorioRepository
        .buscarReservatorioDetalhes(id);

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
  bool isDeletingReservatorio = false;

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
  List<SolucaoNutritiva> solucaoList = [];

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
  String setSearchReservatorioText(String value) =>
      searchReservatorioText = value;

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
  void setDotIndicator(int value) {
    if (value >= 0 && value <= 2) {
      dotIndicator = value;
    }
  }

  @action
  bool setIsEditing(bool value) => isEditing = value;

  @action
  bool setMostrarErroFormulario(bool value) => mostrarErroFormulario = value;

  @action
  Future<void> setSolucaoDetalhes(SolucaoNutritiva solucao) async {
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
    return;
  }

  @action
  void setSolucaoNutritiva(SolucaoNutritiva solucao) {
    solucaoNutritiva = solucao;
    isSolucaoNutritivaValid = true;
  }

  @action
  void desvincularSolucaoNutritiva() {
    solucaoNutritiva = SolucaoNutritiva();
    isSolucaoNutritivaValid = false;
  }

  @action
  Future<void> buscarReservatorios() async {
    isReservatorioListLoading = true;

    final contaId = authController.usuario.selected_conta?.conta?.id;
    if (contaId == null) {
      isReservatorioListLoading = false;
      return;
    }

    var reservatorios = await reservatorioRepository
        .buscarReservatorios(contaId);

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
  Future<void> buscarSolucoes() async {
    isSolucaoListLoading = true;

    final contaId = authController.usuario.selected_conta?.conta?.id;
    if (contaId == null) {
      isSolucaoListLoading = false;
      return;
    }

    var solucoes = await reservatorioRepository
        .buscarSolucoes(contaId);

    solucoes.fold(
      (err) {
        solucaoList = List.from([]);
        // toastError(message: err.message);
      },
      (data) async {
        solucaoList = List.from(data);
      },
    );

    isSolucaoListLoading = false;
    return;
  }

  @action
  bool validarReservatorio() {
    bool validate = novoReservatorioName.text.isNotEmpty &&
        novoReservatorioVolume.text.isNotEmpty;

    mostrarErroFormulario = !validate;
    return validate;
  }

  @action
  Future<void> deletarReservatorio(int reservatorioId) async {
    isDeletingReservatorio = true;

    var result = await reservatorioRepository.deletarReservatorio(reservatorioId);

    result.fold(
      (err) {
        toastError(message: err.message);
      },
      (_) async {
        toastSuccess(message: 'Reservatório deletado com sucesso');
        await buscarReservatorios();
        Get.close(1);
        GetIt.I<UserActionTrace>().record(UserAction(
          entityType: 'reservoir',
          action: 'deleted',
          entityId: reservatorioId,
        ));
      },
    );

    isDeletingReservatorio = false;
  }

  @action
  Future<void> registrarReservatorio({bool isShortcut = false}) async {
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
        await buscarReservatorios();
        limparNovoReservatorio();

        if (isShortcut) {
          SetorStore setorStore = GetIt.I<SetorStore>();
          await setorStore.buscarReservatorios();
          setorStore.setReservatorioSelecionada(data);
        }

        Get.close(1);
        GetIt.I<HomeStore>().carregarHome();
        toastSuccess(message: "Cadastrado com sucesso");
        GetIt.I<UserActionTrace>().record(UserAction(
          entityType: 'reservoir',
          action: 'created',
          entityId: data.id,
          entityName: data.nome,
        ));
      },
    );

    isNovoReservatorioLoading = false;
  }

  @action
  void carregarDadosReservatorio(Reservatorio reservatorio) {
    novoReservatorioName = TextEditingController(text: reservatorio.nome ?? '');
    novoReservatorioVolume =
        TextEditingController(text: reservatorio.volume ?? '');
    if (reservatorio.solucao?.id != null) {
      setSolucaoNutritiva(reservatorio.solucao!);
    }
  }

  @action
  Future<void> updateReservatorio() async {
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
        GetIt.I<UserActionTrace>().record(UserAction(
          entityType: 'reservoir',
          action: 'edited',
          entityId: data.id,
          entityName: data.nome,
        ));
      },
    );

    isNovoReservatorioLoading = false;
  }

  @action
  void limparNovoReservatorio() {
    isSolucaoNutritivaValid = false;
    isEditing = false;
    novoReservatorio = Reservatorio();
    solucaoNutritiva = SolucaoNutritiva();
    novoReservatorioName.clear();
    novoReservatorioVolume.clear();
  }
}

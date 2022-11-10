import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/ajuste/ajuste_repository.dart';
import 'package:osi_solucoes/features/presenter/models/reposicaoFert/reposicaoFert_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

import '../models/reservatorio/reservatorio_model.dart';

part 'ajustes_store.g.dart';

class AjustesStore = _AjustesStoreBase with _$AjustesStore;

abstract class _AjustesStoreBase with Store {
  @observable
  int selectedItem = 26;

  @observable
  List<int> quantityList = List<int>.generate(50, (int i) => i);

  @action
  newValueItem(int newValue) => selectedItem = newValue;

  @observable
  TextEditingController cEletricoAtual = TextEditingController();
  @observable
  TextEditingController cEletricoDesejado = TextEditingController();
  @observable
  TextEditingController volumeAtual = TextEditingController();
  @observable
  TextEditingController volumeDesejado = TextEditingController();
  @observable
  TextEditingController pH = TextEditingController();
  @observable
  TextEditingController reservatorio = TextEditingController();

  @action
  clearAll() {
    cEletricoAtual.clear();
    cEletricoDesejado.clear();
    volumeAtual.clear();
    volumeDesejado.clear();
    pH.clear();
    reservatorio.clear();
    selectedReservatorio = Reservatorio();
  }

  // #################### DROPDOWN RESERVATORIO #######################

  @observable
  Reservatorio selectedReservatorio = Reservatorio();

  @observable
  List<Reservatorio> reservatorioList = [];

  @action
  selectReservatorio(Reservatorio reservatorio) {
    selectedReservatorio = reservatorio;
  }

  @action
  buscarReservatorios() async {
    AjusteRepository ajusteRepository = GetIt.I<AjusteRepository>();
    AuthController authController = GetIt.I<AuthController>();

    var reservatorios = await ajusteRepository
        .buscarReservatorios(authController.usuario.selected_conta!.conta!.id!);
    reservatorios.fold(
      (err) {
        reservatorioList = List.from([]);
        toastError(message: err.message);
      },
      (data) async {
        reservatorioList = List.from(data);
      },
    );
  }
  // #################### FIM DROPDOWN RESERVATORIO #######################

  // #################### INICIO CALCULO ##################################

  @observable
  double ceAgua = 0.1;

  @observable
  List<ReposicaoFert> reposicaoFert = [];

  @action
  calculoLado(SolucaoFertilizanteConcentrada fertilizante, String ce) {
    // Parse - string to double
    double quantidadeFertilizanteSN = double.parse(fertilizante.quantidade!);
    double ceDesejado = double.parse(cEletricoDesejado.text);
    // obs: Essa condutividade ja deve vir considerando CE da agua
    double ceTeorico =
        double.parse(selectedReservatorio.solucao?.c_eletrica ?? '0.0');

    //Fator de correção - check
    double fatorCorrecao = (ceDesejado - ceAgua) / (ceTeorico - ceAgua);

    // Quant fert ajustado
    double fertAjustado = quantidadeFertilizanteSN *
        double.parse(fatorCorrecao.toStringAsFixed(4));
    //Fator de proporcionalidade
    double proporcao =
        (ceDesejado - ceAgua) / double.parse(fertAjustado.toStringAsFixed(1));

    // referencia - Z13
    double cet = (double.parse(ce) - ceAgua) / proporcao;

    return cet;
  }

  // Calcula as quantidades de reposição de cada fertilizante
  // @returns Retorna um array de reposicaoFert()
  @action
  calculoAjuste() {
    reposicaoFert = [];
    selectedReservatorio.solucao?.solucoes_fertilizantes_concentradas
        ?.forEach((fertilizante) {
      if (fertilizante.fertilizante != null) {
        //calculo lado atual
        double x = calculoLado(fertilizante, cEletricoAtual.text);
        double ladoMedido = x * double.parse(volumeAtual.text);
        //calculo lado desejado
        double y = calculoLado(fertilizante, cEletricoDesejado.text);
        double ladoDesejado = y * double.parse(volumeDesejado.text);
        //valor de reposição para o fertilizante em gramas
        double reposicao = (ladoDesejado - ladoMedido) / 1000;
        reposicaoFert.add(ReposicaoFert(
            fertilizante: fertilizante.fertilizante!, valor: reposicao));
      }
    });
    return;
  }
}

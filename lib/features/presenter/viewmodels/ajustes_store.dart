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
    double ceTeorico =
        double.parse(selectedReservatorio.solucao?.c_eletrica ?? '0.0');
    // Referencias da celulas do excel planilha PLANILHA DE ELABORAÇÃO DE SOLUÇÃO NUTRITIVA-RafaelCampagnol
    // https://onedrive.live.com/edit.aspx?resid=49A98B4ECB99BBF9!70910&ithint=file%2cxlsx&authkey=!AJd2bx4J46wp3l4
    
    //condutividade eletrica na SN
    double ceSN =  double.parse(fertilizante.quantidade!) /1000 * double.parse(fertilizante.fertilizante!.c_eletrica!) ;
    // referencia - V11
    double relacao =
        (ceTeorico - ceAgua) / ceSN;
    // referencia - Y11
    double cet = (double.parse(ce) - ceAgua) / relacao;
    print(fertilizante.fertilizante!.nome);
    print(relacao);
    // referencia - H11
    double fertCE = double.parse(fertilizante.quantidade!) /
        double.parse(fertilizante.fertilizante!.c_eletrica!) *
        1000;
    // referencia - Z11
    double x = (cet * 1000) / fertCE;

    return x;
  }

  @action
  calculoAjuste() {
    reposicaoFert = [];
    selectedReservatorio.solucao?.solucoes_fertilizantes_concentradas
        ?.forEach((fertilizante) {
      if (fertilizante.fertilizante != null) {
        double x = calculoLado(fertilizante, cEletricoAtual.text);
        double ladoMedido = x * double.parse(volumeAtual.text);
        double y = calculoLado(fertilizante, cEletricoDesejado.text);
        double ladoDesejado = y * double.parse(volumeDesejado.text);
        double reposicao = ladoDesejado - ladoMedido;
        reposicaoFert.add(ReposicaoFert(
            fertilizante: fertilizante.fertilizante!, valor: reposicao));
      }
    });
    return;
  }
}

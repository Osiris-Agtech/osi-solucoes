import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/core/utils/toast.dart';
import 'package:osi_solucoes/features/data/repositories/ajuste/ajuste_repository.dart';
import 'package:osi_solucoes/features/presenter/models/atividade/atividade_model.dart';
import 'package:osi_solucoes/features/presenter/models/reposicaoFert/reposicaoFert_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoFertilizanteConcentrada/solucaoFertilizanteConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

import '../models/reservatorio/reservatorio_model.dart';

part 'ajustes_store.g.dart';

class AjustesStore = _AjustesStoreBase with _$AjustesStore;

abstract class _AjustesStoreBase with Store {
  @observable
  int selectedItem = 25;

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
  volumeAjusteAgua() =>
      double.parse(
          volumeDesejado.text.replaceAll('.', '').replaceAll(',', '.')) -
      double.parse(volumeAtual.text.replaceAll('.', '').replaceAll(',', '.'));

  @action
  validarCampos() {
    // Condutividade Elétrica Atual
    if (cEletricoAtual.text.isEmpty ||
        double.parse(
                cEletricoAtual.text.replaceAll('.', '').replaceAll(',', '.')) <=
            0) {
      toastError(
          message: 'Preencha um valor para "Condutividade Elétrica Atual"');
      return false;
    }

    // Volume Desejado
    if (cEletricoDesejado.text.isEmpty ||
        double.parse(cEletricoDesejado.text
                .replaceAll('.', '')
                .replaceAll(',', '.')) <=
            0) {
      toastError(
          message: 'Preencha um valor para "Condutividade Elétrica Desejado"');
      return false;
    }

    // Volume Atual
    if (volumeAtual.text.isEmpty ||
        double.parse(
                volumeAtual.text.replaceAll('.', '').replaceAll(',', '.')) <=
            0) {
      toastError(message: 'Preencha um valor para "Volume Atual"');
      return false;
    }

    // Volume Desejado
    if (volumeDesejado.text.isEmpty ||
        double.parse(
                volumeDesejado.text.replaceAll('.', '').replaceAll(',', '.')) <=
            0) {
      toastError(message: 'Preencha um valor para "Volume Desejado"');
      return false;
    }

    return true;
  }

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

  @observable
  List<SolucaoFertilizanteConcentrada> solucaoConcentradaList = [];

  @action
  selectReservatorio(Reservatorio reservatorio) {
    selectedReservatorio = reservatorio;
    getConcentradaList();
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
      },
      (data) async {
        reservatorioList = data;
        reservatorioList.removeWhere((element) => element.solucao == null);
        reservatorioList = List.from(data);
      },
    );
  }

  @action
  getConcentradaList() {
    solucaoConcentradaList.clear();
    for (SolucaoFertilizanteConcentrada fertilizante
        in selectedReservatorio.solucao?.solucoes_fertilizantes_concentradas ??
            []) {
      if (fertilizante.concentrada != null) {
        if (solucaoConcentradaList.indexWhere((solucao) =>
                solucao.concentrada?.id == fertilizante.concentrada?.id) ==
            -1) {
          solucaoConcentradaList.add(fertilizante);
        }
      }
    }

    if (solucaoConcentradaList.isNotEmpty) {
      fatorConcentracaoRecebido =
          solucaoConcentradaList[0].concentrada?.fator_concentracao ?? 100.0;
    }
  }
  // #################### FIM DROPDOWN RESERVATORIO #######################

  // #################### INICIO CALCULO ##################################
  @observable
  double ceAgua = 0.1;

  @observable
  String volumeConcentrado = '';

  @observable
  double fatorConcentracaoRecebido = 100;

  @observable
  List<ReposicaoFert> reposicaoFert = [];

  // Função auxiliar para o calculo
  // @returns double cet
  @action
  calculoLado(SolucaoFertilizanteConcentrada fertilizante, String ce) {
    // Parse - string to double
    double quantidadeFertilizanteSN = double.parse(fertilizante.quantidade!);
    double ceDesejado = double.parse(
        cEletricoDesejado.text.replaceAll('.', '').replaceAll(',', '.'));
    // obs: Essa condutividade ja deve vir considerando CE da agua
    double ceTeorico =
        double.parse(selectedReservatorio.solucao?.c_eletrica ?? '0.0');

    //Fator de correção
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
  calculoAjusteReposicao() {
    reposicaoFert = [];
    selectedReservatorio.solucao?.solucoes_fertilizantes_concentradas
        ?.forEach((fertilizante) {
      if (fertilizante.fertilizante != null) {
        //calculo lado atual
        double x = calculoLado(fertilizante,
            cEletricoAtual.text.replaceAll('.', '').replaceAll(',', '.'));
        double ladoMedido = x *
            double.parse(
                volumeAtual.text.replaceAll('.', '').replaceAll(',', '.'));
        //calculo lado desejado
        double y = calculoLado(fertilizante,
            cEletricoDesejado.text.replaceAll('.', '').replaceAll(',', '.'));
        double ladoDesejado = y *
            double.parse(
                volumeDesejado.text.replaceAll('.', '').replaceAll(',', '.'));
        //valor de reposição para o fertilizante em gramas
        double reposicao = (ladoDesejado - ladoMedido) / 1000;
        reposicaoFert.add(ReposicaoFert(
            fertilizante: fertilizante.fertilizante!, valor: reposicao));
      }
    });

    calculoAjusteConcentrada(
        double.parse(reposicaoFert[0].valor.toStringAsFixed(2)));
    return;
  }

  // Calcula as quantidades de reposição para solução concentrada
  // @returns double volumeConcentrado
  @action
  calculoAjusteConcentrada(double reposicaoFert) {
    //parses string to double
    double ceDesejado = double.parse(
        cEletricoDesejado.text.replaceAll('.', '').replaceAll(',', '.'));
    double quantidadeFertilizanteSN = double.parse(selectedReservatorio
            .solucao?.solucoes_fertilizantes_concentradas?[0].quantidade! ??
        '0.0');

    double fatorConcentracao = fatorConcentracaoRecebido;
    // obs: Essa condutividade ja deve vir considerando CE da agua
    double ceTeorico =
        double.parse(selectedReservatorio.solucao?.c_eletrica ?? '0.0');

    //Fator de correção
    double fatorCorrecao = (ceDesejado - ceAgua) / (ceTeorico - ceAgua);

    // Quant fert ajustado
    double fertAjustado = quantidadeFertilizanteSN *
        double.parse(fatorCorrecao.toStringAsFixed(4));

    // Quant de fertilizantes na solução concentrada (SC)
    double fertConcentrado = (fertAjustado * fatorConcentracao) / 1000;
    // Vol de SC (ml) para AJUSTE
    double volConcentrado = (reposicaoFert * 1000) / fertConcentrado;
    volumeConcentrado = volConcentrado.toStringAsFixed(0);
  }
  // #################### FIM CALCULO ##################################
  // #################### INICIO REGISTRO DE ATIVIDADE ##################################

  @action
  registrarAtividade() async {
    AuthController authController = GetIt.I<AuthController>();
    AjusteRepository ajusteRepository = GetIt.I<AjusteRepository>();

    var descricao = montandoDescricao();
    Atividade novaAtividade = Atividade(
      nome: 'Ajuste de Solução Nutritiva',
      descricao: descricao.toString(),
      conta: authController.usuario.selected_conta!.conta,
      created_at: DateTime.now(),
    );

    List<int> listLoteId = [];

    for (var lote in selectedReservatorio.lotes ?? []) {
      listLoteId.add(lote.id);
    }
    var registrarArea = await ajusteRepository.salvarAjuste(
        novaAtividade, authController.usuario.id!, listLoteId);

    registrarArea.fold(
      (err) {
        toastError(message: err.message);
      },
      (data) async {
        toastSuccess(message: "Cadastrado com sucesso");
        clearAll();
      },
    );
    //isNovaAreaLoading = false;
  }

  @action
  montandoDescricao() {
    // Construindo strings para descrição
    var volumeAjuste = (double.parse(
                volumeDesejado.text.replaceAll('.', '').replaceAll(',', '.')) -
            double.parse(
                volumeAtual.text.replaceAll('.', '').replaceAll(',', '.')))
        .toString();
    var fertDescrition = '';
    String ph = "PH: Não Informado";

    //Construindo String reposicaoFert
    for (var listFert in reposicaoFert) {
      var fertDescritionline =
          "${listFert.valor.toStringAsFixed(2)} g  ${listFert.fertilizante.nome} \n";
      fertDescrition = fertDescrition + fertDescritionline;
    }
    // Construindo String concentrada
    // Construindo String pH
    if (pH.text != '') {
      ph = "PH: ${pH.text}";
    }

    //Criando encoded da descrição
    var encoded = utf8.encode("##Ajuste Solução Nutritiva##\n\n"
        "Reservatório: ${selectedReservatorio.nome ?? 'Não informado'} \n"
        "$volumeAjuste L Água \n\n"
        "Condutividade Elétrica: ${cEletricoAtual.text} S.m/mm2 -> ${cEletricoDesejado.text} S.m/mm2 \n"
        "Volume: ${volumeAtual.text}L -> ${volumeDesejado.text}L \n\n"
        "$ph \n"
        "Temperatura: ${selectedItem.toString()} ºC \n\n"
        "Reposição por Fertilizante: \n"
        "$fertDescrition \n\n"
        "Reposição por Solução Concentrada: \n"
        "$volumeConcentrado ml por solução");

    // var decoded = utf8.decode(encoded);
    return encoded;
  }
  // #################### FIM REGISTRO DE ATIVIDADE ##################################

}

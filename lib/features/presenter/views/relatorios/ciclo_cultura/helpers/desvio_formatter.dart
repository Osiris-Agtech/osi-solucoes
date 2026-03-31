import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

const double kThresholdNormal = 5.0;
const double kThresholdAlerta = 30.0;

enum DesvioStatus { adiantado, normal, atrasado, semProtocolo }

DesvioStatus getDesvioStatus(double? desvioPercentual) {
  if (desvioPercentual == null) return DesvioStatus.semProtocolo;
  if (desvioPercentual > kThresholdNormal) return DesvioStatus.atrasado;
  if (desvioPercentual < -kThresholdNormal) return DesvioStatus.adiantado;
  return DesvioStatus.normal;
}

Color getDesvioColor(DesvioStatus status) {
  switch (status) {
    case DesvioStatus.atrasado:
      return const Color(0xFFF97316); // laranja
    case DesvioStatus.adiantado:
      return Constants.kPrimaryColor; // verde do app
    case DesvioStatus.normal:
      return Constants.kGreyText2;
    case DesvioStatus.semProtocolo:
      return Constants.kGreyLight;
  }
}

Color getDesvioBackgroundColor(DesvioStatus status) {
  switch (status) {
    case DesvioStatus.atrasado:
      return const Color(0xFFFFF7ED); // laranja claro
    case DesvioStatus.adiantado:
      return const Color(0xFFECFDF5); // verde claro
    case DesvioStatus.normal:
      return const Color(0xFFF5F5F5);
    case DesvioStatus.semProtocolo:
      return const Color(0xFFF5F5F5);
  }
}

String formatDesvio(double? desvioPercentual, double? desvioDias) {
  if (desvioPercentual == null) return '—';
  final sinal = desvioPercentual > 0 ? '+' : '';
  final dias = desvioDias?.toStringAsFixed(0) ?? '?';
  final perc = desvioPercentual.toStringAsFixed(1);
  return '$sinal${dias}d ($sinal$perc%)';
}

String formatDuracao(double? dias) {
  if (dias == null) return '—';
  return '${dias.toStringAsFixed(0)}d';
}

String getDesvioLabel(DesvioStatus status) {
  switch (status) {
    case DesvioStatus.atrasado:
      return 'Atrasado';
    case DesvioStatus.adiantado:
      return 'Adiantado';
    case DesvioStatus.normal:
      return 'No prazo';
    case DesvioStatus.semProtocolo:
      return 'Sem protocolo';
  }
}

bool isAlertaIndividual(double? desvioPercentual) {
  if (desvioPercentual == null) return false;
  return desvioPercentual > kThresholdAlerta;
}

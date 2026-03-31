import 'package:flutter/material.dart';

// Thresholds para taxa_transplantio e taxa_embalagem (percentual 0–100)
const double kConversaoCritico = 50.0; // < 50% → vermelho
const double kConversaoAlerta = 70.0;  // 50–70% → laranja
const double kConversaoBom = 85.0;     // ≥ 85% → verde
// 70–85% → cinza (normal/aceitável)

enum ConversaoStatus { critico, alerta, normal, bom }

ConversaoStatus getConversaoStatus(double? taxa) {
  if (taxa == null) return ConversaoStatus.normal;
  if (taxa < kConversaoCritico) return ConversaoStatus.critico;
  if (taxa < kConversaoAlerta) return ConversaoStatus.alerta;
  if (taxa >= kConversaoBom) return ConversaoStatus.bom;
  return ConversaoStatus.normal;
}

Color getConversaoColor(ConversaoStatus status) {
  switch (status) {
    case ConversaoStatus.critico:
      return const Color(0xFFDC2626); // vermelho
    case ConversaoStatus.alerta:
      return const Color(0xFFEA580C); // laranja
    case ConversaoStatus.bom:
      return const Color(0xFF059669); // verde
    case ConversaoStatus.normal:
      return const Color(0xFF6B7280); // cinza
  }
}

Color getConversaoBackgroundColor(ConversaoStatus status) {
  switch (status) {
    case ConversaoStatus.critico:
      return const Color(0xFFFEE2E2);
    case ConversaoStatus.alerta:
      return const Color(0xFFFFF7ED);
    case ConversaoStatus.bom:
      return const Color(0xFFD1FAE5);
    case ConversaoStatus.normal:
      return const Color(0xFFF3F4F6);
  }
}

String getConversaoLabel(ConversaoStatus status) {
  switch (status) {
    case ConversaoStatus.critico:
      return 'Crítico';
    case ConversaoStatus.alerta:
      return 'Atenção';
    case ConversaoStatus.bom:
      return 'Bom';
    case ConversaoStatus.normal:
      return 'Normal';
  }
}

/// Formata uma taxa percentual como "91.9%"
String formatTaxaPercent(double? taxa) {
  if (taxa == null) return '—';
  return '${taxa.toStringAsFixed(1)}%';
}

/// Formata taxa_germinacao (razão, não percentual) como "4.2/band"
String formatTaxaGerminacao(double? taxa) {
  if (taxa == null) return '—';
  return '${taxa.toStringAsFixed(1)}/band';
}

/// Formata taxa_global (embalagens por bandeja) como "3.75 emb/band"
String formatTaxaGlobal(double? taxa) {
  if (taxa == null) return '—';
  return '${taxa.toStringAsFixed(2)} emb/band';
}

/// Retorna o pior status entre transplantio e embalagem de um setor
ConversaoStatus getPiorStatusSetor({
  double? taxaTransplantio,
  double? taxaEmbalagem,
}) {
  final st = getConversaoStatus(taxaTransplantio);
  final se = getConversaoStatus(taxaEmbalagem);
  const order = [
    ConversaoStatus.critico,
    ConversaoStatus.alerta,
    ConversaoStatus.normal,
    ConversaoStatus.bom,
  ];
  return order.indexOf(st) <= order.indexOf(se) ? st : se;
}

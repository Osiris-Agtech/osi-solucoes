import 'package:flutter/material.dart';

// Thresholds para taxaConclusao (percentual 0–100)
const double kConclusaoCritico = 50.0; // < 50% → vermelho
const double kConclusaoAlerta  = 80.0; // 50–80% → laranja
// ≥ 80% → verde

// Threshold para taxaPrazo
const double kPrazoBaixo = 70.0; // < 70% → badge "⚠ Atrasos"

enum ConclusaoStatus { critico, atencao, bom, semDados }

ConclusaoStatus getConclusaoStatus(double? taxa) {
  if (taxa == null) return ConclusaoStatus.semDados;
  if (taxa < kConclusaoCritico) return ConclusaoStatus.critico;
  if (taxa < kConclusaoAlerta) return ConclusaoStatus.atencao;
  return ConclusaoStatus.bom;
}

Color getConclusaoColor(ConclusaoStatus status) {
  switch (status) {
    case ConclusaoStatus.critico:
      return const Color(0xFFDC2626); // vermelho
    case ConclusaoStatus.atencao:
      return const Color(0xFFEA580C); // laranja
    case ConclusaoStatus.bom:
      return const Color(0xFF059669); // verde
    case ConclusaoStatus.semDados:
      return const Color(0xFF6B7280); // cinza
  }
}

Color getConclusaoBackgroundColor(ConclusaoStatus status) {
  switch (status) {
    case ConclusaoStatus.critico:
      return const Color(0xFFFEE2E2);
    case ConclusaoStatus.atencao:
      return const Color(0xFFFFF7ED);
    case ConclusaoStatus.bom:
      return const Color(0xFFD1FAE5);
    case ConclusaoStatus.semDados:
      return const Color(0xFFF3F4F6);
  }
}

String getConclusaoLabel(ConclusaoStatus status) {
  switch (status) {
    case ConclusaoStatus.critico:
      return 'Crítico';
    case ConclusaoStatus.atencao:
      return 'Atenção';
    case ConclusaoStatus.bom:
      return 'Bom';
    case ConclusaoStatus.semDados:
      return 'Sem dados';
  }
}

/// Formata uma taxa percentual como "80.0%"
String formatTaxa(double? taxa) {
  if (taxa == null) return '—';
  return '${taxa.toStringAsFixed(1)}%';
}

/// Retorna true quando taxaPrazo indica atrasos recorrentes
bool temAtrasos(double? taxaPrazo) {
  if (taxaPrazo == null) return false;
  return taxaPrazo < kPrazoBaixo;
}

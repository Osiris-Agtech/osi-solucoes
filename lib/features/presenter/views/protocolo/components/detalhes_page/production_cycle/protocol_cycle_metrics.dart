import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';
import 'package:osi_solucoes/features/presenter/models/fase/fase_model.dart';
import 'package:osi_solucoes/features/presenter/models/protocolo/protocolo_model.dart';

class ProtocolCycleMetrics {
  final int phaseCount;
  final int activityCount;
  final int alertCount;
  final int totalDurationDays;

  const ProtocolCycleMetrics({
    required this.phaseCount,
    required this.activityCount,
    required this.alertCount,
    required this.totalDurationDays,
  });

  factory ProtocolCycleMetrics.fromProtocol({
    required Protocolo? protocolo,
    required List<Fase> fases,
  }) {
    final groupedActions = _groupedActions(fases);
    final rawActions = protocolo?.acao ?? const <Acao>[];
    final actionsForCount = rawActions.isEmpty ? groupedActions : rawActions;

    return ProtocolCycleMetrics(
      phaseCount: fases.length,
      activityCount: actionsForCount.length,
      alertCount: actionsForCount.where((acao) => acao.alerta == true).length,
      totalDurationDays: fases.fold<int>(
        0,
        (total, fase) => total + (fase.duracao_dias ?? 0),
      ),
    );
  }
}

List<Acao> _groupedActions(List<Fase> fases) {
  return fases.expand((fase) => fase.acao ?? const <Acao>[]).toList();
}

String protocolDaysLabel(int? days) {
  if (days == null) return '-- dias';
  return days == 1 ? '1 dia' : '$days dias';
}

String protocolActivityCountLabel(int count) {
  return count == 1 ? '1 atividade' : '$count atividades';
}

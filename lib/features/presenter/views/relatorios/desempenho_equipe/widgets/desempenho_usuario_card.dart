import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_desempenho_equipe/relatorio_desempenho_equipe_model.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/desempenho_equipe/helpers/desempenho_formatter.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/desempenho_equipe/widgets/desempenho_agenda_tile.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/desempenho_equipe/widgets/desempenho_atividade_tile.dart';

class DesempenhoUsuarioCard extends StatefulWidget {
  final DesempenhoUsuarioRanking usuario;
  final int ranking;

  const DesempenhoUsuarioCard({
    super.key,
    required this.usuario,
    required this.ranking,
  });

  @override
  State<DesempenhoUsuarioCard> createState() => _DesempenhoUsuarioCardState();
}

class _DesempenhoUsuarioCardState extends State<DesempenhoUsuarioCard> {
  bool _expandido = false;

  @override
  Widget build(BuildContext context) {
    final usuario = widget.usuario;
    final status = getConclusaoStatus(usuario.taxaConclusao);
    final statusColor = getConclusaoColor(status);
    final statusBgColor = getConclusaoBackgroundColor(status);
    final comAtrasos = temAtrasos(usuario.taxaPrazo);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expandido = !_expandido),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: ranking + nome + badges
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '#${widget.ranking}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          usuario.usuarioNome,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      // Badge status conclusão
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          getConclusaoLabel(status),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                      // Badge atrasos
                      if (comAtrasos) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '⚠ Atrasos',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFEA580C),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(width: 6),
                      Icon(
                        _expandido
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 20,
                        color: const Color(0xFFD9D9D9),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Linha de métricas
                  Row(
                    children: [
                      _MetricaItem(
                        label: 'Atividades',
                        value: '${usuario.totalAtividades}',
                        color: const Color(0xFF6B7280),
                      ),
                      _MetricaItem(
                        label: 'Conclusão',
                        value: formatTaxa(usuario.taxaConclusao),
                        color: statusColor,
                      ),
                      _MetricaItem(
                        label: 'No prazo',
                        value: formatTaxa(usuario.taxaPrazo),
                        color: comAtrasos
                            ? const Color(0xFFEA580C)
                            : const Color(0xFF059669),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Resumo agendas
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 12, color: Color(0xFF9F9F9F)),
                      const SizedBox(width: 4),
                      Text(
                        '${usuario.agendasFinalizadas}/${usuario.totalAgendas} agenda${usuario.totalAgendas != 1 ? 's' : ''} concluída${usuario.agendasFinalizadas != 1 ? 's' : ''}',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF9F9F9F)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Seção expandida
          if (_expandido) ...[
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            if (usuario.ultimasAtividades.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Text(
                  'ÚLTIMAS ATIVIDADES',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9F9F9F),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ...usuario.ultimasAtividades
                  .map((a) => DesempenhoAtividadeTile(atividade: a)),
            ],
            if (usuario.agendasPendentes.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Text(
                  'AGENDAS PENDENTES / VENCIDAS',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9F9F9F),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ...usuario.agendasPendentes
                  .map((a) => DesempenhoAgendaTile(agenda: a)),
            ],
            if (usuario.ultimasAtividades.isEmpty &&
                usuario.agendasPendentes.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Sem detalhes disponíveis para este período.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9F9F9F)),
                ),
              ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _MetricaItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricaItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 10, color: Color(0xFF9F9F9F))),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

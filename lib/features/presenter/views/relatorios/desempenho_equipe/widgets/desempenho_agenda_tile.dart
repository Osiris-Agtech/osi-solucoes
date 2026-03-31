import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_desempenho_equipe/relatorio_desempenho_equipe_model.dart';

class DesempenhoAgendaTile extends StatelessWidget {
  final DesempenhoAgendaItem agenda;

  const DesempenhoAgendaTile({super.key, required this.agenda});

  String _formatarData(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cor = agenda.vencida ? const Color(0xFFDC2626) : const Color(0xFF6B7280);
    final icone = agenda.finalizado
        ? Icons.check_circle_outline
        : agenda.vencida
            ? Icons.warning_amber_outlined
            : Icons.radio_button_unchecked;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icone, size: 14, color: cor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              agenda.titulo ?? 'Sem título',
              style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
            ),
          ),
          Text(
            _formatarData(agenda.data),
            style: TextStyle(fontSize: 11, color: cor),
          ),
          if (agenda.vencida) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Vencida',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFDC2626),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

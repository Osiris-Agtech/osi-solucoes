import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_desempenho_equipe/relatorio_desempenho_equipe_model.dart';

class DesempenhoAtividadeTile extends StatelessWidget {
  final DesempenhoAtividadeItem atividade;

  const DesempenhoAtividadeTile({super.key, required this.atividade});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.assignment_outlined,
              size: 14, color: Color(0xFF9F9F9F)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              atividade.atividadeNome,
              style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
            ),
          ),
          if (atividade.loteNome != null)
            Text(
              atividade.loteNome!,
              style: const TextStyle(fontSize: 11, color: Color(0xFF9F9F9F)),
            ),
        ],
      ),
    );
  }
}

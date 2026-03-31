import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_ciclo_cultura/relatorio_ciclo_cultura_model.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/ciclo_cultura/helpers/desvio_formatter.dart';

class CicloLoteTile extends StatelessWidget {
  final CicloLoteDetalhe lote;

  const CicloLoteTile({super.key, required this.lote});

  @override
  Widget build(BuildContext context) {
    final status = getDesvioStatus(lote.desvioPercentual);
    final color = getDesvioColor(status);
    final alerta = isAlertaIndividual(lote.desvioPercentual);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        lote.loteNome ?? 'Lote #${lote.loteId}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    if (alerta)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFF97316), width: 0.5),
                        ),
                        child: const Text(
                          '⚠ Alerta',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFF97316),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Real: ${formatDuracao(lote.duracaoRealDias.toDouble())}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF9F9F9F)),
                    ),
                    if (lote.duracaoPlanejadaDias != null) ...[
                      const Text('  ·  ', style: TextStyle(fontSize: 11, color: Color(0xFF9F9F9F))),
                      Text(
                        'Prev: ${formatDuracao(lote.duracaoPlanejadaDias!.toDouble())}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF9F9F9F)),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      formatDesvio(lote.desvioPercentual, lote.desvioDias?.toDouble()),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

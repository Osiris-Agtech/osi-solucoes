import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_produtividade_setor/relatorio_produtividade_setor_model.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/produtividade_setor/helpers/conversao_formatter.dart';

class ProdutividadeAreaTile extends StatelessWidget {
  final ProdutividadeAreaDetalhe area;

  const ProdutividadeAreaTile({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    final statusTransplantio = getConversaoStatus(area.taxaTransplantio);
    final colorTransplantio = getConversaoColor(statusTransplantio);

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: colorTransplantio, width: 3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              area.areaNome,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _MetricChip(
                  label: 'Germ',
                  value: formatTaxaGerminacao(area.taxaGerminacao),
                  color: const Color(0xFF6B7280),
                ),
                _MetricChip(
                  label: 'Transpl',
                  value: formatTaxaPercent(area.taxaTransplantio),
                  color: colorTransplantio,
                ),
                _MetricChip(
                  label: 'Embal',
                  value: formatTaxaPercent(area.taxaEmbalagem),
                  color: getConversaoColor(getConversaoStatus(area.taxaEmbalagem)),
                ),
                _MetricChip(
                  label: 'Global',
                  value: formatTaxaGlobal(area.taxaGlobal),
                  color: const Color(0xFF6B7280),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${area.totalLotes} lote${area.totalLotes != 1 ? 's' : ''} · '
              '${area.totalBandejasSemeadas} band → ${area.totalEmbalagensProduzidas} emb',
              style: const TextStyle(fontSize: 11, color: Color(0xFF9F9F9F)),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF9F9F9F),
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

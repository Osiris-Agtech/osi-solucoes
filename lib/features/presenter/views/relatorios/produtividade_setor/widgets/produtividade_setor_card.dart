import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_produtividade_setor/relatorio_produtividade_setor_model.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/produtividade_setor/helpers/conversao_formatter.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/produtividade_setor/widgets/produtividade_area_tile.dart';

class ProdutividadeSetorCard extends StatefulWidget {
  final ProdutividadeSetorRanking setor;
  final int ranking;

  const ProdutividadeSetorCard({
    super.key,
    required this.setor,
    required this.ranking,
  });

  @override
  State<ProdutividadeSetorCard> createState() => _ProdutividadeSetorCardState();
}

class _ProdutividadeSetorCardState extends State<ProdutividadeSetorCard> {
  bool _expandido = false;

  @override
  Widget build(BuildContext context) {
    final setor = widget.setor;
    final piorStatus = getPiorStatusSetor(
      taxaTransplantio: setor.taxaTransplantio,
      taxaEmbalagem: setor.taxaEmbalagem,
    );
    final statusColor = getConversaoColor(piorStatus);
    final statusBgColor = getConversaoBackgroundColor(piorStatus);

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
                  // Header linha 1: ranking + nome + status pill
                  Row(
                    children: [
                      // Badge de ranking
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
                      // Nome do setor
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              setor.setorNome,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF333333),
                              ),
                            ),
                            if (setor.areaNome != null)
                              Text(
                                setor.areaNome!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9F9F9F),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Status pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          getConversaoLabel(piorStatus),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
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
                      _TaxaItem(
                        label: 'Germinação',
                        value: formatTaxaGerminacao(setor.taxaGerminacao),
                        color: const Color(0xFF6B7280),
                      ),
                      _TaxaItem(
                        label: 'Transplantio',
                        value: formatTaxaPercent(setor.taxaTransplantio),
                        color: getConversaoColor(
                            getConversaoStatus(setor.taxaTransplantio)),
                      ),
                      _TaxaItem(
                        label: 'Embalagem',
                        value: formatTaxaPercent(setor.taxaEmbalagem),
                        color: getConversaoColor(
                            getConversaoStatus(setor.taxaEmbalagem)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Linha de totais + taxa global
                  Row(
                    children: [
                      const Icon(Icons.grid_view_outlined,
                          size: 12, color: Color(0xFF9F9F9F)),
                      const SizedBox(width: 4),
                      Text(
                        '${setor.totalLotes} lote${setor.totalLotes != 1 ? 's' : ''} · '
                        '${setor.totalBandejasSemeadas} band → ${setor.totalEmbalagensProduzidas} emb',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF9F9F9F)),
                      ),
                      const Spacer(),
                      Text(
                        'Global: ${formatTaxaGlobal(setor.taxaGlobal)}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Áreas expandidas
          if (_expandido && setor.areas.isNotEmpty) ...[
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 6),
            ...setor.areas.map((a) => ProdutividadeAreaTile(area: a)),
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class _TaxaItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TaxaItem({
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
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF9F9F9F)),
          ),
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

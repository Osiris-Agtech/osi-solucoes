import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_ciclo_cultura/relatorio_ciclo_cultura_model.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/ciclo_cultura/helpers/desvio_formatter.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/ciclo_cultura/widgets/ciclo_lote_tile.dart';

class CicloCulturaCard extends StatefulWidget {
  final CicloRankingCultura cultura;
  final int ranking;

  const CicloCulturaCard({
    super.key,
    required this.cultura,
    required this.ranking,
  });

  @override
  State<CicloCulturaCard> createState() => _CicloCulturaCardState();
}

class _CicloCulturaCardState extends State<CicloCulturaCard> {
  bool _expandido = false;

  @override
  Widget build(BuildContext context) {
    final status = getDesvioStatus(widget.cultura.desvioMedioPercentual);
    final color = getDesvioColor(status);
    final bgColor = getDesvioBackgroundColor(status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header do card
          InkWell(
            onTap: () => setState(() => _expandido = !_expandido),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ranking badge
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '#${widget.ranking}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.cultura.culturaNome,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                            // Status pill
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                getDesvioLabel(status),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            _MetaChip(
                              label: '${widget.cultura.totalLotes} lote${widget.cultura.totalLotes != 1 ? 's' : ''}',
                              icon: Icons.layers_outlined,
                            ),
                            _MetaChip(
                              label: 'Real: ${formatDuracao(widget.cultura.duracaoRealMedia)}',
                              icon: Icons.timer_outlined,
                            ),
                            if (widget.cultura.duracaoPlanejadaMedia != null)
                              _MetaChip(
                                label: 'Prev: ${formatDuracao(widget.cultura.duracaoPlanejadaMedia)}',
                                icon: Icons.schedule_outlined,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Desvio + chevron
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatDesvio(
                          widget.cultura.desvioMedioPercentual,
                          widget.cultura.desvioMedioDias,
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        _expandido ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 18,
                        color: Constants.kGreyText2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Lotes expandidos
          if (_expandido) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            ...widget.cultura.lotes.map((lote) => CicloLoteTile(lote: lote)),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MetaChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Constants.kGreyText2),
        const SizedBox(width: 3),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF9F9F9F))),
      ],
    );
  }
}

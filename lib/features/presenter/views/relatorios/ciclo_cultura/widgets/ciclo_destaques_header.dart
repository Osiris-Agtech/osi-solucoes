import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_ciclo_cultura/relatorio_ciclo_cultura_model.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/ciclo_cultura/helpers/desvio_formatter.dart';

class CicloDestaquesHeader extends StatelessWidget {
  final RelatorioCicloResult resultado;
  final CicloRankingCultura? melhorCultura;
  final CicloRankingCultura? piorCultura;

  const CicloDestaquesHeader({
    super.key,
    required this.resultado,
    this.melhorCultura,
    this.piorCultura,
  });

  @override
  Widget build(BuildContext context) {
    final desvioGeral = resultado.desvioMedioGeral;
    final statusGeral = getDesvioStatus(desvioGeral);
    final colorGeral = getDesvioColor(statusGeral);
    final bgGeral = getDesvioBackgroundColor(statusGeral);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgGeral,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorGeral.withAlpha(51), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights_outlined, size: 16, color: colorGeral),
              const SizedBox(width: 6),
              Text(
                'Destaques do período',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorGeral,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Alerta geral
          _buildAlertaBanner(desvioGeral, colorGeral),
          const SizedBox(height: 10),
          Row(
            children: [
              if (melhorCultura != null)
                Expanded(
                  child: _DestaqueTile(
                    titulo: 'Melhor',
                    nome: melhorCultura!.culturaNome,
                    desvio: formatDesvio(
                      melhorCultura!.desvioMedioPercentual,
                      melhorCultura!.desvioMedioDias,
                    ),
                    color: getDesvioColor(
                      getDesvioStatus(melhorCultura!.desvioMedioPercentual),
                    ),
                  ),
                ),
              if (melhorCultura != null && piorCultura != null)
                Container(width: 1, height: 40, color: Colors.white54, margin: const EdgeInsets.symmetric(horizontal: 8)),
              if (piorCultura != null)
                Expanded(
                  child: _DestaqueTile(
                    titulo: 'Maior atraso',
                    nome: piorCultura!.culturaNome,
                    desvio: formatDesvio(
                      piorCultura!.desvioMedioPercentual,
                      piorCultura!.desvioMedioDias,
                    ),
                    color: getDesvioColor(
                      getDesvioStatus(piorCultura!.desvioMedioPercentual),
                    ),
                  ),
                ),
              Container(width: 1, height: 40, color: Colors.white54, margin: const EdgeInsets.symmetric(horizontal: 8)),
              Expanded(
                child: _DestaqueTile(
                  titulo: 'Desvio geral',
                  nome: formatDesvio(desvioGeral, null).split('(').first.trim(),
                  desvio: '${resultado.totalLotes} lotes',
                  color: Constants.kGreyText2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertaBanner(double desvio, Color color) {
    String mensagem;
    if (desvio > 10) {
      mensagem = 'Produção com atrasos recorrentes no período';
    } else if (desvio < -5) {
      mensagem = 'Produção adiantada no período';
    } else {
      mensagem = 'Produção dentro do planejado';
    }

    return Row(
      children: [
        Icon(
          desvio > 10
              ? Icons.warning_amber_outlined
              : desvio < -5
                  ? Icons.check_circle_outline
                  : Icons.check_circle_outline,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            mensagem,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _DestaqueTile extends StatelessWidget {
  final String titulo;
  final String nome;
  final String desvio;
  final Color color;

  const _DestaqueTile({
    required this.titulo,
    required this.nome,
    required this.desvio,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo.toUpperCase(),
          style: const TextStyle(fontSize: 9, color: Color(0xFF9F9F9F), letterSpacing: 0.5),
        ),
        const SizedBox(height: 2),
        Text(
          nome,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          desvio,
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

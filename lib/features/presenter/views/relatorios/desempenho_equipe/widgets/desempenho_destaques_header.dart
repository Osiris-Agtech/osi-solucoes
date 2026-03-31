import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_desempenho_equipe/relatorio_desempenho_equipe_model.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/desempenho_equipe/helpers/desempenho_formatter.dart';

class DesempenhoDestaquesHeader extends StatelessWidget {
  final RelatorioDesempenhoResult resultado;
  final DesempenhoUsuarioRanking? membroMaisAtivo;
  final DesempenhoUsuarioRanking? membroMaiorConclusao;
  final List<DesempenhoUsuarioRanking> membrosComAtrasos;

  const DesempenhoDestaquesHeader({
    super.key,
    required this.resultado,
    this.membroMaisAtivo,
    this.membroMaiorConclusao,
    required this.membrosComAtrasos,
  });

  String get _mensagemPrincipal {
    if (resultado.taxaConclusaoMedia < 60) {
      return 'Equipe com baixa taxa de conclusão no período';
    }
    if (membrosComAtrasos.isNotEmpty) {
      final nomes = membrosComAtrasos.map((m) => m.usuarioNome).join(', ');
      return 'Membros com atrasos recorrentes: $nomes';
    }
    return 'Equipe dentro dos parâmetros no período';
  }

  Color get _headerColor {
    if (resultado.taxaConclusaoMedia < 60) return const Color(0xFFFEE2E2);
    if (membrosComAtrasos.isNotEmpty) return const Color(0xFFFFF7ED);
    return const Color(0xFFD1FAE5);
  }

  Color get _iconColor {
    if (resultado.taxaConclusaoMedia < 60) return const Color(0xFFDC2626);
    if (membrosComAtrasos.isNotEmpty) return const Color(0xFFEA580C);
    return const Color(0xFF059669);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _headerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights_outlined, size: 16, color: _iconColor),
                const SizedBox(width: 6),
                Text(
                  'Destaques do período',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _iconColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _mensagemPrincipal,
              style: TextStyle(
                fontSize: 13,
                color: _iconColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _DestaqueTile(
                    titulo: 'Mais ativo',
                    nome: membroMaisAtivo?.usuarioNome ?? '—',
                    valor: membroMaisAtivo != null
                        ? '${membroMaisAtivo!.totalAtividades} atividades'
                        : '—',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.black.withValues(alpha: 0.08),
                ),
                Expanded(
                  child: _DestaqueTile(
                    titulo: 'Maior conclusão',
                    nome: membroMaiorConclusao?.usuarioNome ?? '—',
                    valor: formatTaxa(membroMaiorConclusao?.taxaConclusao),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.black.withValues(alpha: 0.08),
                ),
                Expanded(
                  child: _DestaqueTile(
                    titulo: 'Média equipe',
                    nome: '${resultado.totalUsuarios} membros',
                    valor: formatTaxa(resultado.taxaConclusaoMedia),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DestaqueTile extends StatelessWidget {
  final String titulo;
  final String nome;
  final String valor;

  const _DestaqueTile({
    required this.titulo,
    required this.nome,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF9F9F9F),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            nome,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_produtividade_setor/relatorio_produtividade_setor_model.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/produtividade_setor/helpers/conversao_formatter.dart';

class ProdutividadeDestaquesHeader extends StatelessWidget {
  final RelatorioProdutividadeResult resultado;
  final ProdutividadeSetorRanking? melhorSetor;
  final ProdutividadeSetorRanking? piorSetor;
  final String? etapaGargalo;

  const ProdutividadeDestaquesHeader({
    super.key,
    required this.resultado,
    this.melhorSetor,
    this.piorSetor,
    this.etapaGargalo,
  });

  String get _mensagemGargalo {
    if (etapaGargalo == 'transplantio') {
      final comDados = resultado.setores
          .where((s) => s.taxaTransplantio != null)
          .toList();
      if (comDados.isEmpty) return 'Produção dentro dos parâmetros';
      final media =
          comDados.map((s) => s.taxaTransplantio!).reduce((a, b) => a + b) /
              comDados.length;
      return 'Gargalo em Transplantio — ${media.toStringAsFixed(0)}% das mudas chegam à colheita';
    }
    if (etapaGargalo == 'embalagem') {
      final comDados = resultado.setores
          .where((s) => s.taxaEmbalagem != null)
          .toList();
      if (comDados.isEmpty) return 'Produção dentro dos parâmetros';
      final media =
          comDados.map((s) => s.taxaEmbalagem!).reduce((a, b) => a + b) /
              comDados.length;
      return 'Perda no Empacotamento — apenas ${media.toStringAsFixed(0)}% das plantas viram embalagem';
    }
    return 'Produção dentro dos parâmetros';
  }

  Color get _headerColor {
    if (etapaGargalo == 'transplantio') {
      final comDados = resultado.setores
          .where((s) => s.taxaTransplantio != null)
          .toList();
      if (comDados.isNotEmpty) {
        final media =
            comDados.map((s) => s.taxaTransplantio!).reduce((a, b) => a + b) /
                comDados.length;
        final status = getConversaoStatus(media);
        return getConversaoBackgroundColor(status);
      }
    }
    if (etapaGargalo == 'embalagem') {
      final comDados = resultado.setores
          .where((s) => s.taxaEmbalagem != null)
          .toList();
      if (comDados.isNotEmpty) {
        final media =
            comDados.map((s) => s.taxaEmbalagem!).reduce((a, b) => a + b) /
                comDados.length;
        final status = getConversaoStatus(media);
        return getConversaoBackgroundColor(status);
      }
    }
    return const Color(0xFFD1FAE5); // verde padrão (tudo ok)
  }

  Color get _iconColor {
    if (etapaGargalo != null) return const Color(0xFFEA580C);
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
              _mensagemGargalo,
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
                    titulo: 'Mais eficiente',
                    nome: melhorSetor?.setorNome ?? '—',
                    valor: formatTaxaGlobal(melhorSetor?.taxaGlobal),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.black.withValues(alpha: 0.08),
                ),
                Expanded(
                  child: _DestaqueTile(
                    titulo: 'Menos eficiente',
                    nome: piorSetor?.setorNome ?? '—',
                    valor: formatTaxaGlobal(piorSetor?.taxaGlobal),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.black.withValues(alpha: 0.08),
                ),
                Expanded(
                  child: _DestaqueTile(
                    titulo: 'Média global',
                    nome: '${resultado.totalLotes} lotes',
                    valor: formatTaxaGlobal(resultado.taxaGlobalMedia),
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

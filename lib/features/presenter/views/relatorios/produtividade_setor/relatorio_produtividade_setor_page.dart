import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/relatorio_produtividade_setor_store.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/produtividade_setor/widgets/produtividade_destaques_header.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/produtividade_setor/widgets/produtividade_filtros_sheet.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/produtividade_setor/widgets/produtividade_setor_card.dart';

class RelatorioProdutividadeSetorPage extends StatefulWidget {
  const RelatorioProdutividadeSetorPage({super.key});

  @override
  State<RelatorioProdutividadeSetorPage> createState() =>
      _RelatorioProdutividadeSetorPageState();
}

class _RelatorioProdutividadeSetorPageState
    extends State<RelatorioProdutividadeSetorPage> {
  final RelatorioProdutividadeSetorStore store =
      GetIt.I<RelatorioProdutividadeSetorStore>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      final useMock = args is Map && args['mock'] == true;
      if (useMock) {
        store.carregarMock();
      } else {
        store.carregarRelatorio();
      }
    });
  }

  void _abrirFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ProdutividadeFiltrosSheet(
          filtrosAtuais: store.filtros,
          onAplicar: (novosFiltros) => store.atualizarFiltros(novosFiltros),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kSecondBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF333333)),
        title: const Text(
          'Produtividade por Setor/Área',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_outlined, color: Color(0xFF333333)),
            onPressed: _abrirFiltros,
            tooltip: 'Filtros',
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (store.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Constants.kPrimaryColor),
            );
          }
          if (store.hasError) return _buildErro();
          if (!store.hasData) return _buildVazio();
          return _buildConteudo();
        },
      ),
    );
  }

  Widget _buildConteudo() {
    final resultado = store.resultado!;

    return ListView(
      children: [
        const SizedBox(height: 12),
        // Chip de período
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 13, color: Constants.kGreyText2),
              const SizedBox(width: 4),
              Text(
                '${_formatarData(resultado.periodoInicio)} – ${_formatarData(resultado.periodoFim)}',
                style:
                    const TextStyle(fontSize: 12, color: Color(0xFF9F9F9F)),
              ),
              const Spacer(),
              Text(
                '${resultado.totalLotes} lote${resultado.totalLotes != 1 ? 's' : ''} analisado${resultado.totalLotes != 1 ? 's' : ''}',
                style:
                    const TextStyle(fontSize: 12, color: Color(0xFF9F9F9F)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Destaques
        ProdutividadeDestaquesHeader(
          resultado: resultado,
          melhorSetor: store.melhorSetor,
          piorSetor: store.piorSetor,
          etapaGargalo: store.etapaGargalo,
        ),
        // Label ranking
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            'RANKING POR SETOR',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF9F9F9F),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        // Cards por setor
        ...resultado.setores.asMap().entries.map(
              (entry) => ProdutividadeSetorCard(
                setor: entry.value,
                ranking: entry.key + 1,
              ),
            ),
        // Botão exportar
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            onPressed: _exportarCSV,
            icon: const Icon(Icons.download_outlined, size: 18),
            label: const Text('Exportar CSV'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Constants.kGreyText,
              side: const BorderSide(color: Constants.kGreyLight),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildErro() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFF9F9F9F)),
            const SizedBox(height: 12),
            Text(
              store.errorMessage,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: Color(0xFF9F9F9F), fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: store.carregarRelatorio,
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Tentar novamente',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVazio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.area_chart_outlined,
                size: 64, color: Color(0xFFD9D9D9)),
            const SizedBox(height: 16),
            const Text(
              'Nenhum lote finalizado\nno período selecionado',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Color(0xFF9F9F9F)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lotes precisam ter data de colheita preenchida e dados de produção registrados.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFFD9D9D9)),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _abrirFiltros,
              icon: const Icon(Icons.tune_outlined, size: 16),
              label: const Text('Ajustar período'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Constants.kGreyText,
                side: const BorderSide(color: Constants.kGreyLight),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportarCSV() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exportação CSV em breve'),
        backgroundColor: Constants.kPrimaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatarData(String iso) {
    if (iso.isEmpty) return '';
    final parts = iso.split('-');
    if (parts.length < 3) return iso;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}

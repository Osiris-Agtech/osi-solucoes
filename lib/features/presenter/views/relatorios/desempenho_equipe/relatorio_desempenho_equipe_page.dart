import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/services/export_service.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/relatorio_desempenho_equipe_store.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/desempenho_equipe/widgets/desempenho_destaques_header.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/desempenho_equipe/widgets/desempenho_filtros_sheet.dart';
import 'package:osi_solucoes/features/presenter/views/relatorios/desempenho_equipe/widgets/desempenho_usuario_card.dart';

class RelatorioDesempenhoEquipePage extends StatefulWidget {
  const RelatorioDesempenhoEquipePage({super.key});

  @override
  State<RelatorioDesempenhoEquipePage> createState() =>
      _RelatorioDesempenhoEquipePageState();
}

class _RelatorioDesempenhoEquipePageState
    extends State<RelatorioDesempenhoEquipePage> {
  final RelatorioDesempenhoEquipeStore store =
      GetIt.I<RelatorioDesempenhoEquipeStore>();

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
        child: DesempenhoFiltrosSheet(
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
          'Desempenho da Equipe',
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
                style: const TextStyle(fontSize: 12, color: Color(0xFF9F9F9F)),
              ),
              const Spacer(),
              Text(
                '${resultado.totalUsuarios} membro${resultado.totalUsuarios != 1 ? 's' : ''}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF9F9F9F)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Destaques
        DesempenhoDestaquesHeader(
          resultado: resultado,
          membroMaisAtivo: store.membroMaisAtivo,
          membroMaiorConclusao: store.membroMaiorConclusao,
          membrosComAtrasos: store.membrosComAtrasos,
        ),
        // Label ranking
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            'RANKING POR MEMBRO',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF9F9F9F),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        // Cards por usuário
        ...resultado.usuarios.asMap().entries.map(
              (entry) => DesempenhoUsuarioCard(
                usuario: entry.value,
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
              style: const TextStyle(color: Color(0xFF9F9F9F), fontSize: 14),
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
            const Icon(Icons.people_outline,
                size: 64, color: Color(0xFFD9D9D9)),
            const SizedBox(height: 16),
            const Text(
              'Nenhum dado de equipe encontrado\nno período selecionado',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Color(0xFF9F9F9F)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Membros precisam ter atividades ou agendas registradas no período.',
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
    if (store.resultado == null) return;
    try {
      final exportService = GetIt.I<ExportService>();
      await exportService.exportarRelatorioDesempenhoCSV(store.resultado!);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao exportar: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String _formatarData(String iso) {
    if (iso.isEmpty) return '';
    final parts = iso.split('-');
    if (parts.length < 3) return iso;
    return '${parts[2].substring(0, 2)}/${parts[1]}/${parts[0]}';
  }
}

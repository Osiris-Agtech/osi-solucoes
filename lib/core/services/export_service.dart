// ignore_for_file: avoid_print

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_ciclo_cultura/relatorio_ciclo_cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_desempenho_equipe/relatorio_desempenho_equipe_model.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_agenda_tarefas/relatorio_agenda_tarefas_model.dart';

class ExportService {
  Future<void> exportarRelatorioCicloCSV(RelatorioCicloResult resultado) async {
    try {
      final linhas = <String>[];

      // Header
      linhas.add(
        'Cultura,Total Lotes,Duração Real Média (dias),Duração Planejada Média (dias),Desvio Médio (dias),Desvio Médio (%)',
      );

      // Dados por cultura
      for (final cultura in resultado.culturas) {
        final duracaoReal = cultura.duracaoRealMedia.toStringAsFixed(1);
        final duracaoPlan = cultura.duracaoPlanejadaMedia?.toStringAsFixed(1) ?? '';
        final desvioDias = cultura.desvioMedioDias?.toStringAsFixed(1) ?? '';
        final desvioPerc = cultura.desvioMedioPercentual?.toStringAsFixed(1) ?? '';

        linhas.add(
          '"${cultura.culturaNome}",${cultura.totalLotes},$duracaoReal,$duracaoPlan,$desvioDias,$desvioPerc',
        );
      }

      // Linha de totais
      linhas.add('');
      linhas.add('"Total","${resultado.totalLotes} lotes","Desvio geral: ${resultado.desvioMedioGeral.toStringAsFixed(1)}%"');
      linhas.add('"Período","${resultado.periodoInicio} a ${resultado.periodoFim}"');

      final csvContent = linhas.join('\n');

      // Salvar arquivo temporário
      final dir = await getTemporaryDirectory();
      final fileName = 'ciclo_producao_${_timestampSlug()}.csv';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(csvContent);

      print('📄 CSV gerado: ${file.path}');

      // Compartilhar
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'text/csv')],
        subject: 'Relatório de Ciclo de Produção por Cultura',
      );
    } catch (e) {
      print('❌ Erro ao exportar CSV: $e');
      rethrow;
    }
  }

  Future<void> exportarRelatorioDesempenhoCSV(
      RelatorioDesempenhoResult resultado) async {
    try {
      final linhas = <String>[];

      // Header
      linhas.add(
        'Membro,Total Atividades,Total Agendas,Agendas Finalizadas,Agendas no Prazo,Taxa Conclusão (%),Taxa no Prazo (%)',
      );

      // Dados por usuário
      for (final usuario in resultado.usuarios) {
        final taxaConclusao =
            usuario.taxaConclusao?.toStringAsFixed(1) ?? '';
        final taxaPrazo = usuario.taxaPrazo?.toStringAsFixed(1) ?? '';

        linhas.add(
          '"${usuario.usuarioNome}",${usuario.totalAtividades},${usuario.totalAgendas},${usuario.agendasFinalizadas},${usuario.agendasNoPrazo},$taxaConclusao,$taxaPrazo',
        );
      }

      // Linha de totais
      linhas.add('');
      linhas.add(
          '"Total","${resultado.totalUsuarios} membros","Média equipe: ${resultado.taxaConclusaoMedia.toStringAsFixed(1)}%"');
      linhas.add(
          '"Período","${resultado.periodoInicio} a ${resultado.periodoFim}"');

      final csvContent = linhas.join('\n');

      final dir = await getTemporaryDirectory();
      final fileName = 'desempenho_equipe_${_timestampSlug()}.csv';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(csvContent);

      print('📄 CSV de desempenho gerado: ${file.path}');

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'text/csv')],
        subject: 'Relatório de Desempenho da Equipe',
      );
    } catch (e) {
      print('❌ Erro ao exportar CSV de desempenho: $e');
      rethrow;
    }
  }

  Future<void> exportarRelatorioAgendaCSV(RelatorioAgendaResult resultado) async {
    try {
      final linhas = <String>[];

      // Sheet 1: Tarefas (vencidas + a vencer)
      linhas.add('--- TAREFAS ---');
      linhas.add('Status,Título,Prazo,Dias Atraso/Restantes,Alerta,Responsável,Lote,Setor');

      for (final t in resultado.tarefasVencidas) {
        final dias = t.calcularDiasAtraso();
        linhas.add(
          '"vencida","${_escapeCsv(t.displayTitulo)}","${t.data ?? ''}","$dias dias atraso","${t.alerta ? 'sim' : 'não'}","${t.usuarioNome ?? ''}","${t.loteNome ?? ''}","${t.setorNome ?? ''}"',
        );
      }

      for (final t in resultado.tarefasAVencer) {
        final dias = t.calcularDiasRestantes();
        linhas.add(
          '"a_vencer","${_escapeCsv(t.displayTitulo)}","${t.data ?? ''}","$dias dias restantes","${t.alerta ? 'sim' : 'não'}","${t.usuarioNome ?? ''}","${t.loteNome ?? ''}","${t.setorNome ?? ''}"',
        );
      }

      // Sheet 2: Taxa de conclusão por lote
      linhas.add('');
      linhas.add('--- CONCLUSÃO POR LOTE ---');
      linhas.add('Lote,Setor,Total Tarefas,Concluídas,Vencidas,Taxa Conclusão (%)');

      for (final l in resultado.lotesComTaxaConclusao) {
        linhas.add(
          '"${l.loteNome}","${l.setorNome ?? ''}",${l.totalTarefas},${l.tarefasConcluidas},${l.tarefasVencidas},${l.taxaConclusao.toStringAsFixed(1)}',
        );
      }

      linhas.add('');
      linhas.add('"Gerado em","${resultado.geradoEm}"');

      final csvContent = linhas.join('\n');

      final dir = await getTemporaryDirectory();
      final fileName = 'agenda_tarefas_${_timestampSlug()}.csv';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(csvContent);

      print('📄 CSV de agenda gerado: ${file.path}');

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'text/csv')],
        subject: 'Relatório de Agenda e Tarefas Pendentes',
      );
    } catch (e) {
      print('❌ Erro ao exportar CSV de agenda: $e');
      rethrow;
    }
  }

  String _escapeCsv(String value) => value.replaceAll('"', '""');

  String _timestampSlug() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  }
}

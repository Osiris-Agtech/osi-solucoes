// ignore_for_file: avoid_print

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/datasources/relatorio_agenda_tarefas/relatorio_agenda_tarefas_datasource.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_agenda_tarefas/relatorio_agenda_tarefas_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

part 'relatorio_agenda_tarefas_store.g.dart';

class RelatorioAgendaTarefasStore = RelatorioAgendaTarefasStoreBase
    with _$RelatorioAgendaTarefasStore;

abstract class RelatorioAgendaTarefasStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool hasError = false;

  @observable
  String errorMessage = '';

  @observable
  RelatorioAgendaResult? resultado;

  @observable
  RelatorioAgendaFiltros filtros = RelatorioAgendaFiltros.padrao();

  @computed
  bool get hasData =>
      resultado != null &&
      (resultado!.tarefasVencidas.isNotEmpty ||
          resultado!.tarefasAVencer.isNotEmpty ||
          resultado!.lotesComTaxaConclusao.isNotEmpty);

  @computed
  int get totalVencidas => resultado?.tarefasVencidas.length ?? 0;

  @computed
  bool get temVencidas => totalVencidas > 0;

  @computed
  AgendaLoteTaxaConclusao? get loteMaisCritico {
    if (resultado == null || resultado!.lotesComTaxaConclusao.isEmpty) return null;
    final comVencidas = resultado!.lotesComTaxaConclusao
        .where((l) => l.tarefasVencidas > 0)
        .toList();
    if (comVencidas.isEmpty) return null;
    comVencidas.sort((a, b) => b.tarefasVencidas.compareTo(a.tarefasVencidas));
    return comVencidas.first;
  }

  @computed
  String? get membroComMaisVencidas {
    if (resultado == null || resultado!.tarefasVencidas.isEmpty) return null;
    final contagem = <String, int>{};
    for (final t in resultado!.tarefasVencidas) {
      if (t.usuarioNome != null) {
        contagem[t.usuarioNome!] = (contagem[t.usuarioNome!] ?? 0) + 1;
      }
    }
    if (contagem.isEmpty) return null;
    return contagem.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
  }

  @action
  Future<void> carregarRelatorio() async {
    try {
      setLoading(true);
      setError(false, '');

      final AuthController authController = GetIt.I<AuthController>();
      final IRelatorioAgendaTarefasDatasource datasource =
          GetIt.I<IRelatorioAgendaTarefasDatasource>();

      final contaId = authController.usuario.selected_conta?.conta?.id ?? 0;

      if (contaId == 0) {
        setError(true, 'Conta não encontrada');
        return;
      }

      print('📋 Carregando relatório de agenda para conta: $contaId');

      final result = await datasource.buscarRelatorio(
        contaId: contaId,
        filtros: filtros,
      );

      result.fold(
        (failure) {
          print('❌ Falha ao carregar relatório: ${failure.message}');
          setError(true, failure.message);
        },
        (data) {
          setResultado(data);
          print(
            '✅ Agenda carregada: ${data.tarefasVencidas.length} vencidas, '
            '${data.tarefasAVencer.length} a vencer',
          );
        },
      );
    } catch (e) {
      print('❌ Erro inesperado ao carregar relatório: $e');
      setError(true, 'Erro inesperado: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> atualizarFiltros(RelatorioAgendaFiltros novosFiltros) async {
    filtros = novosFiltros;
    await carregarRelatorio();
  }

  @action
  void setLoading(bool value) => isLoading = value;

  @action
  void setError(bool hasErr, String message) {
    hasError = hasErr;
    errorMessage = message;
  }

  @action
  void setResultado(RelatorioAgendaResult data) => resultado = data;

  @action
  void limpar() {
    resultado = null;
    setError(false, '');
    filtros = RelatorioAgendaFiltros.padrao();
  }

  Future<void> carregarMock() async {
    setLoading(true);
    setError(false, '');
    await Future.delayed(const Duration(milliseconds: 600));
    setResultado(_buildMockResult());
    setLoading(false);
  }

  RelatorioAgendaResult _buildMockResult() {
    final hoje = DateTime.now();
    final isoHoje = hoje.toIso8601String();
    final iso3diasAtras = hoje.subtract(const Duration(days: 3)).toIso8601String();
    final iso7diasAtras = hoje.subtract(const Duration(days: 7)).toIso8601String();
    final iso1diasAtras = hoje.subtract(const Duration(days: 1)).toIso8601String();
    final iso2diasFrente = hoje.add(const Duration(days: 2)).toIso8601String();
    final iso4diasFrente = hoje.add(const Duration(days: 4)).toIso8601String();
    final iso6diasFrente = hoje.add(const Duration(days: 6)).toIso8601String();
    final iso1diaFrente = hoje.add(const Duration(days: 1)).toIso8601String();

    return RelatorioAgendaResult(
      diasAVencer: 7,
      geradoEm: isoHoje,
      tarefasVencidas: [
        AgendaTarefaItem(
          id: 1,
          titulo: 'Verificar pH do reservatório 2',
          data: iso7diasAtras,
          alerta: true,
          usuarioNome: 'Carlos Souza',
          usuarioId: 10,
          loteNome: 'Lote ALF-03',
          loteId: 403,
          setorNome: 'Setor B',
        ),
        AgendaTarefaItem(
          id: 2,
          titulo: 'Transplantio — Rúcula lote RUC-05',
          data: iso3diasAtras,
          alerta: false,
          usuarioNome: 'Ana Lima',
          usuarioId: 11,
          loteNome: 'Lote RUC-05',
          loteId: 502,
          setorNome: 'Setor A',
        ),
        AgendaTarefaItem(
          id: 3,
          titulo: 'Limpeza das bandejas de semeadura',
          data: iso1diasAtras,
          alerta: true,
          usuarioNome: 'Carlos Souza',
          usuarioId: 10,
          loteNome: null,
          loteId: null,
          setorNome: null,
        ),
      ],
      tarefasAVencer: [
        AgendaTarefaItem(
          id: 4,
          titulo: 'Colheita prevista — Espinafre ESP-06',
          data: iso1diaFrente,
          alerta: true,
          usuarioNome: 'Ana Lima',
          usuarioId: 11,
          loteNome: 'Lote ESP-06',
          loteId: 601,
          setorNome: 'Setor A',
        ),
        AgendaTarefaItem(
          id: 5,
          titulo: 'Controle de pragas — inspeção semanal',
          data: iso2diasFrente,
          alerta: false,
          usuarioNome: 'João Pedro',
          usuarioId: 12,
          loteNome: null,
          loteId: null,
          setorNome: null,
        ),
        AgendaTarefaItem(
          id: 6,
          titulo: 'Ajuste CE solução nutritiva Setor C',
          data: iso4diasFrente,
          alerta: false,
          usuarioNome: 'Carlos Souza',
          usuarioId: 10,
          loteNome: 'Lote MAN-07',
          loteId: 701,
          setorNome: 'Setor C',
        ),
        AgendaTarefaItem(
          id: 7,
          titulo: 'Semeadura programada — Alface Americana',
          data: iso6diasFrente,
          alerta: false,
          usuarioNome: 'Ana Lima',
          usuarioId: 11,
          loteNome: null,
          loteId: null,
          setorNome: null,
        ),
      ],
      lotesComTaxaConclusao: [
        const AgendaLoteTaxaConclusao(
          loteId: 403,
          loteNome: 'Lote ALF-03',
          setorNome: 'Setor B',
          totalTarefas: 8,
          tarefasConcluidas: 3,
          tarefasVencidas: 2,
          taxaConclusao: 37.5,
        ),
        const AgendaLoteTaxaConclusao(
          loteId: 502,
          loteNome: 'Lote RUC-05',
          setorNome: 'Setor A',
          totalTarefas: 6,
          tarefasConcluidas: 4,
          tarefasVencidas: 1,
          taxaConclusao: 66.7,
        ),
        const AgendaLoteTaxaConclusao(
          loteId: 601,
          loteNome: 'Lote ESP-06',
          setorNome: 'Setor A',
          totalTarefas: 5,
          tarefasConcluidas: 5,
          tarefasVencidas: 0,
          taxaConclusao: 100.0,
        ),
        const AgendaLoteTaxaConclusao(
          loteId: 701,
          loteNome: 'Lote MAN-07',
          setorNome: 'Setor C',
          totalTarefas: 4,
          tarefasConcluidas: 3,
          tarefasVencidas: 0,
          taxaConclusao: 75.0,
        ),
      ],
    );
  }
}

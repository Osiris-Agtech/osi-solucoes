// ignore_for_file: avoid_print

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/datasources/relatorio_desempenho_equipe/relatorio_desempenho_equipe_datasource.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_desempenho_equipe/relatorio_desempenho_equipe_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

import '../../../core/utils/toast.dart';

part 'relatorio_desempenho_equipe_store.g.dart';

class RelatorioDesempenhoEquipeStore = RelatorioDesempenhoEquipeStoreBase
    with _$RelatorioDesempenhoEquipeStore;

abstract class RelatorioDesempenhoEquipeStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool hasError = false;

  @observable
  String errorMessage = '';

  @observable
  RelatorioDesempenhoResult? resultado;

  @observable
  RelatorioDesempenhoFiltros filtros = RelatorioDesempenhoFiltros.ultimos6Meses();

  @computed
  bool get hasData => resultado != null && resultado!.usuarios.isNotEmpty;

  @computed
  DesempenhoUsuarioRanking? get membroMaisAtivo {
    if (!hasData) return null;
    return resultado!.usuarios.first; // já ordenado por totalAtividades desc
  }

  @computed
  DesempenhoUsuarioRanking? get membroMaiorConclusao {
    if (!hasData) return null;
    final comTaxa = resultado!.usuarios
        .where((u) => u.taxaConclusao != null)
        .toList();
    if (comTaxa.isEmpty) return null;
    comTaxa.sort((a, b) => b.taxaConclusao!.compareTo(a.taxaConclusao!));
    return comTaxa.first;
  }

  @computed
  List<DesempenhoUsuarioRanking> get membrosComAlerta {
    if (!hasData) return [];
    return resultado!.usuarios
        .where((u) => (u.taxaConclusao ?? 100) < 50)
        .toList();
  }

  @computed
  bool get equipeComBaixaConclusao {
    final media = resultado?.taxaConclusaoMedia ?? 100;
    return media < 60;
  }

  @computed
  List<DesempenhoUsuarioRanking> get membrosComAtrasos {
    if (!hasData) return [];
    return resultado!.usuarios
        .where((u) => u.taxaPrazo != null && u.taxaPrazo! < 50)
        .toList();
  }

  @action
  Future<void> carregarRelatorio() async {
    try {
      setLoading(true);
      setError(false, '');

      final AuthController authController = GetIt.I<AuthController>();
      final IRelatorioDesempenhoEquipeDatasource datasource =
          GetIt.I<IRelatorioDesempenhoEquipeDatasource>();

      final contaId = authController.usuario.selected_conta?.conta?.id ?? 0;

      if (contaId == 0) {
        setError(true, 'Conta não encontrada');
        return;
      }

      print('📊 Carregando relatório de desempenho para conta: $contaId');

      final result = await datasource.buscarRelatorio(
        contaId: contaId,
        filtros: filtros,
      );

      result.fold(
        (failure) {
          setError(true, failure.message);
          toastError(message: 'Erro ao carregar relatório: ${failure.message}');
        },
        (data) {
          setResultado(data);
          print(
              '✅ Relatório de desempenho carregado: ${data.totalUsuarios} usuários');
        },
      );
    } catch (e) {
      setError(true, 'Erro inesperado: ${e.toString()}');
      toastError(message: 'Erro inesperado ao carregar relatório');
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> atualizarFiltros(RelatorioDesempenhoFiltros novosFiltros) async {
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
  void setResultado(RelatorioDesempenhoResult data) => resultado = data;

  @action
  void limpar() {
    resultado = null;
    setError(false, '');
    filtros = RelatorioDesempenhoFiltros.ultimos6Meses();
  }

  Future<void> carregarMock() async {
    setLoading(true);
    setError(false, '');
    await Future.delayed(const Duration(milliseconds: 600));
    setResultado(_buildMockResult());
    setLoading(false);
  }

  RelatorioDesempenhoResult _buildMockResult() {
    return RelatorioDesempenhoResult(
      periodoInicio: '2024-09-01',
      periodoFim: '2025-03-01',
      totalUsuarios: 3,
      taxaConclusaoMedia: 62.3,
      usuarios: [
        DesempenhoUsuarioRanking(
          usuarioId: 1,
          usuarioNome: 'João Silva',
          totalAtividades: 34,
          totalAgendas: 15,
          agendasFinalizadas: 12,
          agendasNoPrazo: 11,
          taxaConclusao: 80.0,
          taxaPrazo: 91.7,
          ultimasAtividades: [
            const DesempenhoAtividadeItem(
              atividadeId: 1,
              atividadeNome: 'Transplantio',
              loteId: 101,
              loteNome: 'Lote ALF-01',
            ),
            const DesempenhoAtividadeItem(
              atividadeId: 2,
              atividadeNome: 'Aplicação de nutrientes',
              loteId: 102,
              loteNome: 'Lote RUC-03',
            ),
          ],
          agendasPendentes: [
            const DesempenhoAgendaItem(
              agendaId: 10,
              titulo: 'Verificar pH Setor A',
              data: '2025-02-28T08:00:00',
              finalizado: false,
              vencida: true,
            ),
          ],
        ),
        DesempenhoUsuarioRanking(
          usuarioId: 2,
          usuarioNome: 'Maria Souza',
          totalAtividades: 21,
          totalAgendas: 14,
          agendasFinalizadas: 7,
          agendasNoPrazo: 4,
          taxaConclusao: 50.0,
          taxaPrazo: 57.1,
          ultimasAtividades: [
            const DesempenhoAtividadeItem(
              atividadeId: 1,
              atividadeNome: 'Semeadura',
              loteId: 201,
              loteNome: 'Lote MAN-02',
            ),
          ],
          agendasPendentes: [
            const DesempenhoAgendaItem(
              agendaId: 20,
              titulo: 'Colheita programada',
              data: '2025-02-25T06:00:00',
              finalizado: false,
              vencida: true,
            ),
            const DesempenhoAgendaItem(
              agendaId: 21,
              titulo: 'Inspeção geral',
              data: '2025-03-10T09:00:00',
              finalizado: false,
              vencida: false,
            ),
          ],
        ),
        DesempenhoUsuarioRanking(
          usuarioId: 3,
          usuarioNome: 'Carlos Lima',
          totalAtividades: 8,
          totalAgendas: 10,
          agendasFinalizadas: 2,
          agendasNoPrazo: 2,
          taxaConclusao: 20.0,
          taxaPrazo: 100.0,
          ultimasAtividades: [
            const DesempenhoAtividadeItem(
              atividadeId: 3,
              atividadeNome: 'Colheita',
              loteId: 301,
              loteNome: 'Lote ESP-05',
            ),
          ],
          agendasPendentes: [],
        ),
      ],
    );
  }
}

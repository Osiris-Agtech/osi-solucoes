// ignore_for_file: avoid_print

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/datasources/relatorio_ciclo_cultura/relatorio_ciclo_cultura_datasource.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_ciclo_cultura/relatorio_ciclo_cultura_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

import '../../../core/utils/toast.dart';

part 'relatorio_ciclo_cultura_store.g.dart';

class RelatorioCicloCulturaStore = RelatorioCicloCulturaStoreBase
    with _$RelatorioCicloCulturaStore;

abstract class RelatorioCicloCulturaStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool hasError = false;

  @observable
  String errorMessage = '';

  @observable
  RelatorioCicloResult? resultado;

  @observable
  RelatorioCicloFiltros filtros = RelatorioCicloFiltros.ultimos6Meses();

  @computed
  bool get hasData => resultado != null && resultado!.culturas.isNotEmpty;

  @computed
  CicloRankingCultura? get melhorCultura {
    if (!hasData) return null;
    final comDesvio = resultado!.culturas
        .where((c) => c.desvioMedioPercentual != null)
        .toList();
    if (comDesvio.isEmpty) return null;
    return comDesvio.first; // já ordenado por desvio asc (menor = melhor)
  }

  @computed
  CicloRankingCultura? get piorCultura {
    if (!hasData) return null;
    final comDesvio = resultado!.culturas
        .where((c) => c.desvioMedioPercentual != null)
        .toList();
    if (comDesvio.isEmpty) return null;
    return comDesvio.last; // maior desvio = pior
  }

  @computed
  bool get temAtrasoRecorrente {
    final desvio = resultado?.desvioMedioGeral ?? 0;
    return desvio > 10;
  }

  @computed
  bool get producaoAdiantada {
    final desvio = resultado?.desvioMedioGeral ?? 0;
    return desvio < -5;
  }

  @action
  Future<void> carregarRelatorio() async {
    try {
      setLoading(true);
      setError(false, '');

      final AuthController authController = GetIt.I<AuthController>();
      final IRelatorioCicloCulturaDatasource datasource =
          GetIt.I<IRelatorioCicloCulturaDatasource>();

      final contaId = authController.usuario.selected_conta?.conta?.id ?? 0;

      if (contaId == 0) {
        setError(true, 'Conta não encontrada');
        return;
      }

      print('📊 Carregando relatório de ciclo para conta: $contaId');

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
          print('✅ Relatório carregado: ${data.totalLotes} lotes, ${data.culturas.length} culturas');
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
  Future<void> atualizarFiltros(RelatorioCicloFiltros novosFiltros) async {
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
  void setResultado(RelatorioCicloResult data) => resultado = data;

  @action
  void limpar() {
    resultado = null;
    setError(false, '');
    filtros = RelatorioCicloFiltros.ultimos6Meses();
  }

  Future<void> carregarMock() async {
    setLoading(true);
    setError(false, '');
    await Future.delayed(const Duration(milliseconds: 600));
    setResultado(_buildMockResult());
    setLoading(false);
  }

  RelatorioCicloResult _buildMockResult() {
    return RelatorioCicloResult(
      periodoInicio: '2024-09-01',
      periodoFim: '2025-03-01',
      totalLotes: 14,
      desvioMedioGeral: 8.2,
      culturas: [
        CicloRankingCultura(
          culturaId: 1,
          culturaNome: 'Espinafre',
          totalLotes: 4,
          duracaoRealMedia: 22,
          duracaoPlanejadaMedia: 25,
          desvioMedioDias: -3,
          desvioMedioPercentual: -12.0,
          desvioMaxDias: -1,
          desvioMinDias: -5,
          lotes: [
            const CicloLoteDetalhe(
              loteId: 101, loteNome: 'Lote ESP-01',
              semeaduraData: '2024-10-01', colheitaData: '2024-10-23',
              duracaoRealDias: 22, duracaoPlanejadaDias: 25,
              desvioDias: -3, desvioPercentual: -12.0,
              setorNome: 'Setor A', areaNome: 'Estufa Principal',
            ),
            const CicloLoteDetalhe(
              loteId: 102, loteNome: 'Lote ESP-02',
              semeaduraData: '2024-11-01', colheitaData: '2024-11-22',
              duracaoRealDias: 21, duracaoPlanejadaDias: 25,
              desvioDias: -4, desvioPercentual: -16.0,
              setorNome: 'Setor B', areaNome: 'Estufa Principal',
            ),
          ],
        ),
        CicloRankingCultura(
          culturaId: 2,
          culturaNome: 'Rúcula',
          totalLotes: 3,
          duracaoRealMedia: 38,
          duracaoPlanejadaMedia: 35,
          desvioMedioDias: 3,
          desvioMedioPercentual: 8.6,
          desvioMaxDias: 5,
          desvioMinDias: 1,
          lotes: [
            const CicloLoteDetalhe(
              loteId: 201, loteNome: 'Lote RUC-01',
              semeaduraData: '2024-09-05', colheitaData: '2024-10-13',
              duracaoRealDias: 38, duracaoPlanejadaDias: 35,
              desvioDias: 3, desvioPercentual: 8.6,
              setorNome: 'Setor C', areaNome: 'Estufa Norte',
            ),
            const CicloLoteDetalhe(
              loteId: 202, loteNome: 'Lote RUC-02',
              semeaduraData: '2024-11-15', colheitaData: '2024-12-25',
              duracaoRealDias: 40, duracaoPlanejadaDias: 35,
              desvioDias: 5, desvioPercentual: 14.3,
              setorNome: 'Setor A', areaNome: 'Estufa Principal',
            ),
          ],
        ),
        CicloRankingCultura(
          culturaId: 3,
          culturaNome: 'Manjericão',
          totalLotes: 2,
          duracaoRealMedia: 55,
          duracaoPlanejadaMedia: 50,
          desvioMedioDias: 5,
          desvioMedioPercentual: 10.0,
          desvioMaxDias: 7,
          desvioMinDias: 3,
          lotes: [
            const CicloLoteDetalhe(
              loteId: 301, loteNome: 'Lote MAN-01',
              semeaduraData: '2024-08-01', colheitaData: '2024-09-25',
              duracaoRealDias: 55, duracaoPlanejadaDias: 50,
              desvioDias: 5, desvioPercentual: 10.0,
              setorNome: 'Setor B', areaNome: 'Estufa Norte',
            ),
          ],
        ),
        CicloRankingCultura(
          culturaId: 4,
          culturaNome: 'Alface Crespa',
          totalLotes: 5,
          duracaoRealMedia: 32,
          duracaoPlanejadaMedia: 28,
          desvioMedioDias: 4,
          desvioMedioPercentual: 14.3,
          desvioMaxDias: 8,
          desvioMinDias: 2,
          lotes: [
            const CicloLoteDetalhe(
              loteId: 401, loteNome: 'Lote ALF-01',
              semeaduraData: '2024-10-10', colheitaData: '2024-11-18',
              duracaoRealDias: 39, duracaoPlanejadaDias: 28,
              desvioDias: 11, desvioPercentual: 39.3,
              setorNome: 'Setor A', areaNome: 'Estufa Principal',
            ),
            const CicloLoteDetalhe(
              loteId: 402, loteNome: 'Lote ALF-02',
              semeaduraData: '2024-12-01', colheitaData: '2025-01-05',
              duracaoRealDias: 35, duracaoPlanejadaDias: 28,
              desvioDias: 7, desvioPercentual: 25.0,
              setorNome: 'Setor D', areaNome: 'Estufa Sul',
            ),
            const CicloLoteDetalhe(
              loteId: 403, loteNome: 'Lote ALF-03',
              semeaduraData: '2025-01-15', colheitaData: '2025-02-16',
              duracaoRealDias: 32, duracaoPlanejadaDias: 28,
              desvioDias: 4, desvioPercentual: 14.3,
              setorNome: 'Setor B', areaNome: 'Estufa Principal',
            ),
          ],
        ),
      ],
    );
  }
}

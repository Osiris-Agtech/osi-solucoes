// ignore_for_file: avoid_print

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/datasources/relatorio_produtividade_setor/relatorio_produtividade_setor_datasource.dart';
import 'package:osi_solucoes/features/presenter/models/relatorio_produtividade_setor/relatorio_produtividade_setor_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

import '../../../core/utils/toast.dart';

part 'relatorio_produtividade_setor_store.g.dart';

class RelatorioProdutividadeSetorStore = RelatorioProdutividadeSetorStoreBase
    with _$RelatorioProdutividadeSetorStore;

abstract class RelatorioProdutividadeSetorStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool hasError = false;

  @observable
  String errorMessage = '';

  @observable
  RelatorioProdutividadeResult? resultado;

  @observable
  RelatorioProdutividadeFiltros filtros = RelatorioProdutividadeFiltros.ultimos6Meses();

  @computed
  bool get hasData => resultado != null && resultado!.setores.isNotEmpty;

  @computed
  ProdutividadeSetorRanking? get melhorSetor {
    if (!hasData) return null;
    final comTaxa = resultado!.setores
        .where((s) => s.taxaGlobal != null)
        .toList();
    if (comTaxa.isEmpty) return null;
    return comTaxa.first; // já ordenado por taxaGlobal desc
  }

  @computed
  ProdutividadeSetorRanking? get piorSetor {
    if (!hasData) return null;
    final comTaxa = resultado!.setores
        .where((s) => s.taxaGlobal != null)
        .toList();
    if (comTaxa.isEmpty) return null;
    return comTaxa.last;
  }

  /// Identifica a etapa com a menor taxa média entre os setores.
  /// Retorna: 'transplantio', 'embalagem', ou null (dados insuficientes).
  @computed
  String? get etapaGargalo {
    if (!hasData) return null;

    final comDados = resultado!.setores
        .where((s) => s.taxaTransplantio != null && s.taxaEmbalagem != null)
        .toList();
    if (comDados.isEmpty) return null;

    final mediaTransplantio =
        comDados.map((s) => s.taxaTransplantio!).reduce((a, b) => a + b) /
            comDados.length;
    final mediaEmbalagem =
        comDados.map((s) => s.taxaEmbalagem!).reduce((a, b) => a + b) /
            comDados.length;

    if (mediaTransplantio < mediaEmbalagem) return 'transplantio';
    if (mediaEmbalagem < mediaTransplantio) return 'embalagem';
    return null;
  }

  @action
  Future<void> carregarRelatorio() async {
    try {
      setLoading(true);
      setError(false, '');

      final AuthController authController = GetIt.I<AuthController>();
      final IRelatorioProdutividadeSetorDatasource datasource =
          GetIt.I<IRelatorioProdutividadeSetorDatasource>();

      final contaId = authController.usuario.selected_conta?.conta?.id ?? 0;

      if (contaId == 0) {
        setError(true, 'Conta não encontrada');
        return;
      }

      print('📊 Carregando relatório de produtividade para conta: $contaId');

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
          print('✅ Relatório de produtividade carregado: ${data.totalLotes} lotes, ${data.setores.length} setores');
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
  Future<void> atualizarFiltros(RelatorioProdutividadeFiltros novosFiltros) async {
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
  void setResultado(RelatorioProdutividadeResult data) => resultado = data;

  @action
  void limpar() {
    resultado = null;
    setError(false, '');
    filtros = RelatorioProdutividadeFiltros.ultimos6Meses();
  }

  Future<void> carregarMock() async {
    setLoading(true);
    setError(false, '');
    await Future.delayed(const Duration(milliseconds: 600));
    setResultado(_buildMockResult());
    setLoading(false);
  }

  RelatorioProdutividadeResult _buildMockResult() {
    return RelatorioProdutividadeResult(
      periodoInicio: '2024-09-01',
      periodoFim: '2025-03-01',
      totalLotes: 18,
      taxaGlobalMedia: 3.4,
      setores: [
        ProdutividadeSetorRanking(
          setorId: 1,
          setorNome: 'Setor A',
          areaNome: 'Estufa Principal',
          totalLotes: 8,
          totalBandejasSemeadas: 480,
          totalMudasTransplantadas: 2016,
          totalPlantasColhidas: 1853,
          totalEmbalagensProduzidas: 1798,
          taxaGerminacao: 4.2,
          taxaTransplantio: 91.9,
          taxaEmbalagem: 97.0,
          taxaGlobal: 3.75,
          areas: [
            const ProdutividadeAreaDetalhe(
              areaId: 1,
              areaNome: 'Estufa Principal',
              totalLotes: 8,
              totalBandejasSemeadas: 480,
              totalMudasTransplantadas: 2016,
              totalPlantasColhidas: 1853,
              totalEmbalagensProduzidas: 1798,
              taxaGerminacao: 4.2,
              taxaTransplantio: 91.9,
              taxaEmbalagem: 97.0,
              taxaGlobal: 3.75,
            ),
          ],
        ),
        ProdutividadeSetorRanking(
          setorId: 2,
          setorNome: 'Setor B',
          areaNome: 'Estufa Norte',
          totalLotes: 6,
          totalBandejasSemeadas: 320,
          totalMudasTransplantadas: 1216,
          totalPlantasColhidas: 827,
          totalEmbalagensProduzidas: 793,
          taxaGerminacao: 3.8,
          taxaTransplantio: 68.0,
          taxaEmbalagem: 95.9,
          taxaGlobal: 2.48,
          areas: [
            const ProdutividadeAreaDetalhe(
              areaId: 2,
              areaNome: 'Estufa Norte',
              totalLotes: 6,
              totalBandejasSemeadas: 320,
              totalMudasTransplantadas: 1216,
              totalPlantasColhidas: 827,
              totalEmbalagensProduzidas: 793,
              taxaGerminacao: 3.8,
              taxaTransplantio: 68.0,
              taxaEmbalagem: 95.9,
              taxaGlobal: 2.48,
            ),
          ],
        ),
        ProdutividadeSetorRanking(
          setorId: 3,
          setorNome: 'Setor C',
          areaNome: 'Estufa Sul',
          totalLotes: 4,
          totalBandejasSemeadas: 200,
          totalMudasTransplantadas: 700,
          totalPlantasColhidas: 336,
          totalEmbalagensProduzidas: 269,
          taxaGerminacao: 3.5,
          taxaTransplantio: 48.0,
          taxaEmbalagem: 80.1,
          taxaGlobal: 1.35,
          areas: [
            const ProdutividadeAreaDetalhe(
              areaId: 3,
              areaNome: 'Estufa Sul',
              totalLotes: 4,
              totalBandejasSemeadas: 200,
              totalMudasTransplantadas: 700,
              totalPlantasColhidas: 336,
              totalEmbalagensProduzidas: 269,
              taxaGerminacao: 3.5,
              taxaTransplantio: 48.0,
              taxaEmbalagem: 80.1,
              taxaGlobal: 1.35,
            ),
          ],
        ),
      ],
    );
  }
}

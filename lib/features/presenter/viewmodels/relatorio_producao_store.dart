import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/repositories/relatorioProducao/relatorioProducao_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/relatorioProducao/relatorioProducao_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';

import '../../../core/utils/toast.dart';

part 'relatorio_producao_store.g.dart';

class RelatorioProducaoStore = RelatorioProducaoStoreBase
    with _$RelatorioProducaoStore;

abstract class RelatorioProducaoStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool hasError = false;

  @observable
  String errorMessage = '';

  @observable
  RelatorioProducao? relatorioData;

  @observable
  List<CultureData> widgetData = [];

  // Computed para converter os dados do modelo para o widget
  @computed
  List<CultureData> get cultureData {
    if (relatorioData?.cultureData == null) return [];

    return relatorioData!.cultureData!.map((culture) {
      return CultureData(
        name: culture.name ?? '',
        value: culture.value ?? 0.0,
        color: culture.color,
      );
    }).toList();
  }

  @computed
  String get reportTitle => relatorioData?.title ?? 'Produção por Cultura';

  @computed
  String get reportSubtitle => relatorioData?.subtitle ?? 'Últimos meses';

  @computed
  String get totalUnit => relatorioData?.totalUnit ?? 'plantas';

  @computed
  List<String> get months => relatorioData?.months ?? [];

  @computed
  List<double> get monthlyData => relatorioData?.monthlyData ?? [];

  @computed
  bool get hasData => relatorioData != null && cultureData.isNotEmpty;

  @computed
  double get totalProduction {
    if (relatorioData?.cultureData == null) return 0.0;
    return relatorioData!.cultureData!.fold<double>(
      0.0,
      (sum, culture) => sum + (culture.value ?? 0.0),
    );
  }

  @action
  Future<void> buscarRelatorioProducao() async {
    try {
      setLoading(true);
      setError(false, '');

      final AuthController authController = GetIt.I<AuthController>();
      final IRelatorioProducaoRepository repository =
          GetIt.I<IRelatorioProducaoRepository>();

      final int finalContaId =
          authController.usuario.selected_conta?.conta?.id ?? 0;

      if (finalContaId == 0) {
        setError(true, 'Conta não encontrada');
        return;
      }

      final result = await repository.buscarRelatorioProducao(finalContaId);

      result.fold(
        (failure) {
          setError(true, failure.message);
          toastError(message: 'Erro ao carregar relatório: ${failure.message}');
        },
        (data) {
          setRelatorioData(data);
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
  void setLoading(bool value) {
    isLoading = value;
  }

  @action
  void setError(bool hasErr, String message) {
    hasError = hasErr;
    errorMessage = message;
  }

  @action
  void setRelatorioData(RelatorioProducao data) {
    relatorioData = data;
  }

  @action
  void clearData() {
    relatorioData = null;
    widgetData.clear();
    setError(false, '');
  }

  @action
  Future<void> refreshData() async {
    await buscarRelatorioProducao();
  }

  // Métodos auxiliares
  // ignore: unused_element
  Color _parseColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) {
      return const Color(0xFF059669); // Cor padrão
    }

    try {
      String hex = colorHex.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex'; // Adiciona alpha
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return const Color(0xFF059669); // Cor padrão em caso de erro
    }
  }

  // Método para mapear nomes de cultura para cores específicas (fallback)
  // ignore: unused_element
  Color _getColorForCulture(String cultureName) {
    switch (cultureName.toLowerCase()) {
      case 'alface':
        return const Color(0xFF059669);
      case 'rúcula':
      case 'rucula':
        return const Color(0xFF8B5CF6);
      case 'tomate':
        return const Color(0xFFEF4444);
      case 'cenoura':
        return const Color(0xFFF59E0B);
      case 'pepino':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  // Método para obter estatísticas resumidas
  @computed
  Map<String, dynamic> get estatisticasResumo {
    if (relatorioData?.cultureData == null) return {};

    final culturas = relatorioData!.cultureData!;
    final culturaMaisProducao = culturas.isNotEmpty
        ? culturas.reduce((a, b) => (a.value ?? 0) > (b.value ?? 0) ? a : b)
        : null;

    return {
      'totalCulturas': culturas.length,
      'totalProducao': totalProduction,
      'culturaMaisProducao': culturaMaisProducao?.name ?? 'N/A',
      'valorMaisProducao': culturaMaisProducao?.value ?? 0.0,
      'unidade': totalUnit,
    };
  }

  @computed
  double get mediaProducaoMensal {
    if (monthlyData.isEmpty) return 0.0;
    return monthlyData.reduce((a, b) => a + b) / monthlyData.length;
  }
}

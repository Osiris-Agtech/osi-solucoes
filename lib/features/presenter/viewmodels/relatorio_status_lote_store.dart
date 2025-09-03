import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:osi_solucoes/features/data/repositories/relatorioStatusLotes/relatorioStatusLote_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/relatorioStatusLotes/relatorioStatusLotes_model.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/lot_status_metrics_widget_clean.dart';

import '../../../core/utils/toast.dart';

part 'relatorio_status_lote_store.g.dart';

class RelatorioStatusLoteStore = _RelatorioStatusLoteStoreBase
    with _$RelatorioStatusLoteStore;

abstract class _RelatorioStatusLoteStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool hasError = false;

  @observable
  String errorMessage = '';

  @observable
  RelatorioStatusLotes? relatorioData;

  @observable
  List<LotStatusData> widgetData = [];

  // Computed para converter os dados do modelo para o widget
  @computed
  List<LotStatusData> get lotStatusData {
    if (relatorioData?.statusData == null) return [];

    return relatorioData!.statusData!.map((statusData) {
      return LotStatusData(
        label: statusData.label ?? '',
        value: statusData.value ?? 0,
        color: _parseColor(statusData.color),
        speciesDetails: statusData.speciesDetails?.map((species) {
          return SpeciesInfo(
            name: species.name ?? '',
            lotCount: _calculateLotCount(
                statusData.value ?? 0, species.percentage ?? 0),
            percentage: species.percentage ?? 0,
          );
        }).toList(),
      );
    }).toList();
  }

  @computed
  String get reportTitle => relatorioData?.title ?? 'Status dos Lotes';

  @computed
  String get reportSubtitle => relatorioData?.subtitle ?? 'Situação atual';

  @computed
  bool get hasData => relatorioData != null && lotStatusData.isNotEmpty;

  @action
  Future<void> buscarRelatorioStatusLotes({int? contaId}) async {
    try {
      setLoading(true);
      setError(false, '');

      final AuthController authController = GetIt.I<AuthController>();
      final IRelatorioStatusLoteRepository repository =
          GetIt.I<IRelatorioStatusLoteRepository>();

      final int finalContaId =
          contaId ?? authController.usuario.selected_conta?.conta?.id ?? 0;

      if (finalContaId == 0) {
        setError(true, 'Conta não encontrada');
        return;
      }

      final result = await repository.buscarRelatorioStatusLotes(finalContaId);

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
  void setRelatorioData(RelatorioStatusLotes data) {
    relatorioData = data;
  }

  @action
  void clearData() {
    relatorioData = null;
    widgetData.clear();
    setError(false, '');
  }

  @action
  Future<void> refreshData({int? contaId}) async {
    await buscarRelatorioStatusLotes(contaId: contaId);
  }

  // Métodos auxiliares
  Color _parseColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) {
      return const Color(0xFF059669); // Cor padrão
    }

    try {
      String hex = colorHex.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF' + hex; // Adiciona alpha
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return const Color(0xFF059669); // Cor padrão em caso de erro
    }
  }

  int _calculateLotCount(int totalValue, double percentage) {
    if (percentage == 0) return 0;
    return (totalValue * percentage / 100).round();
  }

  // Método para mapear labels para cores específicas
  Color _getColorForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'ativos':
      case 'ativo':
        return const Color(0xFF059669);
      case 'finalizados':
      case 'finalizado':
        return const Color(0xFF6B7280);
      case 'suspensos':
      case 'suspenso':
        return const Color(0xFFF59E0B);
      case 'cancelados':
      case 'cancelado':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  // Método para obter estatísticas resumidas
  @computed
  Map<String, int> get estatisticasResumo {
    int totalLotes = 0;
    int lotesAtivos = 0;
    int lotesFinalizados = 0;

    for (var status in lotStatusData) {
      totalLotes += status.value;

      if (status.label.toLowerCase().contains('ativo')) {
        lotesAtivos += status.value;
      } else if (status.label.toLowerCase().contains('finalizado')) {
        lotesFinalizados += status.value;
      }
    }

    return {
      'total': totalLotes,
      'ativos': lotesAtivos,
      'finalizados': lotesFinalizados,
      'outros': totalLotes - lotesAtivos - lotesFinalizados,
    };
  }

  @computed
  double get percentualConclusao {
    final stats = estatisticasResumo;
    final total = stats['total'] ?? 0;
    final finalizados = stats['finalizados'] ?? 0;

    if (total == 0) return 0.0;
    return (finalizados / total) * 100;
  }
}

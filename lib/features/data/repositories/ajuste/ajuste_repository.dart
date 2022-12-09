import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/data/datasources/ajuste/ajuste_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/ajuste/ajuste_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/atividade/atividade_model.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';

class AjusteRepository implements IAjusteRepository {
  final IAjusteDatasource datasource;
  AjusteRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(
      int contaId) async {
    var result = await datasource.buscarReservatorios(contaId: contaId);

    return result;
  }

  @override
  Future<Either<Failure, Atividade>> salvarAjuste(
      Atividade atividade, int usuarioId, List<int> listLoteId) async {
    var result = await datasource.salvarAjuste(
        atividade: atividade, usuarioId: usuarioId, listLoteId: listLoteId);
    return result;
  }
}

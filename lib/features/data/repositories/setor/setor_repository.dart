import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/datasources/setor/setor_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/setor/setor_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';

class SetorRepository implements ISetorRepository {
  final ISetorDatasource datasource;
  SetorRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<Setor>>> buscarSetores(
    int areaId,
    String orderBy,
    String order,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    var result = await datasource.buscarSetores(
      areaId: areaId,
      orderBy: orderBy,
      order: order,
      startDate: startDate,
      endDate: endDate,
    );

    return result;
  }

  @override
  Future<Either<Failure, Setor>> cadastrarSetor(Setor setor) async {
    var result = await datasource.cadastrarSetor(setor: setor);

    return result;
  }

  @override
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(
      int contaId) async {
    var result = await datasource.buscarReservatorios(contaId: contaId);

    return result;
  }

  @override
  Future<Either<Failure, bool>> deletarSetorCascade(int setorId) async {
    var result = await datasource.deletarSetorCascade(setorId: setorId);
    return result;
  }

  @override
  Future<Either<Failure, Setor>> alterarSetor(Setor alterarSetor) async {
    var result = await datasource.alterarSetor(alterarSetor: alterarSetor);

    return result;
  }
}

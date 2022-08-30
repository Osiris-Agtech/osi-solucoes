import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/datasources/setor/setor_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/setor/setor_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';

class SetorRepository implements ISetorRepository {
  final ISetorDatasource datasource;
  SetorRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<Setor>>> buscarSetores(int areaId) async {
    var result = await datasource.buscarSetores(areaId: areaId);

    return result;
  }
}

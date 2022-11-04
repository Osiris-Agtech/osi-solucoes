import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/datasources/cadernoCampo/caderno_campo_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/cadernoCampo/caderno_campo_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';

class CadernoCampoRepository implements ICadernoCampoRepository {
  final ICadernoCampoDatasource datasource;
  CadernoCampoRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<Lote>>> buscarLotesByConta(int contaId) async {
    var result = await datasource.buscarLotesByConta(contaId: contaId); //mudar
    return result;
  }

  @override
  Future<Either<Failure, List<Lote>>> buscarLotesBySetor(int setorId) async {
    var result = await datasource.buscarLotesBySetor(setorId: setorId); //mudar
    return result;
  }

  @override
  Future<Either<Failure, List<Lote>>> buscarLotesByArea(int areaId) async {
    var result = await datasource.buscarLotesByArea(areaId: areaId); //mudar
    return result;
  }

  @override
  Future<Either<Failure, List<Area>>> buscarAreasList(int contaId) async {
    var result = await datasource.buscarAreasList(contaId: contaId);
    return result;
  }

  @override
  Future<Either<Failure, Lote>> buscarAtividades(int loteId) async {
    var result = await datasource.buscarAtividades(loteId: loteId);
    return result;
  }
}

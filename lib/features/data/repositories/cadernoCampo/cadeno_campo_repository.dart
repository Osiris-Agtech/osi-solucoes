import 'package:dartz/dartz.dart';
import 'package:sigma_hort_gestao_equipe/core/errors/failure.dart';
import 'package:sigma_hort_gestao_equipe/features/data/datasources/cadernoCampo/caderno_campo_datasource.dart';
import 'package:sigma_hort_gestao_equipe/features/data/repositories/cadernoCampo/caderno_campo_repository_interface.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/area/area_model.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/atividade/atividade_model.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/lote/lote_model.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/usuario/usuario_model.dart';

class CadernoCampoRepository implements ICadernoCampoRepository {
  final ICadernoCampoDatasource datasource;
  CadernoCampoRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<Usuario>>> buscarUsuariosConta(
      int contaId) async {
    var result =
        await datasource.buscarUsuariosByConta(contaId: contaId); //mudar
    return result;
  }

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

  @override
  Future<Either<Failure, Atividade>> cadastrarAtividade({
    required Atividade atividade,
    required int usuarioId,
    required List<int> listLoteId,
  }) async {
    var result = await datasource.cadastrarAtividade(
      atividade: atividade,
      usuarioId: usuarioId,
      listLoteId: listLoteId,
    );
    return result;
  }
}

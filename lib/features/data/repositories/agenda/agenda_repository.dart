import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/data/datasources/agenda/agenda_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/agenda/agenda_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';

class AgendaRepository implements IAgendaRepository {
  final IAgendaDatasource datasource;
  AgendaRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<Agenda>>> buscarAtividades(int contaId) async {
    var result = await datasource.buscarAtividades(contaId);

    return result;
  }

  @override
  Future<Either<Failure, List<Lote>>> buscarLotesConta(int contaId) async {
    var result = await datasource.buscarLotesConta(contaId);

    return result;
  }

  @override
  Future<Either<Failure, Agenda>> editarAtividade(Agenda agenda) async {
    var result = await datasource.editarAtividade(agenda);

    return result;
  }

  @override
  Future<Either<Failure, Agenda>> cadastrarAtividade(Agenda agenda) async {
    var result = await datasource.cadastrarAtividade(agenda);

    return result;
  }

  @override
  Future<Either<Failure, Agenda>> deletarAtividade(int id) async {
    var result = await datasource.deletarAtividade(id);

    return result;
  }

  @override
  Future<Either<Failure, Agenda>> marcarComoFeito(int id) async {
    var result = await datasource.marcarComoFeito(id);

    return result;
  }
}

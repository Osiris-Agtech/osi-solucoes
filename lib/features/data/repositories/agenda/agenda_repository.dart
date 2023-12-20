import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/data/datasources/agenda/agenda_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/agenda/agenda_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';

class AgendaRepository implements IAgendaRepository {
  final IAgendaDatasource datasource;
  AgendaRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<Acao>>> buscarAcoes() async {
    var result = await datasource.buscarAcoes();

    return result;
  }
}

import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import '../../../../core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class IAgendaRepository {
  Future<Either<Failure, List<Agenda>>> buscarAtividades();
  Future<Either<Failure, Agenda>> editarAtividade(Agenda agenda);
  Future<Either<Failure, Agenda>> deletarAtividade(int id);
  Future<Either<Failure, Agenda>> cadastrarAtividade(Agenda agenda);
  Future<Either<Failure, Agenda>> marcarComoFeito(int id);
}

import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import '../../../../core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class IAgendaRepository {
  Future<Either<Failure, List<Agenda>>> buscarAtividades();
}

import 'package:osi_solucoes/features/presenter/models/agenda/agenda_model.dart';
import '../../../../core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../presenter/models/lote/lote_model.dart';

abstract class IAgendaRepository {
  Future<Either<Failure, List<Agenda>>> buscarAtividades(int contaId);
  Future<Either<Failure, Agenda>> editarAtividade(Agenda agenda);
  Future<Either<Failure, Agenda>> deletarAtividade(int id);
  Future<Either<Failure, Agenda>> cadastrarAtividade(Agenda agenda);
  Future<Either<Failure, Agenda>> marcarComoFeito(int id);
  Future<Either<Failure, List<Lote>>> buscarLotesConta(int contaId);
}

import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';
import '../../../../core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class IAgendaRepository {
  Future<Either<Failure, List<Acao>>> buscarAcoes();
}

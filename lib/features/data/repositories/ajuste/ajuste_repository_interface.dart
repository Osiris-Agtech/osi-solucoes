import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';

abstract class IAjusteRepository {
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(int contaId);
}

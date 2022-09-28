import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';

import '../../../../core/errors/failure.dart';

abstract class ISetorRepository {
  Future<Either<Failure, List<Setor>>> buscarSetores(int areaId);
  Future<Either<Failure, Setor>> cadastrarSetor(Setor setor);
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(int contaId);
}
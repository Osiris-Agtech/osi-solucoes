import 'package:dartz/dartz.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/setor/setor_model.dart';

import '../../../../core/errors/failure.dart';

abstract class ISetorRepository {
  Future<Either<Failure, List<Setor>>> buscarSetores(
    int areaId,
    String orderBy,
    String order,
    DateTime? startDate,
    DateTime? endDate,
  );
  Future<Either<Failure, Setor>> cadastrarSetor(Setor setor);
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(int contaId);
  Future<Either<Failure, Setor>> alterarSetor(Setor alterarSetor);
}

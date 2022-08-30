import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';

import '../../../../core/errors/failure.dart';

abstract class ISetorRepository {
  Future<Either<Failure, List<Setor>>> buscarSetores(int areaId);
}

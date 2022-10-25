import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';

import '../../../../core/errors/failure.dart';

abstract class ICadernoCampoRepository {
  Future<Either<Failure, List<Lote>>> buscarLotesByConta(int contaId);
}

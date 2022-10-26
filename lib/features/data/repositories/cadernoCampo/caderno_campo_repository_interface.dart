import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';

import '../../../../core/errors/failure.dart';

abstract class ICadernoCampoRepository {
  Future<Either<Failure, List<Lote>>> buscarLotesByConta(int contaId);
  Future<Either<Failure, List<Lote>>> buscarLotesBySetor(int setorId);
  Future<Either<Failure, List<Lote>>> buscarLotesByArea(int areaId);
  Future<Either<Failure, List<Area>>> buscarAreasList(int contaId);
}

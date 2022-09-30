import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';

import '../../../../core/errors/failure.dart';

abstract class ILoteRepository {
  Future<Either<Failure, List<Lote>>> buscarLotes(int setorId);
  Future<Either<Failure, Lote>> buscarDetalhesLote(int loteId);
}

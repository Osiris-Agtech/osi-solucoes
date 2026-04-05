import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/relatorioStatusLotes/relatorioStatusLotes_model.dart';

abstract class IRelatorioStatusLoteRepository {
  Future<Either<Failure, RelatorioStatusLotes>> buscarRelatorioStatusLotes(
    int contaId,
  );
}

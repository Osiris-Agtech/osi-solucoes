import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/relatorioStatusLotes/relatorioStatusLotes_model.dart';

import '../../datasources/relatorioStatusLotes/relatorioStatusLotes_datasource.dart';
import 'relatorioStatusLote_repository_interface.dart';

class RelatorioStatusLoteRepository implements IRelatorioStatusLoteRepository {
  final IRelatorioStatusLotesDatasource datasource;

  RelatorioStatusLoteRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, RelatorioStatusLotes>> buscarRelatorioStatusLotes(
    int contaId,
  ) async {
    try {
      var result = await datasource.buscarRelatorioStatusLotes(
        contaId: contaId,
      );

      return result;
    } catch (e) {
      return Left(ErrorRelatorioStatusLotes(
        message: 'Erro no repository ao buscar relatório: ${e.toString()}',
      ));
    }
  }
}

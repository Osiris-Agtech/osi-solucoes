import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/relatorioProducao/relatorioProducao_model.dart';

import '../../datasources/relatorioProducao/relatorioProducao_datasource.dart';
import 'relatorioProducao_repository_interface.dart';

class RelatorioProducaoRepository implements IRelatorioProducaoRepository {
  final IRelatorioProducaoDatasource datasource;

  RelatorioProducaoRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, RelatorioProducao>> buscarRelatorioProducao(
    int contaId,
  ) async {
    try {
      var result = await datasource.buscarRelatorioProducao(
        contaId: contaId,
      );

      return result.fold(
        (failure) {
          return Left(failure);
        },
        (relatorio) {
          return Right(relatorio);
        },
      );
    } catch (e) {
      return Left(ErrorRelatorioProducao(
        message:
            'Erro no repository ao buscar relatório de produção: ${e.toString()}',
      ));
    }
  }
}

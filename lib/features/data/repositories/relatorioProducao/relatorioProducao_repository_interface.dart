import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/relatorioProducao/relatorioProducao_model.dart';

abstract class IRelatorioProducaoRepository {
  Future<Either<Failure, RelatorioProducao>> buscarRelatorioProducao(
    int contaId,
  );
}

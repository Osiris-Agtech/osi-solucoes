import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

import '../../../../core/errors/failure.dart';

abstract class ISolucaoRepository {
  Future<Either<Failure, List<SolucaoNutritiva>>> buscarSolucoes(int contaId);
  Future<Either<Failure, SolucaoNutritiva>> detalhesSolucao(int solucaoId);
}

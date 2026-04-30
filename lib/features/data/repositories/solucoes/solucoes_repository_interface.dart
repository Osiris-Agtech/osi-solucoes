import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:osi_solucoes/features/presenter/models/nutriente/nutriente_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoConcentrada/solucaoConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

import '../../../../core/errors/failure.dart';

abstract class ISolucaoRepository {
  Future<Either<Failure, List<SolucaoNutritiva>>> buscarSolucoes(int contaId);
  Future<Either<Failure, SolucaoNutritiva>> registrarSolucaoNutritiva(
      SolucaoNutritiva solucao, int contaId, bool hasConcentrada);
  Future<Either<Failure, List<Fertilizante>>> buscarFertilizantes(int contaId);
  Future<Either<Failure, List<Nutriente>>> buscarNutrientes();
  Future<Either<Failure, Fertilizante>> criarFertilizanteCustom(
      int contaId, String nome, List<Map<String, dynamic>> nutrientes);
  Future<Either<Failure, Fertilizante>> atualizarFertilizanteCustom(
      int contaId, int fertilizanteId, String nome,
      List<Map<String, dynamic>> nutrientes);
  Future<Either<Failure, bool>> excluirFertilizanteCustom(
      int contaId, int fertilizanteId);
  Future<Either<Failure, SolucaoNutritiva>> detalhesSolucao(int solucaoId);
  Future<Either<Failure, SolucaoConcentrada>> cadastrarSolucaoConcentrada(
      {required SolucaoConcentrada novaSolucaoConcentrada});
}

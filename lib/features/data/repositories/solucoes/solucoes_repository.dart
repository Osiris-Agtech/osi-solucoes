import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/datasources/solucoes/solucoes_nutritivas_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/solucoes/solucoes_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/fertilizante/fertilizante_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoConcentrada/solucaoConcentrada_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

class SolucaoRepository implements ISolucaoRepository {
  final ISolucaoDatasource datasource;
  SolucaoRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<SolucaoNutritiva>>> buscarSolucoes(
      int contaId) async {
    var result = await datasource.buscarSolucoes(contaId: contaId);

    return result;
  }

  @override
  Future<Either<Failure, SolucaoNutritiva>> registrarSolucaoNutritiva(
      SolucaoNutritiva solucao, int contaId) async {
    var result = await datasource.registrarSolucaoNutritiva(
      solucao: solucao,
      contaId: contaId,
    );

    return result;
  }

  @override
  Future<Either<Failure, List<Fertilizante>>> buscarFertilizantes() async {
    var result = await datasource.buscarFertilizantes();

    return result;
  }

  @override
  Future<Either<Failure, SolucaoNutritiva>> detalhesSolucao(
      int solucaoId) async {
    var result = await datasource.detalhesSolucao(solucaoId: solucaoId);

    return result;
  }

  @override
  Future<Either<Failure, SolucaoConcentrada>> cadastrarSolucaoConcentrada(
      {required SolucaoConcentrada novaSolucaoConcentrada}) async {
    var result = await datasource.cadastrarSolucaoConcentrada(
        novaSolucaoConcentrada: novaSolucaoConcentrada);

    return result;
  }
}

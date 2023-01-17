import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/datasources/reservatorio/reservatorio_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/reservatorio/reservatorio_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';
import 'package:osi_solucoes/features/presenter/models/solucaoNutritiva/solucaoNutritiva_model.dart';

class ReservatorioRepository implements IReservatorioRepository {
  final IReservatorioDatasource datasource;
  ReservatorioRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<SolucaoNutritiva>>> buscarSolucoes(
      int contaId) async {
    var result = await datasource.buscarSolucoes(contaId: contaId);

    return result;
  }

  @override
  Future<Either<Failure, SolucaoNutritiva>> detalhesSolucao(
      int solucaoId) async {
    var result = await datasource.detalhesSolucao(solucaoId: solucaoId);

    return result;
  }

  @override
  Future<Either<Failure, List<Reservatorio>>> buscarReservatorios(
      int contaId) async {
    var result = await datasource.buscarReservatorios(contaId: contaId);

    return result;
  }

  @override
  Future<Either<Failure, Reservatorio>> buscarReservatorioDetalhes(
      int reservatorioId) async {
    var result = await datasource.buscarReservatorioDetalhes(
        reservatorioId: reservatorioId);

    return result;
  }

  @override
  Future<Either<Failure, Reservatorio>> registrarReservatorio(
      Reservatorio novoReservatorio) async {
    var result = await datasource.registrarReservatorio(
        novoReservatorio: novoReservatorio);

    return result;
  }

  @override
  Future<Either<Failure, Reservatorio>> updateReservatorio(
      {required Reservatorio novoReservatorio}) async {
    var result =
        await datasource.updateReservatorio(novoReservatorio: novoReservatorio);

    return result;
  }
}

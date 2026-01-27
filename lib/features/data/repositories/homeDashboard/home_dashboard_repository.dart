import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/data/datasources/homeDashboard/home_dashboard_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/homeDashboard/home_dashboard_repository_interface.dart';
import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_model.dart';

class HomeDashboardRepository implements IHomeDashboardRepository {
  final IHomeDashboardDatasource datasource;

  HomeDashboardRepository({required this.datasource});

  @override
  Future<Either<Failure, HomeDashboard>> buscarHomeDashboard(
    int contaId,
  ) async {
    return await datasource.buscarHomeDashboard(contaId: contaId);
  }
}

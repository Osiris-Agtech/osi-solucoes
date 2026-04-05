import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/models/homeDashboard/home_dashboard_model.dart';

abstract class IHomeDashboardRepository {
  Future<Either<Failure, HomeDashboard>> buscarHomeDashboard(
    int contaId,
  );
}

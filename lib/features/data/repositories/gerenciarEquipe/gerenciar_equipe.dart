import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/data/datasources/gerenciarEquipe/gerenciar_equipe_datasource.dart';
import 'package:osi_solucoes/features/data/repositories/gerenciarEquipe/gerenciar_equipe_interface.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import '../../../../core/errors/failure.dart';

class GerenciarEquipeRepository implements IGerenciarEquipeRepository {
  final IGerenciarEquipeDatasource datasource;
  GerenciarEquipeRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<Usuario>>> buscarUsuarios(int contaId) async {
    var result = await datasource.buscarUsuarios(contaId: contaId);

    return result;
  }
}

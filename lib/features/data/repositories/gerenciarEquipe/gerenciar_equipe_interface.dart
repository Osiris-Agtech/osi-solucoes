import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import '../../../../core/errors/failure.dart';

abstract class IGerenciarEquipeRepository {
  Future<Either<Failure, List<Usuario>>> buscarUsuarios(int contaId);
}

import 'package:dartz/dartz.dart';
import 'package:sigma_hort_gestao_equipe/features/data/datasources/gerenciarEquipe/gerenciar_equipe_datasource.dart';
import 'package:sigma_hort_gestao_equipe/features/data/repositories/gerenciarEquipe/gerenciar_equipe_repository_interface.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/cargo/cargo_model.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/usuario/usuario_model.dart';
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

  @override
  Future<Either<Failure, List<Cargo>>> buscarCargos() async {
    var result = await datasource.buscarCargos();

    return result;
  }

  @override
  Future<Either<Failure, Usuario>> alterarUsuario(
      Usuario usuario, int contaId, int cargoId) async {
    var result = await datasource.alterarUsuario(
        usuario: usuario, contaId: contaId, cargoId: cargoId);

    return result;
  }

  @override
  Future<Either<Failure, Usuario>> buscarPessoa(String email) async {
    var result = await datasource.buscarPessoa(email: email);

    return result;
  }

  @override
  Future<Either<Failure, Usuario>> registrarUsuario(
      Usuario usuario, int contaId, int cargoId) async {
    var result = await datasource.registrarUsuario(
        usuario: usuario, contaId: contaId, cargoId: cargoId);

    return result;
  }
}

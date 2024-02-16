import 'package:dartz/dartz.dart';
import 'package:sigma_hort_gestao_equipe/core/errors/failure.dart';
import 'package:sigma_hort_gestao_equipe/features/data/datasources/recuperarSenha/recuperar_senha_datasource.dart';
import 'package:sigma_hort_gestao_equipe/features/data/repositories/recuperarSenha/recuperar_senha_repository_interface.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/usuario/usuario_model.dart';

class RecuperarSenhaRepository implements IRecuperarSenhaRepository {
  final IRecuperarSenhaDatasource datasource;
  RecuperarSenhaRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, Usuario>> buscarUsuario(String email) async {
    var result = await datasource.buscarUsuario(email);

    return result;
  }

  @override
  Future<Either<Failure, String>> enviarCodigo(
      String email, String codigo) async {
    var result = await datasource.enviarCodigo(email, codigo);

    return result;
  }

  @override
  Future<Either<Failure, Usuario>> alterarSenha(
      int userId, String senha) async {
    var result = await datasource.alterarSenha(userId, senha);

    return result;
  }
}

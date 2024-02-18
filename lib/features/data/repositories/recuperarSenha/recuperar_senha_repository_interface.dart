import 'package:dartz/dartz.dart';
import 'package:sigma_hort_gestao_producao/features/presenter/models/usuario/usuario_model.dart';

import '../../../../core/errors/failure.dart';

abstract class IRecuperarSenhaRepository {
  Future<Either<Failure, Usuario>> buscarUsuario(String email);
  Future<Either<Failure, String>> enviarCodigo(String email, String codigo);
  Future<Either<Failure, Usuario>> alterarSenha(int userId, String senha);
}

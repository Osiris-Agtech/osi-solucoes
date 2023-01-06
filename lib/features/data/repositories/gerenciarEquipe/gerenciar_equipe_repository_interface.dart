import 'package:dartz/dartz.dart';
import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import '../../../../core/errors/failure.dart';
import '../../../presenter/models/cargo/cargo_model.dart';

abstract class IGerenciarEquipeRepository {
  Future<Either<Failure, List<Usuario>>> buscarUsuarios(int contaId);
  Future<Either<Failure, List<Cargo>>> buscarCargos();
  Future<Either<Failure, Usuario>> alterarUsuario(
      Usuario usuario, int contaId, int cargoId);
  Future<Either<Failure, Usuario>> buscarPessoa(String email);
  Future<Either<Failure, Usuario>> registrarUsuario(
      Usuario usuario, int contaId, int cargoId);
}

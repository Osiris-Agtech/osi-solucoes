import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';

abstract class ICadastroRepository {
  Future verificaUser(String email);
  Future cadastraConta({
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
    String? endereco,
    String? bairro,
    String? cidade,
    required String telefone,
    String? imagem,
    String? cep,
    String? estado,
    String? pais,
    String? complemento,
    String? imagemConta,
    String? cnpjConta,
  });
  Future<Either<Failure, String>> enviarEmail(
      String codigo, String email, String nome);
}

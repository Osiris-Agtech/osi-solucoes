import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../presenter/models/usuario/usuario_model.dart';
import '../../datasources/cadastro/cadastro_datasource.dart';
import 'cadastro_repository_interface.dart';

class CadastroRepository implements ICadastroRepository {
  final ICadastroConta datasource;
  CadastroRepository({
    required this.datasource,
  });

  @override
  Future<Either<Failure, Usuario>> cadastraConta({
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
  }) async {
    var result = await datasource.cadastraConta(
      nome: nome,
      sobrenome: sobrenome,
      email: email,
      senha: senha,
      endereco: endereco,
      bairro: bairro,
      cidade: cidade,
      telefone: telefone,
      imagem: imagem,
      cep: cep,
      estado: estado,
      pais: pais,
      complemento: complemento,
      imagemConta: imagemConta,
      cnpjConta: cnpjConta,
    );

    return result;
  }

  @override
  Future<Either<Failure, List<Usuario>>> verificaUser(String email) async {
    var result = await datasource.verificaUser(email);

    return result;
  }

  @override
  Future<Either<Failure, String>> enviarEmail(
      String codigo, String email, String nome) async {
    var result = await datasource.enviarEmail(codigo, email, nome);

    return result;
  }
}

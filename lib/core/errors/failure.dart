abstract class Failure implements Exception {
  String get message;
}

class FailureMessage {
  static const connectionErrorMessage = 'Sem conexão com a internet';
  static const userNotFoundMessage = "Usuário não encontrado";
  static const userFoundMessage = "Usuário já existe";
  static const errorLoginMessage = 'Falha ao fazer o login';
  static const errorRegisterMessage = 'Falha ao criar conta';
  static const errorLoginEmailMessage = 'E-mail inválido';
  static const errorLoginPasswordMessage = 'Senha inválida';
  static const errorRecoverPasswordMessage = 'E-mail não encontrado';
  static const errorValidationCodeMessage = 'Código de ativação incorreto';
  static const errorGetLoggedUserMessage = 'Usuário não logado';
  static const errorLogoutMessage = 'Falha ao sair';
  static const notAutomaticRetrievedMessage = 'Recuperação não automática';
  static const internalErrorMessage = 'Erro interno';
  static const cepErrorMessage = 'Requisição inválida!';
  static const senEmailErrorMessage = 'Falha ao enviar e-mail';
  static const emptyListMessage = 'Lista Vazia';
  static const errorInfoMessage = 'Falha ao carregar as informações';
  static const errorNovoReservatorioMessage =
      'Falha ao cadastrar, verifique se os campos estão preenchidos';
}

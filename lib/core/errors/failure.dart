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
  static const errorUserEmailNotFound = 'Esse E-mail ainda não foi cadastrado';
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
      'Falha ao cadastrar, verifique se os campos estão preenchidos corretamente';
  static const errorNovaAreaMessage =
      'Falha ao cadastrar área, verifique se os campos estão preenchidos corretamente';
  static const errorNovoSetorMessage =
      'Falha ao cadastrar setor, verifique se os campos estão preenchidos corretamente';
  static const errorNovoLoteMessage =
      'Falha ao cadastrar lote, verifique se os campos estão preenchidos corretamente';
  static const errorAlterarAreaMessage =
      'Falha ao alterar área, verifique se os campos estão preenchidos corretamente';
  static const errorAlterarSetorMessage =
      'Falha ao alterar setor, verifique se os campos estão preenchidos corretamente';
  static const errorMigrarLoteMessage =
      'Falha ao migrar lote, algo está bloqueando a ação';
  static const errorAlterarLoteMessage =
      'Falha ao alterar lote, verifique se os campos estão preenchidos corretamente';
  static const errorCadastrarCulturaMessage =
      'Falha ao cadastrar cultura, verifique se o campo está preenchido corretamente';
  static const errorCadastrarAjusteMessage =
      'Falha ao cadastrar ajuste, verifique se os campos estão preenchido corretamente';
  static const errorUpdateUsuarioMessage =
      'Falha ao atualizar usuario, verifique se os campos estão preenchido corretamente';
  static const errorBuscarAgendas = 'Ocorreu um erro ao buscar as atividades';
  static const errorAgendaMarcarComoFeito =
      'Ocorreu um erro ao marcar a atividade como feita';
  static const errorEditAgenda = 'Ocorreu um erro ao editar a atividade';
}

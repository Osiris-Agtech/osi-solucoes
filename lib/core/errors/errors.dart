import 'failure.dart';

class ConnectionError extends Failure {
  @override
  final String message;
  ConnectionError({required this.message});
}

class ErrorLogin extends Failure {
  @override
  final String message;
  ErrorLogin({required this.message});
}

class ErrorRegister extends Failure {
  @override
  final String message;
  ErrorRegister({required this.message});
}

class ErrorLoginFieldEmail extends Failure {
  @override
  final String message;
  ErrorLoginFieldEmail({required this.message});
}

class ErrorLoginFieldPassword extends Failure {
  @override
  final String message;
  ErrorLoginFieldPassword({required this.message});
}

class ErrorRecoverPassword extends Failure {
  @override
  final String message;
  ErrorRecoverPassword({required this.message});
}

class ErrorGetLoggedUser extends Failure {
  @override
  final String message;
  ErrorGetLoggedUser({required this.message});
}

class ErrorLogout extends Failure {
  @override
  final String message;
  ErrorLogout({required this.message});
}

class ErrorLoginPhone implements Failure {
  @override
  final String message;
  ErrorLoginPhone({required this.message});
}

class NotAutomaticRetrieved implements Failure {
  final String verificationId;

  @override
  final String message;
  NotAutomaticRetrieved(this.verificationId, {required this.message});
}

class InternalError implements Failure {
  @override
  final String message;
  InternalError({required this.message});
}

class ErrorCEP implements Failure {
  @override
  final String message;
  ErrorCEP({required this.message});
}

class ErrorReservatorio implements Failure {
  @override
  final String message;
  ErrorReservatorio({required this.message});
}

class ErrorProtocolo implements Failure {
  @override
  final String message;
  ErrorProtocolo({required this.message});
}

class ErrorFertilizante implements Failure {
  @override
  final String message;
  ErrorFertilizante({required this.message});
}

class ErrorGerenciarEquipe implements Failure {
  @override
  final String message;
  ErrorGerenciarEquipe({required this.message});
}

class ErrorArea implements Failure {
  @override
  final String message;
  ErrorArea({required this.message});
}

class ErrorSetor implements Failure {
  @override
  final String message;
  ErrorSetor({required this.message});
}

class ErrorLote implements Failure {
  @override
  final String message;
  ErrorLote({required this.message});
}

class ErrorAgenda implements Failure {
  @override
  final String message;
  ErrorAgenda({required this.message});
}

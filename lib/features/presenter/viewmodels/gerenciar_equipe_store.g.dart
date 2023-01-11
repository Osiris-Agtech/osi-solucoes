// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gerenciar_equipe_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GerenciarEquipeStore on _GerenciarEquipeBase, Store {
  Computed<List<Usuario>>? _$searchUserComputed;

  @override
  List<Usuario> get searchUser =>
      (_$searchUserComputed ??= Computed<List<Usuario>>(() => super.searchUser,
              name: '_GerenciarEquipeBase.searchUser'))
          .value;

  final _$valueAtom = Atom(name: '_GerenciarEquipeBase.value');

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$isUserListLoadingAtom =
      Atom(name: '_GerenciarEquipeBase.isUserListLoading');

  @override
  bool get isUserListLoading {
    _$isUserListLoadingAtom.reportRead();
    return super.isUserListLoading;
  }

  @override
  set isUserListLoading(bool value) {
    _$isUserListLoadingAtom.reportWrite(value, super.isUserListLoading, () {
      super.isUserListLoading = value;
    });
  }

  final _$userListAtom = Atom(name: '_GerenciarEquipeBase.userList');

  @override
  List<Usuario> get userList {
    _$userListAtom.reportRead();
    return super.userList;
  }

  @override
  set userList(List<Usuario> value) {
    _$userListAtom.reportWrite(value, super.userList, () {
      super.userList = value;
    });
  }

  final _$userMapAtom = Atom(name: '_GerenciarEquipeBase.userMap');

  @override
  List<UserMap> get userMap {
    _$userMapAtom.reportRead();
    return super.userMap;
  }

  @override
  set userMap(List<UserMap> value) {
    _$userMapAtom.reportWrite(value, super.userMap, () {
      super.userMap = value;
    });
  }

  final _$searchUserTextAtom =
      Atom(name: '_GerenciarEquipeBase.searchUserText');

  @override
  String get searchUserText {
    _$searchUserTextAtom.reportRead();
    return super.searchUserText;
  }

  @override
  set searchUserText(String value) {
    _$searchUserTextAtom.reportWrite(value, super.searchUserText, () {
      super.searchUserText = value;
    });
  }

  final _$usuarioSelecionadoAtom =
      Atom(name: '_GerenciarEquipeBase.usuarioSelecionado');

  @override
  Usuario get usuarioSelecionado {
    _$usuarioSelecionadoAtom.reportRead();
    return super.usuarioSelecionado;
  }

  @override
  set usuarioSelecionado(Usuario value) {
    _$usuarioSelecionadoAtom.reportWrite(value, super.usuarioSelecionado, () {
      super.usuarioSelecionado = value;
    });
  }

  final _$novoUsuarioAtom = Atom(name: '_GerenciarEquipeBase.novoUsuario');

  @override
  Usuario get novoUsuario {
    _$novoUsuarioAtom.reportRead();
    return super.novoUsuario;
  }

  @override
  set novoUsuario(Usuario value) {
    _$novoUsuarioAtom.reportWrite(value, super.novoUsuario, () {
      super.novoUsuario = value;
    });
  }

  final _$ativoIsChangedAtom =
      Atom(name: '_GerenciarEquipeBase.ativoIsChanged');

  @override
  bool get ativoIsChanged {
    _$ativoIsChangedAtom.reportRead();
    return super.ativoIsChanged;
  }

  @override
  set ativoIsChanged(bool value) {
    _$ativoIsChangedAtom.reportWrite(value, super.ativoIsChanged, () {
      super.ativoIsChanged = value;
    });
  }

  final _$cargosListAtom = Atom(name: '_GerenciarEquipeBase.cargosList');

  @override
  List<Cargo> get cargosList {
    _$cargosListAtom.reportRead();
    return super.cargosList;
  }

  @override
  set cargosList(List<Cargo> value) {
    _$cargosListAtom.reportWrite(value, super.cargosList, () {
      super.cargosList = value;
    });
  }

  final _$cargoSelecionadoDetalhesPageAtom =
      Atom(name: '_GerenciarEquipeBase.cargoSelecionadoDetalhesPage');

  @override
  Cargo? get cargoSelecionadoDetalhesPage {
    _$cargoSelecionadoDetalhesPageAtom.reportRead();
    return super.cargoSelecionadoDetalhesPage;
  }

  @override
  set cargoSelecionadoDetalhesPage(Cargo? value) {
    _$cargoSelecionadoDetalhesPageAtom
        .reportWrite(value, super.cargoSelecionadoDetalhesPage, () {
      super.cargoSelecionadoDetalhesPage = value;
    });
  }

  final _$cargoSelecionadoAtom =
      Atom(name: '_GerenciarEquipeBase.cargoSelecionado');

  @override
  Cargo? get cargoSelecionado {
    _$cargoSelecionadoAtom.reportRead();
    return super.cargoSelecionado;
  }

  @override
  set cargoSelecionado(Cargo? value) {
    _$cargoSelecionadoAtom.reportWrite(value, super.cargoSelecionado, () {
      super.cargoSelecionado = value;
    });
  }

  final _$usuarioEncontradoAtom =
      Atom(name: '_GerenciarEquipeBase.usuarioEncontrado');

  @override
  Usuario? get usuarioEncontrado {
    _$usuarioEncontradoAtom.reportRead();
    return super.usuarioEncontrado;
  }

  @override
  set usuarioEncontrado(Usuario? value) {
    _$usuarioEncontradoAtom.reportWrite(value, super.usuarioEncontrado, () {
      super.usuarioEncontrado = value;
    });
  }

  final _$emailAtom = Atom(name: '_GerenciarEquipeBase.email');

  @override
  TextEditingController get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(TextEditingController value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$nomeAtom = Atom(name: '_GerenciarEquipeBase.nome');

  @override
  TextEditingController get nome {
    _$nomeAtom.reportRead();
    return super.nome;
  }

  @override
  set nome(TextEditingController value) {
    _$nomeAtom.reportWrite(value, super.nome, () {
      super.nome = value;
    });
  }

  final _$sobrenomeAtom = Atom(name: '_GerenciarEquipeBase.sobrenome');

  @override
  TextEditingController get sobrenome {
    _$sobrenomeAtom.reportRead();
    return super.sobrenome;
  }

  @override
  set sobrenome(TextEditingController value) {
    _$sobrenomeAtom.reportWrite(value, super.sobrenome, () {
      super.sobrenome = value;
    });
  }

  final _$pessoaFoundAtom = Atom(name: '_GerenciarEquipeBase.pessoaFound');

  @override
  bool get pessoaFound {
    _$pessoaFoundAtom.reportRead();
    return super.pessoaFound;
  }

  @override
  set pessoaFound(bool value) {
    _$pessoaFoundAtom.reportWrite(value, super.pessoaFound, () {
      super.pessoaFound = value;
    });
  }

  final _$buscarUsuariosAsyncAction =
      AsyncAction('_GerenciarEquipeBase.buscarUsuarios');

  @override
  Future buscarUsuarios() {
    return _$buscarUsuariosAsyncAction.run(() => super.buscarUsuarios());
  }

  final _$buscarCargosAsyncAction =
      AsyncAction('_GerenciarEquipeBase.buscarCargos');

  @override
  Future buscarCargos() {
    return _$buscarCargosAsyncAction.run(() => super.buscarCargos());
  }

  final _$alterarUsuarioAsyncAction =
      AsyncAction('_GerenciarEquipeBase.alterarUsuario');

  @override
  Future alterarUsuario() {
    return _$alterarUsuarioAsyncAction.run(() => super.alterarUsuario());
  }

  final _$buscarPessoaAsyncAction =
      AsyncAction('_GerenciarEquipeBase.buscarPessoa');

  @override
  Future buscarPessoa() {
    return _$buscarPessoaAsyncAction.run(() => super.buscarPessoa());
  }

  final _$registrarUsuarioAsyncAction =
      AsyncAction('_GerenciarEquipeBase.registrarUsuario');

  @override
  Future registrarUsuario() {
    return _$registrarUsuarioAsyncAction.run(() => super.registrarUsuario());
  }

  final _$_GerenciarEquipeBaseActionController =
      ActionController(name: '_GerenciarEquipeBase');

  @override
  void increment() {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.increment');
    try {
      return super.increment();
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setsearchUserText(String value) {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.setsearchUserText');
    try {
      return super.setsearchUserText(value);
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUsuarioSelecionado(Usuario value) {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.setUsuarioSelecionado');
    try {
      return super.setUsuarioSelecionado(value);
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAtivo(bool value) {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.setAtivo');
    try {
      return super.setAtivo(value);
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearDatalhes() {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.clearDatalhes');
    try {
      return super.clearDatalhes();
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setInitialCargo() {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.setInitialCargo');
    try {
      return super.setInitialCargo();
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCargoDetalhesPage(Cargo cargo) {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.setCargoDetalhesPage');
    try {
      return super.setCargoDetalhesPage(cargo);
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearCadastro() {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.clearCadastro');
    try {
      return super.clearCadastro();
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCargo(Cargo cargo) {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.setCargo');
    try {
      return super.setCargo(cargo);
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEmail(String value) {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setNome(String value) {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.setNome');
    try {
      return super.setNome(value);
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSobrenome(String value) {
    final _$actionInfo = _$_GerenciarEquipeBaseActionController.startAction(
        name: '_GerenciarEquipeBase.setSobrenome');
    try {
      return super.setSobrenome(value);
    } finally {
      _$_GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
isUserListLoading: ${isUserListLoading},
userList: ${userList},
userMap: ${userMap},
searchUserText: ${searchUserText},
usuarioSelecionado: ${usuarioSelecionado},
novoUsuario: ${novoUsuario},
ativoIsChanged: ${ativoIsChanged},
cargosList: ${cargosList},
cargoSelecionadoDetalhesPage: ${cargoSelecionadoDetalhesPage},
cargoSelecionado: ${cargoSelecionado},
usuarioEncontrado: ${usuarioEncontrado},
email: ${email},
nome: ${nome},
sobrenome: ${sobrenome},
pessoaFound: ${pessoaFound},
searchUser: ${searchUser}
    ''';
  }
}

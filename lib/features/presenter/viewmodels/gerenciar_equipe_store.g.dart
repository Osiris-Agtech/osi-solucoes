// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gerenciar_equipe_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GerenciarEquipeStore on GerenciarEquipeBase, Store {
  Computed<List<Usuario>>? _$searchUserComputed;

  @override
  List<Usuario> get searchUser =>
      (_$searchUserComputed ??= Computed<List<Usuario>>(() => super.searchUser,
              name: 'GerenciarEquipeBase.searchUser'))
          .value;

  late final _$valueAtom =
      Atom(name: 'GerenciarEquipeBase.value', context: context);

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

  late final _$isUserListLoadingAtom =
      Atom(name: 'GerenciarEquipeBase.isUserListLoading', context: context);

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

  late final _$userListAtom =
      Atom(name: 'GerenciarEquipeBase.userList', context: context);

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

  late final _$userMapAtom =
      Atom(name: 'GerenciarEquipeBase.userMap', context: context);

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

  late final _$searchUserTextAtom =
      Atom(name: 'GerenciarEquipeBase.searchUserText', context: context);

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

  late final _$usuarioSelecionadoAtom =
      Atom(name: 'GerenciarEquipeBase.usuarioSelecionado', context: context);

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

  late final _$novoUsuarioAtom =
      Atom(name: 'GerenciarEquipeBase.novoUsuario', context: context);

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

  late final _$ativoIsChangedAtom =
      Atom(name: 'GerenciarEquipeBase.ativoIsChanged', context: context);

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

  late final _$cargosListAtom =
      Atom(name: 'GerenciarEquipeBase.cargosList', context: context);

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

  late final _$cargoSelecionadoDetalhesPageAtom = Atom(
      name: 'GerenciarEquipeBase.cargoSelecionadoDetalhesPage',
      context: context);

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

  late final _$cargoSelecionadoAtom =
      Atom(name: 'GerenciarEquipeBase.cargoSelecionado', context: context);

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

  late final _$usuarioEncontradoAtom =
      Atom(name: 'GerenciarEquipeBase.usuarioEncontrado', context: context);

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

  late final _$emailAtom =
      Atom(name: 'GerenciarEquipeBase.email', context: context);

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

  late final _$nomeAtom =
      Atom(name: 'GerenciarEquipeBase.nome', context: context);

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

  late final _$sobrenomeAtom =
      Atom(name: 'GerenciarEquipeBase.sobrenome', context: context);

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

  late final _$pessoaFoundAtom =
      Atom(name: 'GerenciarEquipeBase.pessoaFound', context: context);

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

  late final _$buscarUsuariosAsyncAction =
      AsyncAction('GerenciarEquipeBase.buscarUsuarios', context: context);

  @override
  Future<void> buscarUsuarios() {
    return _$buscarUsuariosAsyncAction.run(() => super.buscarUsuarios());
  }

  late final _$buscarCargosAsyncAction =
      AsyncAction('GerenciarEquipeBase.buscarCargos', context: context);

  @override
  Future<void> buscarCargos() {
    return _$buscarCargosAsyncAction.run(() => super.buscarCargos());
  }

  late final _$alterarUsuarioAsyncAction =
      AsyncAction('GerenciarEquipeBase.alterarUsuario', context: context);

  @override
  Future<void> alterarUsuario() {
    return _$alterarUsuarioAsyncAction.run(() => super.alterarUsuario());
  }

  late final _$buscarPessoaAsyncAction =
      AsyncAction('GerenciarEquipeBase.buscarPessoa', context: context);

  @override
  Future<void> buscarPessoa() {
    return _$buscarPessoaAsyncAction.run(() => super.buscarPessoa());
  }

  late final _$registrarUsuarioAsyncAction =
      AsyncAction('GerenciarEquipeBase.registrarUsuario', context: context);

  @override
  Future<void> registrarUsuario() {
    return _$registrarUsuarioAsyncAction.run(() => super.registrarUsuario());
  }

  late final _$GerenciarEquipeBaseActionController =
      ActionController(name: 'GerenciarEquipeBase', context: context);

  @override
  void increment() {
    final _$actionInfo = _$GerenciarEquipeBaseActionController.startAction(
        name: 'GerenciarEquipeBase.increment');
    try {
      return super.increment();
    } finally {
      _$GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String setsearchUserText(String value) {
    final _$actionInfo = _$GerenciarEquipeBaseActionController.startAction(
        name: 'GerenciarEquipeBase.setsearchUserText');
    try {
      return super.setsearchUserText(value);
    } finally {
      _$GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUsuarioSelecionado(Usuario value) {
    final _$actionInfo = _$GerenciarEquipeBaseActionController.startAction(
        name: 'GerenciarEquipeBase.setUsuarioSelecionado');
    try {
      return super.setUsuarioSelecionado(value);
    } finally {
      _$GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setAtivo(bool value) {
    final _$actionInfo = _$GerenciarEquipeBaseActionController.startAction(
        name: 'GerenciarEquipeBase.setAtivo');
    try {
      return super.setAtivo(value);
    } finally {
      _$GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearDatalhes() {
    final _$actionInfo = _$GerenciarEquipeBaseActionController.startAction(
        name: 'GerenciarEquipeBase.clearDatalhes');
    try {
      return super.clearDatalhes();
    } finally {
      _$GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInitialCargo() {
    final _$actionInfo = _$GerenciarEquipeBaseActionController.startAction(
        name: 'GerenciarEquipeBase.setInitialCargo');
    try {
      return super.setInitialCargo();
    } finally {
      _$GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Cargo setCargoDetalhesPage(Cargo cargo) {
    final _$actionInfo = _$GerenciarEquipeBaseActionController.startAction(
        name: 'GerenciarEquipeBase.setCargoDetalhesPage');
    try {
      return super.setCargoDetalhesPage(cargo);
    } finally {
      _$GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCadastro() {
    final _$actionInfo = _$GerenciarEquipeBaseActionController.startAction(
        name: 'GerenciarEquipeBase.clearCadastro');
    try {
      return super.clearCadastro();
    } finally {
      _$GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Cargo setCargo(Cargo cargo) {
    final _$actionInfo = _$GerenciarEquipeBaseActionController.startAction(
        name: 'GerenciarEquipeBase.setCargo');
    try {
      return super.setCargo(cargo);
    } finally {
      _$GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$GerenciarEquipeBaseActionController.startAction(
        name: 'GerenciarEquipeBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNome(String value) {
    final _$actionInfo = _$GerenciarEquipeBaseActionController.startAction(
        name: 'GerenciarEquipeBase.setNome');
    try {
      return super.setNome(value);
    } finally {
      _$GerenciarEquipeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSobrenome(String value) {
    final _$actionInfo = _$GerenciarEquipeBaseActionController.startAction(
        name: 'GerenciarEquipeBase.setSobrenome');
    try {
      return super.setSobrenome(value);
    } finally {
      _$GerenciarEquipeBaseActionController.endAction(_$actionInfo);
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

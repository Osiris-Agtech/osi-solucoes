import 'package:flutter_test/flutter_test.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/app/modules/login/login_store.dart';

void main() {
  late LoginStore store;

  setUpAll(() {
    store = LoginStore();
  });

  test('Ao usar toggleObscure, isObscure deve alternar entre False e True', () {
    // final store = Modular.get<LoginStore>();
    expect(store.isObscure, equals(true));
    store.toggleObscure();
    expect(store.isObscure, equals(false));
    store.toggleObscure();
    expect(store.isObscure, equals(true));
  });

  test('Campo E-mail ou Código Vazio', () async {
    String result = await store.validateEmail('');
    expect(result, equals("erroValidacaoEmailVazio".i18n()));
  });

  test('Campo Senha Vazio', () async {
    String result = await store.validateSenha('');
    expect(result, equals("erroValidacaoSenhaVazio".i18n()));
  });

  test('Senha Curta', () async {
    String result = await store.validateSenha('1234');
    expect(result, equals("ErroValidacaoSenhaInvalido".i18n()));
  });

  test('Login com e-mail e senha corretos', () async {
    store.email.text = "g@g.com";
    store.senha.text = "123456";
    String result = await store.login();
    expect(result, equals("loginValido".i18n()));
  });

  test('Login com código e senha corretos', () async {
    store.email.text = "jv24osi";
    store.senha.text = "123456";
    String result = await store.login();
    expect(result, equals("loginInvalido".i18n()));
  });

  test('Login com senha errada', () async {
    store.email.text = "g@g.com";
    store.senha.text = "1234567";
    String result = await store.login();
    expect(result, equals("loginInvalido".i18n()));
  });

  test('Login usuário inexistente', () async {
    store.email.text = "abc";
    store.senha.text = "123";
    String result = await store.login();
    expect(result, equals("loginInvalido".i18n()));
  });

  test('Login vazio', () async {
    store.email.text = "";
    store.senha.text = "";
    String result = await store.login();
    expect(result, equals("loginInvalido".i18n()));
  });

  // test('Validação de email: campo de email vazio', () async {
  //   expect(store.email.text, equals(""));
  // });

  // test('Validação de email: campo de email invalido', () async {
  //   String pattern =
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  //   store.email.text = "gustavo.alecio2live.com";
  //   bool isRegular = RegExp(pattern).hasMatch(store.email.text);
  //   expect(isRegular, equals(false));
  //   store.email.text = "gustavo.alecio2@livecom";
  //   isRegular = RegExp(pattern).hasMatch(store.email.text);
  //   expect(isRegular, equals(false));
  // });
  // test('Validação de email: campo de email valido', () async {
  //   store.email.text = "gustavo.alecio2@live.com";
  //   String pattern =
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  //   bool isRegular = RegExp(pattern).hasMatch(store.email.text);
  //   expect(isRegular, equals(true));
  // });
  // test('Validação de senha: campo de senha vazio', () async {
  //   store.senha.text = "";

  //   expect(store.senha.text, equals(""));
  // });
  // test('Validação de senha: campo de senha menor que 6 caracteres', () async {
  //   store.senha.text = "12345";
  //   bool isInvalid = store.senha.text.length < 6 ? true : false;
  //   expect(isInvalid, equals(store.senha.text.length < 6));
  // });
  // test('Validação de senha: campo de senha válido', () async {
  //   store.senha.text = "123456";
  //   bool isValid = store.senha.text.length < 6 ? false : true;
  //   expect(isValid, equals(store.senha.text.length >= 6));
  // });
}

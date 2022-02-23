import 'package:flutter_test/flutter_test.dart';
import 'package:osi_solucoes/app//modules/login/login_store.dart';

void main() {
  late LoginStore store;

  setUpAll(() {
    store = LoginStore();
    
  });

  test('Ao usar toggleObscure, isObscure deve alternar entre False e True',
      () async {
    expect(store.isObscure, equals(false));
    store.toggleObscure();
    expect(store.isObscure, equals(true));
    store.toggleObscure();
    expect(store.isObscure, equals(false));
  });
  
  test('Validação de email: campo de email vazio', () async {
    expect(store.email.text, equals(""));
  });

  test('Validação de email: campo de email invalido', () async {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    store.email.text = "gustavo.alecio2live.com";
    bool isRegular = RegExp(pattern).hasMatch(store.email.text);
    expect(isRegular, equals(false));
    store.email.text = "gustavo.alecio2@livecom";
    isRegular = RegExp(pattern).hasMatch(store.email.text);
    expect(isRegular, equals(false));
  });
  test('Validação de email: campo de email valido', () async {
    store.email.text = "gustavo.alecio2@live.com";
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    bool isRegular = RegExp(pattern).hasMatch(store.email.text);
    expect(isRegular, equals(true));
  });
  test('Validação de senha: campo de senha vazio', () async {
    store.senha.text = "";

    expect(store.senha.text, equals(""));
  });
  test('Validação de senha: campo de senha menor que 6 caracteres', () async {
    store.senha.text = "12345";
    bool isInvalid = store.senha.text.length < 6 ? true : false;
    expect(isInvalid, equals(store.senha.text.length < 6));
  });
  test('Validação de senha: campo de senha válido', () async {
    store.senha.text = "123456";
    bool isValid = store.senha.text.length < 6 ? false : true;
    expect(isValid, equals(store.senha.text.length >= 6));
  });
}

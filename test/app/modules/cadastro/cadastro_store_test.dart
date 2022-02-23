import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:osi_solucoes/app//modules/cadastro/cadastro_store.dart';
import 'package:search_cep/search_cep.dart';

class MockCep extends Mock implements ViaCepSearchCep {}

void main() {
  late CadastroStore store;

  setUpAll(() {
    store = CadastroStore();
  });

  test(
      'Validação dos campos de formulário de cadastro, devem retornar sucesso se estiverem vazios',
      () async {
    expect(store.nome.text, equals(isEmpty));
    expect(store.sobrenome.text, equals(isEmpty));
    expect(store.cep.text, equals(isEmpty));
    expect(store.cidade.text, equals(isEmpty));
    expect(store.estado.text, equals(isEmpty));
    expect(store.pais.text, equals(isEmpty));
    expect(store.email.text, equals(isEmpty));
    expect(store.senha.text, equals(isEmpty));
  });
  test('Ao usar toggleObscure, isObscure deve alternar entre False e True',
      () async {
    expect(store.isObscure, equals(false));
    store.toggleObscure();
    expect(store.isObscure, equals(true));
    store.toggleObscure();
    expect(store.isObscure, equals(false));
  });

}

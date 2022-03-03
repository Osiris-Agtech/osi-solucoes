import 'package:flutter_test/flutter_test.dart';
import 'package:osi_solucoes/app//modules/perfil/repositories_repository.dart';
 
void main() {
  late RepositoriesRepository repository;

  setUpAll(() {
    repository = RepositoriesRepository();
  });
}
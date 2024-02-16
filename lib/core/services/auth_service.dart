import 'package:get/get.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/usuario/usuario_model.dart';

class AuthService extends GetxService {
  Future<AuthService> init() async => this;

  final RxBool isPremium = false.obs;
  final Rx<Usuario> usuarioAuth = Usuario().obs;

  void setIsPremium(bool newValue) {
    isPremium.value = newValue;
  }

  void setUsuarioAuth(Usuario usuario) {
    usuarioAuth.value = usuario;
  }
}

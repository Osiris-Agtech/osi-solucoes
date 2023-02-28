import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/recuperar_senha_store.dart';

class NovaSenhaPage extends StatefulWidget {
  const NovaSenhaPage({Key? key}) : super(key: key);

  @override
  State<NovaSenhaPage> createState() => _NovaSenhaPageState();
}

class _NovaSenhaPageState extends State<NovaSenhaPage> {
  RecuperarSenhaStore recuperarSenhaStore = GetIt.I<RecuperarSenhaStore>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var screenHeigh = (size.height - _appBar().preferredSize.height) -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeigh,
          width: size.width,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _titulo(),
                const SizedBox(height: 32),
                Image(
                  width: MediaQuery.of(context).size.width * .6,
                  image: const AssetImage("assets/images/confirmarSenha.png"),
                ),
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    'Informe sua nova Senha',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      color: Constants.kGreyText2,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: size.width * 0.8,
                  child: Observer(builder: (_) {
                    return TextFormField(
                      controller: recuperarSenhaStore.novaSenha,
                      obscureText: true, //controller.mostrarSenha,
                      onChanged: (value) {
                        // controller.setnovaSenha(value);
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            recuperarSenhaStore.mostrarSenha
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          color: Constants.kGreyMedium,
                          onPressed: () {
                            recuperarSenhaStore.switchMostrarSenha();
                          },
                        ),
                        isDense: false,
                        hintText: 'Nova senha',
                        alignLabelWithHint: false,
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "erroValidacaoCampoVazio".i18n();
                        }

                        if (value.length < 6) {
                          return "A senha deve ter pelo menos 6 caracteres";
                        }

                        return null;
                      },
                    );
                  }),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: size.width * 0.8,
                  child: Observer(builder: (_) {
                    return TextFormField(
                      controller: recuperarSenhaStore.confirmarNovaSenha,
                      obscureText: true,
                      onChanged: (value) {
                        // controller.setconfirmarSenha(value);
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            recuperarSenhaStore.mostrarConfirmarSenha
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          color: Constants.kGreyMedium,
                          onPressed: () {
                            recuperarSenhaStore.switchMostrarConfirmarSenha();
                          },
                        ),
                        isDense: false,
                        hintText: 'Confirmar Senha',
                        alignLabelWithHint: false,
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "erroValidacaoCampoVazio".i18n();
                        }

                        if (value != recuperarSenhaStore.novaSenha.text) {
                          return 'Senhas não correspondem';
                        }

                        return null;
                      },
                    );
                  }),
                ),
                const Spacer(),
                SizedBox(
                  width: size.width * .75,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Constants.kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Alterar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Get.close(3);
                      }
                      // progressDialog.style(message: 'Enviando...');
                      // progressDialog.show();
                      // int resp =
                      //     await controller.gerarToken(tabController.index);
                      // Future.delayed(Duration(seconds: 2), () {
                      //   progressDialog.hide();
                      //   if (resp == 200) {
                      //     Modular.to.pushNamed("/recuperar/recuperarCod/");
                      //   } else {
                      //     buildShowGeneralDialog(context);
                      //   }
                      // });
                    }, //store.registrarReservatorio(),
                  ),
                ),
                const SizedBox(height: 16),
                FittedBox(
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'Cancelar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _titulo() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      child: Text(
        'Recuperar Senha',
        style: TextStyle(
          color: Constants.kGreyText,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Constants.kBackgroundColor,
      elevation: 0,
      leading: const BackButton(
        color: Constants.kPrimaryColor,
      ),
    );
  }
}

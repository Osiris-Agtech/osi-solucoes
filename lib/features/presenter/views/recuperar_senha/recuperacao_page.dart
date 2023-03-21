import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/recuperar_senha_store.dart';

class RecuperarSenhaPage extends StatefulWidget {
  const RecuperarSenhaPage({Key? key}) : super(key: key);

  @override
  State<RecuperarSenhaPage> createState() => _RecuperarSenhaPageState();
}

class _RecuperarSenhaPageState extends State<RecuperarSenhaPage> {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _titulo(),
              const SizedBox(height: 32),
              Image(
                width: MediaQuery.of(context).size.width * .6,
                image: const AssetImage("assets/images/recsenha.png"),
              ),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Informe o e-mail para encontrarmos sua conta',
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
              Column(
                children: [
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      color: Constants.kGreyText,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: recuperarSenhaStore.email,
                        textInputAction: TextInputAction.send,
                        onChanged: (value) {
                          // controller.setEmail(value);
                        },
                        // onSubmitted: (value) async {
                        // progressDialog.style(
                        //     message: 'Enviando...');
                        // progressDialog.show();
                        // int resp = await controller
                        //     .gerarToken(tabController.index);
                        // Future.delayed(Duration(seconds: 2), () {
                        //   progressDialog.hide();
                        //   if (resp == 200) {
                        //     Modular.to.pushNamed(
                        //         "/recuperar/recuperarCod/");
                        //   } else {
                        //     buildShowGeneralDialog(context);
                        //   }
                        // });
                        // },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'E-mail',
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "erroValidacaoCampoVazio".i18n();
                          }

                          String pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value)) {
                            return "ErroValidacaoEmailInvalido".i18n();
                          }

                          return null;
                        },
                      ),
                    ),
                  ),
                ],
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
                  child: Observer(builder: (_) {
                    if (recuperarSenhaStore.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return const Text(
                      "Enviar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      recuperarSenhaStore.verificarEmail();
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

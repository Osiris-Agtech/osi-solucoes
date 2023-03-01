import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/recuperar_senha_store.dart';

class CodigoSegurancaPage extends StatefulWidget {
  const CodigoSegurancaPage({Key? key}) : super(key: key);

  @override
  State<CodigoSegurancaPage> createState() => _CodigoSegurancaPageState();
}

class _CodigoSegurancaPageState extends State<CodigoSegurancaPage> {
  RecuperarSenhaStore recuperarSenhaStore = GetIt.I<RecuperarSenhaStore>();
  final _formKey = GlobalKey<FormState>();
  final FocusNode fn1 = FocusNode();
  final FocusNode fn2 = FocusNode();
  final FocusNode fn3 = FocusNode();
  final FocusNode fn4 = FocusNode();

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
                width: MediaQuery.of(context).size.width * .45,
                image: const AssetImage("assets/images/logo_ufmt.png"),
              ),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Preencha com o código de\nsegurança que enviamos no e-mail',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    color: Constants.kGreyText2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  '*Verifique sua caixa de spam e lixeira caso não esteja encontrando o e-mail',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    color: Constants.kGreyText2,
                  ),
                ),
              ),
              const Spacer(),
              Form(
                key: _formKey,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 40,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: recuperarSenhaStore.codigo1,
                        decoration: const InputDecoration(counterText: ''),
                        maxLength: 1,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        showCursor: false,
                        focusNode: fn1,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (value) {
                          // controller.setToken1(value);
                          if (value.isNotEmpty) {
                            FocusScope.of(context).requestFocus(fn2);
                          }
                        },
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "erroValidacaoCampoVazio".i18n();
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: recuperarSenhaStore.codigo2,
                        decoration: const InputDecoration(counterText: ''),
                        maxLength: 1,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        showCursor: false,
                        focusNode: fn2,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (value) {
                          // controller.setToken2(value);
                          if (value.isNotEmpty) {
                            FocusScope.of(context).requestFocus(fn3);
                          } else {
                            FocusScope.of(context).requestFocus(fn1);
                          }
                        },
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "erroValidacaoCampoVazio".i18n();
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: recuperarSenhaStore.codigo3,
                        decoration: const InputDecoration(counterText: ''),
                        maxLength: 1,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        focusNode: fn3,
                        showCursor: false,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (value) {
                          // controller.setToken3(value);
                          if (value.isNotEmpty) {
                            FocusScope.of(context).requestFocus(fn4);
                          } else {
                            FocusScope.of(context).requestFocus(fn2);
                          }
                        },
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "erroValidacaoCampoVazio".i18n();
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: recuperarSenhaStore.codigo4,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: const InputDecoration(counterText: ''),
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        focusNode: fn4,
                        showCursor: false,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (value) {
                          // controller.setToken4(value);
                          if (value.isEmpty) {
                            FocusScope.of(context).requestFocus(fn3);
                          } else {
                            FocusScope.of(context).unfocus();
                          }
                        },
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "erroValidacaoCampoVazio".i18n();
                          }

                          return null;
                        },
                        // onSubmitted: (value) async {
                        // progressDialog.style(message: 'Verificando...');
                        // progressDialog.show();
                        // int resp = await controller.verificarToken();
                        // Future.delayed(Duration(seconds: 2), () {
                        //   print(resp);
                        //   progressDialog.hide();
                        //   if (resp == 200) {
                        //     Modular.to.pushNamed("/recuperar/redefinirSenha/");
                        //   } else {
                        //     buildShowGeneralDialog(context);
                        //   }
                        // });
                        // },
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Insira o código',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: Constants.kGreyText2,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Flexible(
                    child: Text(
                      'Se não recebeu, ',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: Constants.kGreyText,
                      ),
                    ),
                  ),
                  Flexible(
                    child: FittedBox(
                      child: InkWell(
                        onTap: () async {
                          recuperarSenhaStore.enviarCodigo();
                        },
                        child: const Text(
                          'clique aqui',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: Constants.kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'para enviar novamente',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: Constants.kGreyText,
                ),
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
                    "Confirmar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      recuperarSenhaStore.validarCodigo();
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

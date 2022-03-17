import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
// import 'package:osi_solucoes/app//modules/cadastro/cadastro_store.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/app/constants.dart';
import 'package:osi_solucoes/app/modules/cadastro/cadastro_store.dart';

class CadastroPage extends StatefulWidget {
  final String title;
  const CadastroPage({Key? key, this.title = 'CadastroPage'}) : super(key: key);
  @override
  CadastroPageState createState() => CadastroPageState();
}

class CadastroPageState extends State<CadastroPage> {
  final CadastroStore store = Modular.get<CadastroStore>();
  final FocusScopeNode focusNode = FocusScopeNode();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: kBackgroundColor,
            leading: Builder(builder: (_) {
              return Padding(
                padding: EdgeInsets.only(left: size.width * 0.07),
                child: IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onPressed: () => Modular.to.pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                  color: kPrimaryColor,
                ),
              );
            }),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: FocusScope(
                node: focusNode,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.01, left: size.width * 0.1),
                      child: Text(
                        "titlePageCadastro1".i18n(),
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.01, left: size.width * 0.1),
                      child: Text(
                        "titlePageCadastro2".i18n(),
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.02),
                      child: Center(
                        child: Stack(
                          children: [
                            const CircleAvatar(
                              backgroundColor: kPrimaryColor,
                              child: Icon(
                                Icons.person,
                                color: kBackgroundColor,
                                size: 50,
                              ),
                              minRadius: 45,
                            ),
                            Positioned(
                              bottom: 0,
                              right: (size.width * 0.5 - 55),
                              child: Material(
                                borderRadius: BorderRadius.circular(50),
                                elevation: 3,
                                child: const CircleAvatar(
                                  backgroundColor: kSecondBackgroundColor,
                                  child: Icon(Icons.edit_outlined),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.016,
                          left: size.width * 0.13,
                          right: size.width * 0.13),
                      child: formCadastro(
                          controller: store.nome, labelText: "formNome".i18n()),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.02,
                          left: size.width * 0.13,
                          right: size.width * 0.13),
                      child: formCadastro(
                          controller: store.sobrenome,
                          labelText: "formSobrenome".i18n()),
                    ),
                    Observer(builder: (_) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.02,
                            left: size.width * 0.13,
                            right: size.width * 0.13),
                        child: formCadastro(
                            controller: store.cep, labelText: "formCEP".i18n()),
                      );
                    }),
                    Observer(builder: (_) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.02,
                            left: size.width * 0.13,
                            right: size.width * 0.13),
                        child: formCadastro(
                            controller: store.logradouro,
                            labelText: "formLogradouro".i18n()),
                      );
                    }),
                    Observer(builder: (_) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.02,
                            left: size.width * 0.13,
                            right: size.width * 0.13),
                        child: formCadastro(
                            controller: store.complemento,
                            labelText: "formComplemento".i18n()),
                      );
                    }),
                    Observer(builder: (_) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.02,
                            left: size.width * 0.13,
                            right: size.width * 0.13),
                        child: formCadastro(
                            controller: store.bairro,
                            labelText: "formBairro".i18n()),
                      );
                    }),
                    Observer(builder: (_) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.02,
                            left: size.width * 0.13,
                            right: size.width * 0.13),
                        child: formCadastro(
                            controller: store.cidade,
                            labelText: "formCidade".i18n()),
                      );
                    }),
                    Observer(builder: (_) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.02,
                            left: size.width * 0.13,
                            right: size.width * 0.13),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: size.width * 0.34,
                              child: formCadastro(
                                  controller: store.estado,
                                  labelText: "formEstado".i18n()),
                            ),
                            Container(
                                padding: EdgeInsets.only(
                                  left: size.height * 0.02,
                                ),
                                width: size.width * 0.4,
                                child: formCadastro(
                                    controller: store.pais,
                                    labelText: "formPais".i18n())),
                          ],
                        ),
                      );
                    }),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.02,
                          left: size.width * 0.13,
                          right: size.width * 0.13),
                      child: formCadastro(
                          controller: store.email,
                          labelText: "formEmail".i18n()),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.02,
                            left: size.width * 0.13,
                            right: size.width * 0.13),
                        child: Observer(
                          builder: (_) {
                            return formCadastro(
                                controller: store.senha,
                                labelText: "formSenha".i18n());
                          },
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(top: size.height * .04, bottom: 30),
                        child: Center(
                          child: SizedBox(
                            width: size.width * .7,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kPrimaryColor),
                              child: Text(
                                "TextButtonConfirmar".i18n(),
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) {
                                  showCircularProgressIndicator(context);
                                  String response = await store.verificaEmail();
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  if (response == "sucesso") {
                                    store.gerarCodigo();
                                    Navigator.pop(context);
                                    Modular.to.pushNamed("/Cadastro/Confirma");
                                  } else {
                                    showErrorDialog(context, response);
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                }
                              },
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  TextFormField formCadastro(
      {required TextEditingController controller, required String labelText}) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "erroValidacaoCampoVazio".i18n();
        } else if (labelText == "labelTextConsult2".i18n()) {
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(value)) {
            return "ErroValidacaoEmailInvalido".i18n();
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      cursorColor: Colors.grey,
      controller: controller,
      textInputAction: labelText != "labelTextConsult1".i18n()
          ? TextInputAction.next
          : TextInputAction.done,
      keyboardType: labelText == "labelTextConsult2".i18n()
          ? TextInputType.emailAddress
          : labelText == "labelTextConsult3".i18n()
              ? TextInputType.number
              : TextInputType.text,
      textCapitalization: labelText != "labelTextConsult2".i18n() ||
              labelText != "labelTextConsult1".i18n()
          ? TextCapitalization.words
          : TextCapitalization.none,
      onEditingComplete: () async {
        if (labelText == "labelTextConsult1".i18n()) {
          focusNode.unfocus();
          formKey.currentState!.validate();
        } else if (labelText == "labelTextConsult3".i18n()) {
          var result = await store.buscaCEP();
          // ignore: avoid_print
          print(result);
          focusNode.unfocus();
        } else {
          focusNode.nextFocus();
        }
      },
      inputFormatters: labelText == "labelTextConsult3".i18n()
          ? [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ]
          : null,
      obscureText: labelText == "labelTextConsult1".i18n() && store.isObscure
          ? true
          : false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 15),
        alignLabelWithHint: false,
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 16,
        ),
        suffixIcon: labelText == "labelTextConsult1".i18n()
            ? Observer(
                builder: (_) {
                  return IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      padding: const EdgeInsets.only(top: 20),
                      onPressed: () {
                        store.toggleObscure();
                      },
                      icon: store.isObscure
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off));
                },
              )
            : null,
      ),
    );
  }

  showCircularProgressIndicator(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  showErrorDialog(BuildContext context, String error) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            content: Text(
              error,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

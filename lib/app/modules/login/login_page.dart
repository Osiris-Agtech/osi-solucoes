import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/app//modules/login/login_store.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/app/constants.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key? key, this.title = 'LoginPage'}) : super(key: key);
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final LoginStore store = Modular.get<LoginStore>();
  final formKey = GlobalKey<FormState>();
  final FocusNode emailNode = FocusNode();
  final FocusNode senhaNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kSecondBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kSecondBackgroundColor,
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Stack(children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.13),
                      child: SizedBox(
                        child: Image.asset(
                          "assets/images/osiris-logo.png",
                          width: size.width * 0.42,
                        ),
                      ),
                    ),
                    Observer(builder: (_) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.1,
                            left: size.width * 0.06,
                            right: size.width * 0.06),
                        child: formFieldLogin(
                          controllerText: store.email,
                          labelText: 'emailField'.i18n(),
                          isSenha: false,
                          function: () {},
                          isObscure: false,
                        ),
                      );
                    }),
                    Observer(
                      builder: (_) {
                        return Padding(
                            padding: EdgeInsets.only(
                                top: size.height * 0.02,
                                left: size.width * 0.06,
                                right: size.width * 0.06),
                            child: formFieldLogin(
                              controllerText: store.senha,
                              labelText: 'senhaField'.i18n(),
                              isSenha: true,
                              function: store.toggleObscure,
                              isObscure: store.isObscure,
                            ));
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: size.height * .04),
                        child: SizedBox(
                          width: size.width * .7,
                          height: 45,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kPrimaryColor),
                              child: Text(
                                "textButton".i18n(),
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  showCircularProgressIndicator(context);
                                  String response =
                                      await store.vertificaLogin();
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  if (response == "sucesso") {
                                    Modular.to.pushReplacementNamed("/Home/");
                                  } else {
                                    showLoaderDialog(context, response);
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                } else {}
                              }),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * .015),
                      child: TextButton(
                        child: Text(
                          "textTextButton".i18n(),
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: size.height * 0.08, right: size.width * 0.056),
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          Modular.to.pushNamed("/Cadastro/");
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("textTextButton2".i18n(),
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600)),
                            const Icon(
                              Icons.chevron_right,
                              color: kPrimaryColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
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

  showLoaderDialog(BuildContext context, String error) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            content: Text(
              error,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  SizedBox formFieldLogin({
    TextEditingController? controllerText,
    String? labelText,
    required bool isSenha,
    Function? function,
    bool? isObscure,
  }) {
    return SizedBox(
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 1.25,
                vertical: kDefaultPadding * .4),
            child: TextFormField(
              focusNode: !isSenha ? emailNode : senhaNode,
              validator: !isSenha
                  ? (value) {
                      if (value!.isEmpty) {
                        return "erroValidacaoEmailVazio".i18n();
                      } else {
                        String pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(value)) {
                          return "ErroValidacaoEmailInvalido".i18n();
                        } else {
                          return null;
                        }
                      }
                    }
                  : (value) {
                      if (value!.isEmpty) {
                        return "erroValidacaoSenhaVazio".i18n();
                      } else if (value.length < 6) {
                        return "ErroValidacaoSenhaInvalido".i18n();
                      }
                      return null;
                    },
              cursorColor: Colors.grey,
              controller: controllerText,
              textInputAction:
                  isSenha ? TextInputAction.done : TextInputAction.next,
              keyboardType:
                  isSenha ? TextInputType.text : TextInputType.emailAddress,
              obscureText: isSenha ? store.isObscure : false,
              onEditingComplete: () async {
                if (!isSenha) {
                  emailNode.nextFocus();
                } else {
                  senhaNode.unfocus();
                  formKey.currentState!.validate();
                  if (formKey.currentState!.validate()) {
                    showCircularProgressIndicator(context);
                    String response = await store.vertificaLogin();
                    await Future.delayed(const Duration(seconds: 2));
                    if (response == "sucesso") {
                      Modular.to.pushReplacementNamed("/Home/");
                    } else {
                      showLoaderDialog(context, response);
                      await Future.delayed(const Duration(seconds: 2));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  }
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 15),
                alignLabelWithHint: false,
                labelText: labelText,
                suffixIcon: isSenha
                    ? Observer(
                        builder: (_) {
                          return IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              padding: const EdgeInsets.only(top: 25),
                              onPressed: () {
                                function!();
                              },
                              icon: store.isObscure
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off));
                        },
                      )
                    : null,
              ),
            )),
      ),
    );
  }
}

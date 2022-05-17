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
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: kSecondBackgroundColor,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              onVerticalDragCancel: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: size.height - MediaQuery.of(context).viewPadding.top,
                  width: size.width,
                  child: Form(
                    key: formKey,
                    child: Stack(children: [
                      Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(),
                          ),
                          SizedBox(
                            child: Image.asset(
                              "assets/images/osiris-logo.png",
                              width: size.width * 0.42,
                              // height: size.height * 0.082,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(),
                          ),
                          Observer(
                            builder: (_) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  // top: size.height * 0.09,
                                  left: size.width * 0.06,
                                  right: size.width * 0.06,
                                ),
                                child: formFieldLogin(
                                  controllerText: store.email,
                                  labelText: 'emailField'.i18n(),
                                  isSenha: false,
                                  function: () {},
                                  isObscure: false,
                                ),
                              );
                            },
                          ),
                          Observer(
                            builder: (_) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  left: size.width * 0.06,
                                  right: size.width * 0.06,
                                ),
                                child: formFieldLogin(
                                  controllerText: store.senha,
                                  labelText: 'senhaField'.i18n(),
                                  isSenha: true,
                                  function: store.toggleObscure,
                                  isObscure: store.isObscure,
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * .041),
                            child: SizedBox(
                              width: size.width * .7,
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor),
                                child: Text(
                                  "textButton".i18n(),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    showCircularProgressIndicator(context);
                                    String response = await store.login();
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    if (response == "sucesso") {
                                      Modular.to.pushReplacementNamed("/Home/");
                                    } else if (response == "multiple") {
                                      Modular.to.pushNamed(
                                        "/Login/MultiAccounts/",
                                        arguments: store.userList[0],
                                      );
                                    } else {
                                      showLoaderDialog(context, response);
                                      await Future.delayed(
                                          const Duration(seconds: 3));
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          TextButton(
                            child: Text(
                              "textTextButton".i18n(),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {},
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                // top: size.height * 0.06,
                                // bottom: size.height * 0.06,
                                right: size.width * 0.056),
                            alignment: Alignment.bottomRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    Modular.to.pushNamed("/Cadastro/");
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "textTextButton2".i18n(),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: kPrimaryColor,
                                        size: 32,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
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
      height: 80,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              // top: kDefaultPadding * 0.5,
              // bottom: kDefaultPadding * 0.5,
              left: kDefaultPadding * 1.25,
              right: kDefaultPadding * 1.25,
            ),
            child: SizedBox(
              height: 80,
              child: TextFormField(
                cursorHeight: 20,
                focusNode: !isSenha ? emailNode : senhaNode,
                validator: (value) => !isSenha
                    ? store.validateEmail(value)
                    : store.validateSenha(value),
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
                      String response = await store.login();
                      await Future.delayed(const Duration(seconds: 2));
                      if (response == "sucesso") {
                        Modular.to.pushReplacementNamed("/Home/");
                      } else if (response == "multiple") {
                        Modular.to.pushNamed(
                          "/Login/MultiAccounts/",
                          arguments: store.userList[0],
                        );
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
                  contentPadding: isSenha
                      ? const EdgeInsets.only(top: 22)
                      : const EdgeInsets.only(top: 18),
                  alignLabelWithHint: false,
                  hintText: labelText,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: const TextStyle(fontSize: 16),
                  errorStyle: const TextStyle(fontSize: 10, height: 0.6),
                  suffixIcon: isSenha
                      ? Observer(
                          builder: (_) {
                            return IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              padding: const EdgeInsets.only(top: 15),
                              onPressed: () {
                                function!();
                              },
                              icon: store.isObscure
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            );
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:osi_solucoes/app//modules/login/login_store.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/app/constants.dart';
import 'package:osi_solucoes/app/modules/login/components/forgotPassword.dart';
import 'package:osi_solucoes/app/modules/login/components/loadingDialog.dart';
import 'package:osi_solucoes/app/modules/login/components/loginButton.dart';
import 'package:osi_solucoes/app/modules/login/components/registrarButton.dart';

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
  void dispose() {
    super.dispose();
    store.email.clear();
    store.senha.clear();
  }

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
            body: _body(context, size),
          ),
        ),
      ),
    );
  }

  _body(BuildContext context, Size size) async {
    return GestureDetector(
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
                  _expanded(flex: 3),
                  _logo(size),
                  _expanded(flex: 2),
                  _formEmail(size),
                  _formSenha(size),
                  await loginButton(size, formKey, store, context),
                  forgotPassword(),
                  _expanded(flex: 3),
                  registrarButton(size),
                  _expanded(flex: 2),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  _formSenha(Size size) {
    return Observer(
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
    );
  }

  _formEmail(Size size) {
    return Observer(
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
    );
  }

  _logo(Size size) {
    return SizedBox(
      child: Image.asset(
        "assets/images/osiris-logo.png",
        width: size.width * 0.42,
        // height: size.height * 0.082,
      ),
    );
  }

  _expanded({required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(),
    );
  }

  formFieldLogin({
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
                        Modular.to.pushReplacementNamed(
                          "/Login/MultiAccounts/",
                          arguments: {
                            "user": store.userList[0],
                            "isLoggedIn": false,
                          },
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

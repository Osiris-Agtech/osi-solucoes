import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/auth_controller.dart';
import 'package:osi_solucoes/features/presenter/views/login/multi_account_page.dart';
import 'package:osi_solucoes/core/utils/responsive_breakpoints.dart';
import 'package:osi_solucoes/core/utils/spacing.dart';
import '../../viewmodels/login_store.dart';
import '../home/home_page.dart';
import 'components/forgotPassword.dart';
import 'components/loadingDialog.dart';
import 'components/loginButton.dart';
import 'components/registrarButton.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({super.key, this.title = 'LoginPage'});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final AuthController authController = GetIt.I<AuthController>();
  final LoginStore store = GetIt.I<LoginStore>();
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kSecondBackgroundColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Constants.kSecondBackgroundColor,
      ),
      child: SafeArea(
        child: PopScope(
          onPopInvokedWithResult: (_, __) async => false,
          child: Scaffold(
            backgroundColor: Constants.kSecondBackgroundColor,
            body: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = ResponsiveBreakpoints.isDesktop(context);
                final maxWidth = isDesktop ? 450.0 : double.infinity;
                
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  onVerticalDragCancel: () => FocusScope.of(context).unfocus(),
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Padding(
                          padding: Spacing.horizontal(context),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                SizedBox(height: constraints.maxHeight * 0.08),
                                _logo(context),
                                SizedBox(height: constraints.maxHeight * 0.06),
                                _formEmail(context),
                                Spacing.v(Spacing.lg),
                                _formSenha(context),
                                Spacing.v(Spacing.lg),
                                _buildLoginButton(context),
                                Spacing.v(Spacing.md),
                                forgotPassword(),
                                SizedBox(height: constraints.maxHeight * 0.08),
                                _buildRegistrarButton(context),
                                Spacing.v(Spacing.xl),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Observer _formSenha(BuildContext context) {
    return Observer(
      builder: (_) {
        return Padding(
          padding: Spacing.symmetricV(size: Spacing.lg),
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

  Observer _formEmail(BuildContext context) {
    return Observer(
      builder: (_) {
        return formFieldLogin(
          controllerText: store.email,
          labelText: 'emailField'.i18n(),
          isSenha: false,
          function: () {},
          isObscure: false,
        );
      },
    );
  }

  Widget _logo(BuildContext context) {
    final logoWidth = ResponsiveBreakpoints.responsiveWidth(
      context,
      mobile: MediaQuery.of(context).size.width * 0.42,
      tablet: 200,
      desktop: 220,
    );

    return Image.asset(
      "assets/images/logo_ufmt.png",
      width: logoWidth,
      // Garante carregamento correto no web
      errorBuilder: (context, error, stackTrace) {
        print('Erro ao carregar logo: $error');
        return SizedBox(
          width: logoWidth,
          height: 100,
          child: const Center(
            child: Text(
              'OSI Soluções',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 38, 193, 100),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return loginButton(
      MediaQuery.of(context).size,
      formKey,
      store,
      context,
    );
  }

  Widget _buildRegistrarButton(BuildContext context) {
    return registrarButton(
      MediaQuery.of(context).size,
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
            padding: Spacing.symmetric(horizontal: Spacing.xl),
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
                // Correção para web - força repaint correto do campo
                style: const TextStyle(
                  color: Color(0xFF2A2A2A),
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
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
                        store.clearFields();
                        Get.offAll(() => const HomePage());
                      } else if (response == "multiple") {
                        store.clearFields();
                        Get.to(
                          () => MultiAccountsPage(
                            user: store.userList[0],
                            isLoggedIn: false,
                          ),
                        );
                      } else {
                        if (!mounted) return;
                        showLoaderDialog(context, response);
                        await Future.delayed(const Duration(seconds: 2));
                        if (!mounted) return;
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

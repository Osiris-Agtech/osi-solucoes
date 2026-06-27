import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/features/presenter/views/cadastro/cadastro_page.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/views/login/multi_account_page.dart';
import '../../viewmodels/login_store.dart';
import '../home/home_page.dart';
import 'components/auth/auth_widgets.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({super.key, this.title = 'LoginPage'});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final LoginStore store = GetIt.I<LoginStore>();
  final formKey = GlobalKey<FormState>();
  final FocusNode emailNode = FocusNode();
  final FocusNode senhaNode = FocusNode();
  bool _isSubmitting = false;
  String? _feedbackMessage;

  @override
  void dispose() {
    super.dispose();
    store.email.clear();
    store.senha.clear();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) async => false,
      child: AuthScaffold(
        child: AuthPanelCard(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeader(
                  title: 'OSI Soluções',
                  subtitle: 'Acesse sua conta para continuar o trabalho.',
                  badgeText: 'Acesso seguro',
                  showLogo: true,
                ),
                const SizedBox(height: 24),
                _formEmail(context),
                const SizedBox(height: 14),
                _formSenha(context),
                const SizedBox(height: 18),
                if (_feedbackMessage != null) ...[
                  AuthFeedbackMessage(message: _feedbackMessage!),
                  const SizedBox(height: 14),
                ],
                AuthPrimaryButton(
                  label: 'textButton'.i18n(),
                  isLoading: _isSubmitting,
                  onPressed: () => _submitLogin(),
                ),
                const SizedBox(height: 8),
                Center(
                  child: AuthSecondaryAction(
                    label: 'textTextButton'.i18n(),
                    onPressed: () => Get.toNamed(Routes.recuperarSenha),
                  ),
                ),
                const Divider(height: 28),
                Center(
                  child: AuthSecondaryAction(
                    prefixText: 'Ainda não tem acesso?',
                    label: 'textTextButton2'.i18n(),
                    icon: Icons.chevron_right,
                    onPressed: () {
                      Get.to(
                        () => const CadastroPage(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Observer _formSenha(BuildContext context) {
    return Observer(
      builder: (_) {
        return AuthTextField(
          controller: store.senha,
          labelText: 'senhaField'.i18n(),
          focusNode: senhaNode,
          validator: store.validateSenha,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          obscureText: store.isObscure,
          onEditingComplete: _submitLogin,
          suffixIcon: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: store.toggleObscure,
            icon: store.isObscure
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
          ),
        );
      },
    );
  }

  Observer _formEmail(BuildContext context) {
    return Observer(
      builder: (_) {
        return AuthTextField(
          controller: store.email,
          labelText: 'emailField'.i18n(),
          focusNode: emailNode,
          validator: store.validateEmail,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          onEditingComplete: emailNode.nextFocus,
        );
      },
    );
  }

  Future<void> _submitLogin() async {
    senhaNode.unfocus();
    if (_isSubmitting || !(formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isSubmitting = true;
      _feedbackMessage = null;
    });
    final response = await store.login();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (response == 'sucesso') {
      Get.to(() => const HomePage());
    } else if (response == 'multiple') {
      Get.to(
        () => MultiAccountsPage(
          user: store.userList[0],
          isLoggedIn: false,
        ),
      );
    } else {
      setState(() => _feedbackMessage = response);
    }
  }
}

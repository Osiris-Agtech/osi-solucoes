import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/errors/failure.dart';
import 'package:osi_solucoes/features/presenter/viewmodels/cadastro_store.dart';
import 'package:osi_solucoes/features/presenter/views/home/home_page.dart';
import 'package:osi_solucoes/features/presenter/views/login/components/auth/auth_widgets.dart';

class CadastroSimplificadoPage extends StatefulWidget {
  final String title;
  const CadastroSimplificadoPage({super.key, this.title = 'CadastroSimplificadoPage'});

  @override
  CadastroSimplificadoPageState createState() => CadastroSimplificadoPageState();
}

class CadastroSimplificadoPageState extends State<CadastroSimplificadoPage> {
  final CadastroStore store = GetIt.I<CadastroStore>();
  final formKey = GlobalKey<FormState>();
  final FocusNode nomeNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode senhaNode = FocusNode();
  bool _isSubmitting = false;
  String? _feedbackMessage;

  @override
  void dispose() {
    nomeNode.dispose();
    emailNode.dispose();
    senhaNode.dispose();
    store.nome.clear();
    store.email.clear();
    store.senha.clear();
    super.dispose();
  }

  String? _validateNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o nome completo';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o email';
    }
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Email inválido';
    }
    return null;
  }

  String? _validateSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe a senha';
    }
    if (value.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    return null;
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
                  title: 'Criar Conta',
                  subtitle: 'Preencha os dados abaixo para se cadastrar.',
                  badgeText: 'Cadastro rápido',
                ),
                const SizedBox(height: 24),
                _formNome(context),
                const SizedBox(height: 14),
                _formEmail(context),
                const SizedBox(height: 14),
                _formSenha(context),
                const SizedBox(height: 18),
                if (_feedbackMessage != null) ...[
                  AuthFeedbackMessage(message: _feedbackMessage!),
                  const SizedBox(height: 14),
                ],
                AuthPrimaryButton(
                  label: 'Cadastrar',
                  isLoading: _isSubmitting,
                  onPressed: () => _submitCadastro(),
                ),
                const SizedBox(height: 8),
                Center(
                  child: AuthSecondaryAction(
                    prefixText: 'Já tem uma conta?',
                    label: 'Fazer login',
                    icon: Icons.chevron_right,
                    onPressed: () => Get.back(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Observer _formNome(BuildContext context) {
    return Observer(
      builder: (_) {
        return AuthTextField(
          controller: store.nome,
          labelText: 'Nome completo',
          focusNode: nomeNode,
          validator: _validateNome,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          onEditingComplete: emailNode.requestFocus,
        );
      },
    );
  }

  Observer _formEmail(BuildContext context) {
    return Observer(
      builder: (_) {
        return AuthTextField(
          controller: store.email,
          labelText: 'Email',
          focusNode: emailNode,
          validator: _validateEmail,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          onEditingComplete: senhaNode.requestFocus,
        );
      },
    );
  }

  Observer _formSenha(BuildContext context) {
    return Observer(
      builder: (_) {
        return AuthTextField(
          controller: store.senha,
          labelText: 'Senha',
          focusNode: senhaNode,
          validator: _validateSenha,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          obscureText: store.isObscure,
          onEditingComplete: _submitCadastro,
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

  Future<void> _submitCadastro() async {
    senhaNode.unfocus();
    if (_isSubmitting || !(formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isSubmitting = true;
      _feedbackMessage = null;
    });

    store.sobrenome.text = "";
    store.telefone.text = "00000000000";

    final emailCheck = await store.verificaEmail();
    if (!mounted) return;

    if (emailCheck == FailureMessage.userNotFoundMessage) {
      final response = await store.cadastraUser();
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      if (response == 'sucesso') {
        store.nome.clear();
        store.email.clear();
        store.senha.clear();
        Get.offAll(() => const HomePage());
      } else {
        setState(() => _feedbackMessage = response);
      }
    } else {
      setState(() {
        _isSubmitting = false;
        _feedbackMessage = emailCheck;
      });
    }
  }
}

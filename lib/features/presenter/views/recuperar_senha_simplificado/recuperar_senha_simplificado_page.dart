import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/features/data/repositories/recuperarSenha/recuperar_senha_repository.dart';
import 'package:osi_solucoes/features/presenter/routes/routes.dart';
import 'package:osi_solucoes/features/presenter/views/login/components/auth/auth_widgets.dart';

class RecuperarSenhaSimplificadoPage extends StatefulWidget {
  final String title;
  const RecuperarSenhaSimplificadoPage({
    super.key,
    this.title = 'RecuperarSenhaSimplificadoPage',
  });

  @override
  RecuperarSenhaSimplificadoPageState createState() =>
      RecuperarSenhaSimplificadoPageState();
}

class RecuperarSenhaSimplificadoPageState
    extends State<RecuperarSenhaSimplificadoPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _emailNode = FocusNode();
  final _novaSenhaNode = FocusNode();
  final _confirmarSenhaNode = FocusNode();

  bool _isStep2 = false;
  bool _isSubmitting = false;
  bool _obscureNovaSenha = true;
  bool _obscureConfirmarSenha = true;
  String? _feedbackMessage;
  int? _usuarioId;

  @override
  void dispose() {
    _emailController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    _emailNode.dispose();
    _novaSenhaNode.dispose();
    _confirmarSenhaNode.dispose();
    super.dispose();
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

  String? _validateNovaSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe a nova senha';
    }
    if (value.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  String? _validateConfirmarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirme a nova senha';
    }
    if (value != _novaSenhaController.text) {
      return 'Senhas não conferem';
    }
    return null;
  }

  Future<void> _verificarEmail() async {
    _emailNode.unfocus();
    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSubmitting = true;
      _feedbackMessage = null;
    });

    final email = _emailController.text.trim();
    final repository = GetIt.I<RecuperarSenhaRepository>();
    final result = await repository.buscarUsuario(email);

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isSubmitting = false;
          _feedbackMessage = failure.message;
        });
      },
      (usuario) {
        if (usuario.id == null) {
          setState(() {
            _isSubmitting = false;
            _feedbackMessage = 'Erro ao identificar o usuário';
          });
        } else {
          setState(() {
            _isSubmitting = false;
            _usuarioId = usuario.id;
            _isStep2 = true;
            _feedbackMessage = null;
          });
        }
      },
    );
  }

  Future<void> _alterarSenha() async {
    _confirmarSenhaNode.unfocus();
    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSubmitting = true;
      _feedbackMessage = null;
    });

    final repository = GetIt.I<RecuperarSenhaRepository>();
    final result =
        await repository.alterarSenha(_usuarioId!, _novaSenhaController.text);

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isSubmitting = false;
          _feedbackMessage = failure.message;
        });
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha alterada com sucesso')),
        );
        Get.offNamedUntil(Routes.loginPage, (route) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) async => false,
      child: AuthScaffold(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        child: AuthPanelCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeader(
                  title: 'Recuperar Senha',
                  subtitle: 'Redefina sua senha de acesso.',
                  badgeText: 'Recuperação rápida',
                ),
                const SizedBox(height: 24),
                if (!_isStep2) ...[
                  _formEmail(),
                  const SizedBox(height: 14),
                ],
                if (_isStep2) ...[
                  _formNovaSenha(),
                  const SizedBox(height: 14),
                  _formConfirmarSenha(),
                  const SizedBox(height: 14),
                ],
                const SizedBox(height: 18),
                if (_feedbackMessage != null) ...[
                  AuthFeedbackMessage(message: _feedbackMessage!),
                  const SizedBox(height: 14),
                ],
                AuthPrimaryButton(
                  label: _isStep2 ? 'Alterar' : 'Verificar',
                  isLoading: _isSubmitting,
                  onPressed: _isStep2 ? _alterarSenha : _verificarEmail,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formEmail() {
    return AuthTextField(
      controller: _emailController,
      labelText: 'Email',
      focusNode: _emailNode,
      validator: _validateEmail,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.emailAddress,
      onEditingComplete: _verificarEmail,
    );
  }

  Widget _formNovaSenha() {
    return AuthTextField(
      controller: _novaSenhaController,
      labelText: 'Nova Senha',
      focusNode: _novaSenhaNode,
      validator: _validateNovaSenha,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      obscureText: _obscureNovaSenha,
      onEditingComplete: () => _confirmarSenhaNode.requestFocus(),
      suffixIcon: IconButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: () =>
            setState(() => _obscureNovaSenha = !_obscureNovaSenha),
        icon: Icon(
          _obscureNovaSenha ? Icons.visibility : Icons.visibility_off,
        ),
      ),
    );
  }

  Widget _formConfirmarSenha() {
    return AuthTextField(
      controller: _confirmarSenhaController,
      labelText: 'Confirmar Nova Senha',
      focusNode: _confirmarSenhaNode,
      validator: _validateConfirmarSenha,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      obscureText: _obscureConfirmarSenha,
      onEditingComplete: _alterarSenha,
      suffixIcon: IconButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: () =>
            setState(() => _obscureConfirmarSenha = !_obscureConfirmarSenha),
        icon: Icon(
          _obscureConfirmarSenha ? Icons.visibility : Icons.visibility_off,
        ),
      ),
    );
  }
}

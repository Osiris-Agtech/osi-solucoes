import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
// import 'package:osi_solucoes/app//modules/cadastro/cadastro_store.dart';
import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/login/components/auth/auth_widgets.dart';

import '../../../../core/errors/failure.dart';
import '../../viewmodels/cadastro_store.dart';
import '../ajuste/resultadoajuste_page.dart';
import '../home/home_page.dart';
import 'components/cadastro_form_section.dart';

class CadastroPage extends StatefulWidget {
  final String title;
  const CadastroPage({super.key, this.title = 'CadastroPage'});
  @override
  CadastroPageState createState() => CadastroPageState();
}

class CadastroPageState extends State<CadastroPage> {
  // final CadastroStore store = Modular.get<CadastroStore>();
  CadastroStore store = GetIt.I<CadastroStore>();
  final FocusScopeNode focusNode = FocusScopeNode();
  final formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  String? _feedbackMessage;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kSecondBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Constants.kSecondBackgroundColor,
      ),
      child: AuthScaffold(
        maxWidth: 680,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, size: 28),
            color: Constants.kPrimaryColor,
          ),
        ),
        child: AuthPanelCard(
          child: Form(
            key: formKey,
            child: FocusScope(
              node: focusNode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthHeader(
                    title:
                        '${"titlePageCadastro1".i18n()} ${"titlePageCadastro2".i18n()}',
                    subtitle: 'Informe seus dados para criar o acesso.',
                    badgeText: 'Cadastro',
                  ),
                  const SizedBox(height: 22),
                  _personalSection(),
                  const SizedBox(height: 14),
                  _addressSection(),
                  const SizedBox(height: 14),
                  _credentialsSection(),
                  if (_feedbackMessage != null) ...[
                    const SizedBox(height: 16),
                    AuthFeedbackMessage(message: _feedbackMessage!),
                  ],
                  const SizedBox(height: 20),
                  AuthPrimaryButton(
                    label: 'TextButtonConfirmar'.i18n(),
                    isLoading: _isSubmitting,
                    onPressed: _submitCadastro,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  Widget _personalSection() {
    return CadastroFormSection(
      title: 'Dados pessoais',
      icon: Icons.badge_outlined,
      children: [
        Observer(builder: (_) {
          return formCadastro(
            controller: store.nome,
            labelText: 'formNome'.i18n(),
          );
        }),
        Observer(builder: (_) {
          return formCadastro(
            controller: store.sobrenome,
            labelText: 'formSobrenome'.i18n(),
          );
        }),
        Observer(builder: (_) {
          return formCadastro(
            controller: store.telefone,
            labelText: 'Telefone',
            keyboardType: TextInputType.phone,
          );
        }),
      ],
    );
  }

  Widget _addressSection() {
    return CadastroFormSection(
      title: 'Contato e endereço',
      icon: Icons.location_on_outlined,
      children: [
        Observer(builder: (_) {
          return formCadastro(
            controller: store.cep,
            labelText: 'formCEP'.i18n(),
            opcional: true,
            isCep: true,
          );
        }),
        Observer(builder: (_) {
          return formCadastro(
            controller: store.logradouro,
            labelText: 'formLogradouro'.i18n(),
            opcional: true,
          );
        }),
        Observer(builder: (_) {
          return formCadastro(
            controller: store.complemento,
            labelText: 'formComplemento'.i18n(),
            opcional: true,
          );
        }),
        Observer(builder: (_) {
          return formCadastro(
            controller: store.bairro,
            labelText: 'formBairro'.i18n(),
            opcional: true,
          );
        }),
        Observer(builder: (_) {
          return formCadastro(
            controller: store.cidade,
            labelText: 'formCidade'.i18n(),
            opcional: true,
          );
        }),
        Observer(builder: (_) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final fieldWidth = constraints.maxWidth < 520
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: formCadastro(
                      controller: store.estado,
                      labelText: 'formEstado'.i18n(),
                      opcional: true,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: formCadastro(
                      controller: store.pais,
                      labelText: 'formPais'.i18n(),
                      opcional: true,
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ],
    );
  }

  Widget _credentialsSection() {
    return CadastroFormSection(
      title: 'Credenciais',
      icon: Icons.lock_outline,
      children: [
        formCadastro(
          controller: store.email,
          labelText: 'formEmail'.i18n(),
          isEmail: true,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
        ),
        Observer(builder: (_) {
          return formCadastro(
            controller: store.senha,
            labelText: 'formSenha'.i18n(),
            isPassword: true,
            textCapitalization: TextCapitalization.none,
          );
        }),
      ],
    );
  }

  AuthTextField formCadastro({
    required TextEditingController controller,
    required String labelText,
    bool? opcional,
    bool isEmail = false,
    bool isPassword = false,
    bool isCep = false,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
  }) {
    return AuthTextField(
      controller: controller,
      labelText: labelText,
      optional: opcional != null,
      validator: (value) {
        if (opcional != null) {
          return null;
        }

        if (value!.isEmpty) {
          return "erroValidacaoCampoVazio".i18n();
        }
        if (isEmail) {
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(value)) {
            return "ErroValidacaoEmailInvalido".i18n();
          } else {
            return null;
          }
        }
        return null;
      },
      textInputAction: isPassword ? TextInputAction.done : TextInputAction.next,
      keyboardType: keyboardType ??
          (isEmail
              ? TextInputType.emailAddress
              : isCep
                  ? TextInputType.number
                  : TextInputType.text),
      textCapitalization: textCapitalization ?? TextCapitalization.words,
      obscureText: isPassword
          ? store.isObscure
              ? false
              : true
          : false,
      onEditingComplete: () async {
        if (isPassword) {
          focusNode.unfocus();
          formKey.currentState!.validate();
        } else if (isCep) {
          showCircularProgressIndicator(context);
          await store.buscaCEP();
          if (mounted) Navigator.pop(context);
          focusNode.nextFocus();
        } else {
          focusNode.nextFocus();
        }
      },
      onChanged: (String value) async {
        if (isCep && value.length == 10) {
          showCircularProgressIndicator(context);
          await store.buscaCEP();
          if (mounted) Navigator.pop(context);
          focusNode.nextFocus();
        }
      },
      inputFormatters: isCep
          ? [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ]
          : null,
      suffixIcon: isPassword
          ? Observer(
              builder: (_) {
                return IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: store.toggleObscure,
                  icon: store.isObscure
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                );
              },
            )
          : null,
    );
  }

  Future<void> _submitCadastro() async {
    if (_isSubmitting || !(formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isSubmitting = true;
      _feedbackMessage = null;
    });
    final response = await store.verificaEmail();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    if (response == FailureMessage.userNotFoundMessage) {
      final res = await store.cadastraUser();
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      if (res == 'sucesso') {
        setState(() => _isSubmitting = false);
        showDoneAnimation(context);
        await Future.delayed(const Duration(milliseconds: 1400));
        Get.offAll(() => const HomePage());
      } else {
        setState(() {
          _isSubmitting = false;
          _feedbackMessage = res;
        });
      }
    } else {
      setState(() {
        _isSubmitting = false;
        _feedbackMessage = response;
      });
    }
  }

  void showCircularProgressIndicator(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

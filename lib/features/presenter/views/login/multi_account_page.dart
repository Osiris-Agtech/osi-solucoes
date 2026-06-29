import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/services/local_storage.dart';
import 'package:osi_solucoes/features/presenter/views/home/home_page.dart';
import 'package:osi_solucoes/features/presenter/views/login/components/auth/account_selection_card.dart';
import 'package:osi_solucoes/features/presenter/views/login/components/auth/auth_widgets.dart';
import 'package:osi_solucoes/features/presenter/views/login/login_page.dart';

import '../../models/usuario/usuario_model.dart';
import '../../viewmodels/auth_controller.dart';

class MultiAccountsPage extends StatefulWidget {
  final Usuario user;
  final bool isLoggedIn;
  const MultiAccountsPage(
      {super.key, required this.user, required this.isLoggedIn});

  @override
  State<MultiAccountsPage> createState() => _MultiAccountsPageState();
}

class _MultiAccountsPageState extends State<MultiAccountsPage> {
  // final appController = Modular.get<AppController>();
  AuthController authController = GetIt.I<AuthController>();
  int? _loadingIndex;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kSecondBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Constants.kSecondBackgroundColor,
      ),
      child: AuthScaffold(
        maxWidth: 760,
        child: AuthPanelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                title: 'Escolha a conta',
                subtitle:
                    'Você possui vínculo com mais de uma conta. Selecione para avançar.',
                badgeText: 'Conta ativa',
              ),
              const SizedBox(height: 22),
              _buildAccounts(context),
              if ((widget.user.contas ?? []).length > 1) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Constants.kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: _goBack,
                    child: const Text('Voltar'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccounts(BuildContext context) {
    final contas = widget.user.contas ?? [];
    if (contas.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthFeedbackMessage(
            message:
                'Nenhuma conta vinculada foi encontrada para este usuário.',
            type: AuthFeedbackType.warning,
          ),
          const SizedBox(height: 14),
          AuthPrimaryButton(
            label: 'Voltar ao login',
            onPressed: _goBack,
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth < 520
            ? constraints.maxWidth
            : (constraints.maxWidth - 12) / 2;
        return Wrap(
          runSpacing: 12,
          spacing: 12,
          children: [
            for (var index = 0; index < contas.length; index++)
              SizedBox(
                width: cardWidth.clamp(0.0, 260.0).toDouble(),
                child: AccountSelectionCard(
                  name: contas[index].conta?.nome ?? 'Conta',
                  role: contas[index].cargo?.cargo ?? 'Vínculo',
                  imageUrl: contas[index].conta?.imagem,
                  isLoading: _loadingIndex == index,
                  onTap: () => _selectAccount(index),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _selectAccount(int index) async {
    final contas = widget.user.contas ?? [];
    if (_loadingIndex != null || index >= contas.length) return;
    setState(() => _loadingIndex = index);
    authController.usuario = widget.user;
    authController.usuario.selected_conta = contas[index];
    await LocalStorage().storageUser(authController.usuario);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Get.offAll(() => const HomePage());
  }

  void _goBack() {
    if (widget.isLoggedIn) {
      Get.back();
    } else {
      Get.to(() => const LoginPage());
    }
  }
}

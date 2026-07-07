import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../widgets/common/app_floating_action_button.dart';
import '../../models/cargo/cargo_model.dart';
import '../../viewmodels/gerenciar_equipe_store.dart';
import '../../widgets/common/app_page_header_sliver.dart';
import '../../widgets/common/app_panel_card.dart';

class DetalhesUsuarioPage extends StatefulWidget {
  const DetalhesUsuarioPage({super.key});

  @override
  State<DetalhesUsuarioPage> createState() => _DetalhesUsuarioPageState();
}

class _DetalhesUsuarioPageState extends State<DetalhesUsuarioPage> {
  GerenciarEquipeStore store = GetIt.I<GerenciarEquipeStore>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await store.buscarCargos();
      store.setInitialCargo();
    });
  }

  @override
  void dispose() {
    super.dispose();
    store.clearDatalhes();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Constants.kSecondBackgroundColor,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              AppPageHeaderSliver(
                title: store.usuarioSelecionado.nome ?? 'Detalhes do Usuário',
                subtitle: 'Visualização e atualização de informações',
                onBack: () => Get.back(),
                expandedHeight: 120,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: AppPanelCard(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        _infoTile(
                          label: 'Nome',
                          value: store.usuarioSelecionado.nome ?? '',
                          isFirst: true,
                        ),
                        const Divider(height: 1),
                        _toggleTile(
                          label: 'Ativo',
                          value: store.ativoIsChanged,
                          onChanged: (v) => store.setAtivo(v),
                        ),
                        const Divider(height: 1),
                        if (store.usuarioSelecionado.selected_conta?.cargo
                                ?.cargo?.toLowerCase() ==
                            "dono")
                          _infoTile(
                            label: 'Cargo',
                            value: 'Dono',
                            valueColor: Constants.kPrimaryColor,
                          )
                        else
                          _dropdownTile(
                            label: 'Cargo',
                            value: store.cargoSelecionadoDetalhesPage,
                            items: store.cargosList,
                            itemLabel: (Cargo c) => c.cargo ?? '-',
                            onChanged: (v) {
                              if (v != null) store.setCargoDetalhesPage(v);
                            },
                          ),
                        const Divider(height: 1),
                        _infoTile(
                          label: 'E-mail',
                          value: store.usuarioSelecionado.email ??
                              'E-mail não encontrado',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmarDescadastro(context),
                      icon: const Icon(Icons.person_remove_alt_1),
                      label: const Text('Descadastrar da conta'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(color: Colors.red.shade700),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: AppFloatingActionButton(
            heroTag: 'salvar_usuario',
            label: 'Salvar',
            onPressed: () {
              store.alterarUsuario();
            },
          ),
        ),
      ),
    );
  }

  Widget _infoTile({
    required String label,
    required String value,
    bool isFirst = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: isFirst ? 8 : 14,
        bottom: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Constants.kGreyMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Constants.kText2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleTile({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 6, bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Constants.kGreyMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: Constants.kPrimaryColor,
            activeThumbColor: Colors.white,
            inactiveTrackColor: Constants.kGreyText2,
            inactiveThumbColor: Colors.white,
          ),
          const Spacer(),
          Text(
            value ? 'Ativo' : 'Inativo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: value ? Constants.kPrimaryColor : Constants.kGreyText2,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _dropdownTile<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Constants.kGreyMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                icon: const Icon(
                  Icons.expand_more,
                  color: Constants.kPrimaryColor,
                ),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Constants.kText2,
                ),
                items: items.map((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(itemLabel(item)),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarDescadastro(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Descadastrar usuário'),
          content: const Text(
            'Este usuário será removido apenas da conta atual. Deseja continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Descadastrar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await store.descadastrarUsuarioDaConta();
    }
  }
}

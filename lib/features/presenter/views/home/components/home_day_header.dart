import 'package:flutter/material.dart';

import '../models/home_panel_view_data.dart';
import 'home_panel_shared.dart';

class HomeDayHeader extends StatelessWidget {
  final HomeHeaderViewData data;
  final VoidCallback? onSwitchAccount;
  final VoidCallback? onLogout;

  /// 5 taps no saudação → abre AdaptiveAdminPage (apenas desenvolvedor).
  final VoidCallback? onSecretTriggered;

  const HomeDayHeader({
    super.key,
    required this.data,
    this.onSwitchAccount,
    this.onLogout,
    this.onSecretTriggered,
  });

  @override
  Widget build(BuildContext context) {
    final headerContent = _HeaderContent(
      data: data,
      onSwitchAccount: onSwitchAccount,
      onLogout: onLogout,
      onSecretTriggered: onSecretTriggered,
    );

    return HomePanelCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 520;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [headerContent],
            );
          }

          return Row(
            children: [
              Expanded(child: headerContent),
            ],
          );
        },
      ),
    );
  }
}

enum _AccountAction { switchAccount, logout }

class _HeaderContent extends StatelessWidget {
  final HomeHeaderViewData data;
  final VoidCallback? onSwitchAccount;
  final VoidCallback? onLogout;
  final VoidCallback? onSecretTriggered;

  const _HeaderContent({
    required this.data,
    required this.onSwitchAccount,
    required this.onLogout,
    required this.onSecretTriggered,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _HeaderText(
            data: data,
            onSecretTriggered: onSecretTriggered,
          )),
          if (_hasActions) ...[
            const SizedBox(width: 8),
            _AccountActionsMenu(
              canSwitchAccount: data.canSwitchAccount,
              onSwitchAccount: onSwitchAccount,
              onLogout: onLogout,
            ),
          ],
        ],
      );

  bool get _hasActions =>
      (data.canSwitchAccount && onSwitchAccount != null) || onLogout != null;
}

class _HeaderText extends StatefulWidget {
  final HomeHeaderViewData data;
  final VoidCallback? onSecretTriggered;

  const _HeaderText({
    required this.data,
    required this.onSecretTriggered,
  });

  @override
  State<_HeaderText> createState() => _HeaderTextState();
}

class _HeaderTextState extends State<_HeaderText> {
  int _secretTapCount = 0;

  void _handleGreetingTap() {
    if (widget.onSecretTriggered == null) return;
    _secretTapCount++;
    if (_secretTapCount >= 5) {
      _secretTapCount = 0;
      widget.onSecretTriggered!.call();
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _handleGreetingTap,
            child: Text(
              widget.data.greeting,
              style: homeTitleStyle(20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          HomeBadge(icon: Icons.badge_outlined, label: widget.data.roleLabel),
        ],
      );
}

class _AccountActionsMenu extends StatelessWidget {
  final bool canSwitchAccount;
  final VoidCallback? onSwitchAccount;
  final VoidCallback? onLogout;

  const _AccountActionsMenu({
    required this.canSwitchAccount,
    required this.onSwitchAccount,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) => PopupMenuButton<_AccountAction>(
        tooltip: 'Ações da conta',
        icon: const Icon(Icons.more_horiz_rounded),
        onSelected: (action) {
          switch (action) {
            case _AccountAction.switchAccount:
              onSwitchAccount?.call();
              break;
            case _AccountAction.logout:
              onLogout?.call();
              break;
          }
        },
        itemBuilder: (context) => [
          if (canSwitchAccount && onSwitchAccount != null)
            const PopupMenuItem(
              value: _AccountAction.switchAccount,
              child: _AccountActionItem(
                icon: Icons.swap_horiz_rounded,
                label: 'Trocar conta',
              ),
            ),
          if (onLogout != null)
            const PopupMenuItem(
              value: _AccountAction.logout,
              child: _AccountActionItem(
                icon: Icons.logout_rounded,
                label: 'Sair',
                isDestructive: true,
              ),
            ),
        ],
      );
}

class _AccountActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;

  const _AccountActionItem({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFDC2626) : Colors.black87;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}

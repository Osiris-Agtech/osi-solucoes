import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import '../models/home_panel_view_data.dart';
import 'home_panel_shared.dart';

class HomeDayHeader extends StatelessWidget {
  final HomeHeaderViewData data;
  final VoidCallback? onOpenTodayTasks;
  final VoidCallback? onSwitchAccount;
  final VoidCallback? onLogout;

  const HomeDayHeader({
    super.key,
    required this.data,
    this.onOpenTodayTasks,
    this.onSwitchAccount,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final button = _TodayTasksButton(onPressed: onOpenTodayTasks);
    final headerContent = _HeaderContent(
      data: data,
      onSwitchAccount: onSwitchAccount,
      onLogout: onLogout,
    );

    return HomePanelCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 520;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                headerContent,
                if (data.canOpenTasks && onOpenTodayTasks != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(width: double.infinity, child: button),
                ],
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: headerContent),
              const SizedBox(width: 12),
              if (data.canOpenTasks && onOpenTodayTasks != null) button,
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

  const _HeaderContent({
    required this.data,
    required this.onSwitchAccount,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _HeaderText(data: data)),
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

class _HeaderText extends StatelessWidget {
  final HomeHeaderViewData data;

  const _HeaderText({required this.data});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.greeting,
            style: homeTitleStyle(20),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          HomeBadge(icon: Icons.badge_outlined, label: data.roleLabel),
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

class _TodayTasksButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _TodayTasksButton({required this.onPressed});

  @override
  Widget build(BuildContext context) => FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.today_rounded, size: 18),
        label: const Text('Ver tarefas de hoje'),
        style: FilledButton.styleFrom(
          backgroundColor: Constants.kPrimaryColor,
          foregroundColor: Colors.white,
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import '../models/home_panel_view_data.dart';
import 'home_panel_shared.dart';

class HomeDayHeader extends StatelessWidget {
  final HomeHeaderViewData data;
  final VoidCallback? onOpenTodayTasks;

  const HomeDayHeader({super.key, required this.data, this.onOpenTodayTasks});

  @override
  Widget build(BuildContext context) {
    final button = _TodayTasksButton(onPressed: onOpenTodayTasks);

    return HomePanelCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 520;
          final textContent = _HeaderText(data: data);

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                textContent,
                if (data.canOpenTasks && onOpenTodayTasks != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(width: double.infinity, child: button),
                ],
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: textContent),
              const SizedBox(width: 12),
              if (data.canOpenTasks && onOpenTodayTasks != null) button,
            ],
          );
        },
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final HomeHeaderViewData data;

  const _HeaderText({required this.data});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.greeting, style: homeTitleStyle(20)),
          const SizedBox(height: 4),
          Text(data.accountContext, style: homeBodyStyle(Colors.black87)),
          const SizedBox(height: 6),
          HomeBadge(icon: Icons.badge_outlined, label: data.roleLabel),
        ],
      );
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

import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import '../models/home_panel_view_data.dart';
import 'home_panel_shared.dart';

class HomeDayHeader extends StatelessWidget {
  final HomeHeaderViewData data;

  /// 5 taps no saudação → abre AdaptiveAdminPage (apenas desenvolvedor).
  final VoidCallback? onSecretTriggered;

  const HomeDayHeader({
    super.key,
    required this.data,
    this.onSecretTriggered,
  });

  @override
  Widget build(BuildContext context) => _HeaderText(
        data: data,
        onSecretTriggered: onSecretTriggered,
      );
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

  String _formattedDate() {
    final now = DateTime.now();
    final months = [
      'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
    ];
    final weekdays = [
      'domingo', 'segunda-feira', 'terça-feira', 'quarta-feira',
      'quinta-feira', 'sexta-feira', 'sábado',
    ];
    return '${weekdays[now.weekday % 7]}, ${now.day} de ${months[now.month - 1]}';
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
          const SizedBox(height: 2),
          Text(
            _formattedDate(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Constants.kGreyText,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          HomeBadge(icon: Icons.badge_outlined, label: widget.data.roleLabel),
        ],
      );
}



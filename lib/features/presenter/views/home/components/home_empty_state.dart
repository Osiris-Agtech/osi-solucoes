import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import 'home_panel_shared.dart';

class HomeEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const HomeEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Constants.kPrimaryColor, size: 32),
        const SizedBox(height: 10),
        Text(title, style: homeTitleStyle(16)),
        const SizedBox(height: 4),
        Text(message, style: homeBodyStyle(Colors.black54)),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ],
    );
  }
}

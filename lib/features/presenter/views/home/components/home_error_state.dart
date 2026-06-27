import 'package:flutter/material.dart';

import 'home_empty_state.dart';
import 'home_panel_shared.dart';

class HomeErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const HomeErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return HomePanelCard(
      child: HomeEmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Não foi possível carregar a Home',
        message: message,
        actionLabel: 'Tentar novamente',
        onAction: onRetry,
      ),
    );
  }
}

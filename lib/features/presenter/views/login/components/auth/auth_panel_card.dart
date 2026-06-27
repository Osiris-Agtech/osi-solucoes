import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AuthPanelCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AuthPanelCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Constants.kBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AuthBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const AuthBadge({
    super.key,
    required this.text,
    this.color = Constants.kPrimaryColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

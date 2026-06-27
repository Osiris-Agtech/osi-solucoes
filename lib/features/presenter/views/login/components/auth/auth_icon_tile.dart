import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AuthIconTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const AuthIconTile({
    super.key,
    required this.icon,
    this.color = Constants.kPrimaryColor,
    this.size = 46,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: color, size: size * 0.52),
      ),
    );
  }
}

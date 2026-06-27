import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/login/components/auth/auth_badge.dart';
import 'package:osi_solucoes/features/presenter/views/login/components/auth/auth_icon_tile.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? badgeText;
  final IconData icon;
  final bool showLogo;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.badgeText,
    this.icon = Icons.lock_outline,
    this.showLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            showLogo ? const _AuthLogo() : AuthIconTile(icon: icon),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Constants.kText2,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Constants.kGreyText,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (badgeText != null) ...[
          const SizedBox(height: 16),
          AuthBadge(text: badgeText!),
        ],
      ],
    );
  }
}

class _AuthLogo extends StatelessWidget {
  const _AuthLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/osiris-logo.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const AuthIconTile(icon: Icons.eco_outlined, size: 58);
          },
        ),
      ),
    );
  }
}

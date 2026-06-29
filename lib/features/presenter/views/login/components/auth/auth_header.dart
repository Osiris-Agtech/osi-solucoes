import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/login/components/auth/auth_badge.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? badgeText;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
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
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Constants.kGreyText,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
        if (badgeText != null) ...[
          const SizedBox(height: 16),
          AuthBadge(text: badgeText!),
        ],
      ],
    );
  }
}

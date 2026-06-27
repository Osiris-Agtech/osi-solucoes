import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

enum AuthFeedbackType { error, warning, success }

class AuthFeedbackMessage extends StatelessWidget {
  final String message;
  final AuthFeedbackType type;

  const AuthFeedbackMessage({
    super.key,
    required this.message,
    this.type = AuthFeedbackType.error,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      AuthFeedbackType.error => Constants.kErrorColor,
      AuthFeedbackType.warning => Constants.kWarninngColor,
      AuthFeedbackType.success => Constants.kPrimaryColor,
    };
    final icon = switch (type) {
      AuthFeedbackType.error => Icons.error_outline,
      AuthFeedbackType.warning => Icons.warning_amber_rounded,
      AuthFeedbackType.success => Icons.check_circle_outline,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Constants.kGreyText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

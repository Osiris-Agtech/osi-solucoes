import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AppValidationMessage extends StatelessWidget {
  final String? message;
  final IconData? icon;

  const AppValidationMessage({
    super.key,
    this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Constants.kErrorColor),
            const SizedBox(width: 4),
          ],
          Text(
            message!,
            style: const TextStyle(
              fontSize: 12,
              color: Constants.kErrorColor,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

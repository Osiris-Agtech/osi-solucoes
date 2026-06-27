import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AuthSecondaryAction extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final String? prefixText;
  final IconData? icon;

  const AuthSecondaryAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.prefixText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Constants.kPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      onPressed: onPressed,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          if (prefixText != null)
            Text(
              '$prefixText ',
              style: const TextStyle(
                color: Constants.kGreyText,
                fontWeight: FontWeight.w500,
              ),
            ),
          Text(label),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 17),
          ],
        ],
      ),
    );
  }
}

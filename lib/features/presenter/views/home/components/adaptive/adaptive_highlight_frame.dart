import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AdaptiveHighlightFrame extends StatelessWidget {
  final Widget child;
  final String? label;
  final String? reason;

  const AdaptiveHighlightFrame({
    super.key,
    required this.child,
    this.label,
    this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Constants.kPrimaryColor.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Constants.kPrimaryColor.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.only(top: 28),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2, left: 2, right: 2),
              child: child,
            ),
            Positioned(
              top: -4,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Constants.kPrimaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 13,
                      color: Constants.kPrimaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label ?? 'Destaque',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Constants.kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

enum AppBadgeTone { primary, success, warning, danger, neutral }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeTone tone;
  final IconData? icon;
  final Color? color;
  final double? maxWidth;
  final String? tooltip;

  const AppBadge({
    super.key,
    required this.label,
    this.tone = AppBadgeTone.neutral,
    this.icon,
    this.color,
    this.maxWidth,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? _toneColor(tone);
    Widget badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: badgeColor),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );

    if (maxWidth != null) {
      badge = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        child: badge,
      );
    }

    if (tooltip != null) {
      badge = Tooltip(message: tooltip!, child: badge);
    }

    return badge;
  }

  Color _toneColor(AppBadgeTone tone) {
    return switch (tone) {
      AppBadgeTone.primary => Constants.kPrimaryColor,
      AppBadgeTone.success => const Color(0xFF059669),
      AppBadgeTone.warning => Constants.kWarninngColor,
      AppBadgeTone.danger => Constants.kErrorColor,
      AppBadgeTone.neutral => Constants.kGreyMedium,
    };
  }
}

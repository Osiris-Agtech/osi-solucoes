import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AppIconTile extends StatelessWidget {
  final IconData? icon;
  final String? asset;
  final Color color;
  final Color? backgroundColor;
  final double size;
  final double iconSize;
  final String? semanticLabel;

  const AppIconTile({
    super.key,
    this.icon,
    this.asset,
    this.color = Constants.kPrimaryColor,
    this.backgroundColor,
    this.size = 48,
    this.iconSize = 24,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final child = asset != null
        ? SvgPicture.asset(
            asset!,
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          )
        : Icon(icon ?? Icons.circle, color: color, size: iconSize);

    return Semantics(
      label: semanticLabel,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(child: child),
      ),
    );
  }
}

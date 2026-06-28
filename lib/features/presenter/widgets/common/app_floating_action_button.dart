import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AppFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String heroTag;
  final double? bottom;
  final Widget? child;
  final IconData? icon;
  final String? label;
  final double iconSize;

  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.heroTag,
    this.bottom,
    this.child,
    this.icon,
    this.label,
    this.iconSize = 28,
  });

  const AppFloatingActionButton.add({
    super.key,
    required this.onPressed,
    required this.heroTag,
    this.bottom,
    this.iconSize = 28,
  })  : child = null,
        icon = Icons.add,
        label = null;

  @override
  Widget build(BuildContext context) {
    final fab = label != null
        ? FloatingActionButton.extended(
            heroTag: heroTag,
            onPressed: onPressed,
            backgroundColor: Constants.kPrimaryColor,
            elevation: 3,
            icon: Icon(icon ?? Icons.add, size: iconSize, color: Colors.white),
            label: Text(
              label!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          )
        : FloatingActionButton(
            heroTag: heroTag,
            onPressed: onPressed,
            backgroundColor: Constants.kPrimaryColor,
            elevation: 3,
            child: child ??
                Icon(
                  icon ?? Icons.add,
                  size: iconSize,
                  color: Colors.white,
                ),
          );

    if (bottom != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: bottom!),
        child: fab,
      );
    }

    return fab;
  }
}

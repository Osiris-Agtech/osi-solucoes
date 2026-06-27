import 'package:flutter/material.dart';

class AppPanelCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final double? maxWidth;
  final VoidCallback? onTap;
  final String? semanticLabel;

  const AppPanelCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.maxWidth,
    this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Material(
      color: backgroundColor,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius.resolve(Directionality.of(context)),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (maxWidth != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        child: content,
      );
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (semanticLabel != null) {
      content = Semantics(label: semanticLabel, child: content);
    }

    return content;
  }
}

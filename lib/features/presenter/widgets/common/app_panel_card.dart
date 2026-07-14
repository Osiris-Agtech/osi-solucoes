import 'package:flutter/material.dart';

class AppPanelCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder? border;
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
    this.border,
    this.maxWidth,
    this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: border,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius.resolve(Directionality.of(context)),
          child: Padding(
            padding: padding,
            child: child,
          ),
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

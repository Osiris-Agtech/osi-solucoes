import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/utils/responsive_breakpoints.dart';

/// Sistema de espaçamento responsivo
/// Use em vez de valores hardcoded ou multiplicadores de MediaQuery
/// 
/// Exemplo:
/// ```dart
/// padding: Spacing.horizontal(context),
/// padding: Spacing.all(size: Spacing.lg),
/// SizedBox(height: Spacing.md),
/// ```
class Spacing {
  // Tamanhos fixos de espaçamento
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  /// Padding horizontal responsivo (usa ResponsiveBreakpoints internamente)
  static EdgeInsets horizontal(BuildContext context) {
    return ResponsiveBreakpoints.responsiveHorizontalPadding(
      context,
      mobile: md,
      tablet: lg,
      desktop: xl,
    );
  }

  /// Padding vertical responsivo
  static EdgeInsets vertical(BuildContext context, {double? custom}) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    final size = custom ?? (isMobile ? md : lg);
    return EdgeInsets.symmetric(vertical: size);
  }

  /// Padding completo responsivo
  static EdgeInsets all(BuildContext context, {double? custom}) {
    final padding = custom ?? ResponsiveBreakpoints.responsivePadding(
      context,
      mobile: md,
      tablet: lg,
      desktop: xl,
    );
    return EdgeInsets.all(padding);
  }

  /// EdgeInsets apenas top
  static EdgeInsets top({double size = md}) {
    return EdgeInsets.only(top: size);
  }

  /// EdgeInsets apenas bottom
  static EdgeInsets bottom({double size = md}) {
    return EdgeInsets.only(bottom: size);
  }

  /// EdgeInsets apenas left
  static EdgeInsets left({double size = md}) {
    return EdgeInsets.only(left: size);
  }

  /// EdgeInsets apenas right
  static EdgeInsets right({double size = md}) {
    return EdgeInsets.only(right: size);
  }

  /// EdgeInsets simétrico horizontal
  static EdgeInsets symmetricH({double size = md}) {
    return EdgeInsets.symmetric(horizontal: size);
  }

  /// EdgeInsets simétrico vertical
  static EdgeInsets symmetricV({double size = md}) {
    return EdgeInsets.symmetric(vertical: size);
  }

  /// EdgeInsets simétrico completo
  static EdgeInsets symmetric({double horizontal = md, double vertical = md}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  /// SizedBox vertical
  static Widget v(double size) {
    return SizedBox(height: size);
  }

  /// SizedBox horizontal
  static Widget h(double size) {
    return SizedBox(width: size);
  }

  /// SizedBox vertical responsivo
  static Widget vResponsive(BuildContext context, {double? size}) {
    final height = size ?? ResponsiveBreakpoints.responsivePadding(
      context,
      mobile: md,
      tablet: lg,
      desktop: xl,
    );
    return SizedBox(height: height);
  }

  /// SizedBox horizontal responsivo
  static Widget hResponsive(BuildContext context, {double? size}) {
    final width = size ?? ResponsiveBreakpoints.responsivePadding(
      context,
      mobile: md,
      tablet: lg,
      desktop: xl,
    );
    return SizedBox(width: width);
  }
}

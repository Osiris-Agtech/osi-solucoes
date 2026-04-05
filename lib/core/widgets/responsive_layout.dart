import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/utils/responsive_breakpoints.dart';

/// Widget que renderiza diferentes layouts baseado no breakpoint
/// Uso:
/// ```dart
/// ResponsiveLayout(
///   mobile: MobileWidget(),
///   tablet: TabletWidget(),
///   desktop: DesktopWidget(),
/// )
/// ```
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ResponsiveBreakpoints.tablet) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= ResponsiveBreakpoints.mobile) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// Widget simplificado para layout mobile vs desktop
/// Quando tablet não é especificado, usa mobile como fallback
class ResponsiveLayoutSimple extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const ResponsiveLayoutSimple({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ResponsiveBreakpoints.tablet) {
          return desktop;
        }
        return mobile;
      },
    );
  }
}

/// Widget para layouts com breakpoint personalizado
class ResponsiveLayoutCustom extends StatelessWidget {
  final Widget small;  // < breakpointSmall
  final Widget? medium; // entre breakpointSmall e breakpointLarge
  final Widget? large;  // >= breakpointLarge
  final double breakpointSmall;
  final double breakpointLarge;

  const ResponsiveLayoutCustom({
    super.key,
    required this.small,
    this.medium,
    this.large,
    this.breakpointSmall = 600,
    this.breakpointLarge = 1024,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= breakpointLarge) {
          return large ?? medium ?? small;
        } else if (constraints.maxWidth >= breakpointSmall) {
          return medium ?? small;
        } else {
          return small;
        }
      },
    );
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Utilitário para detecção de breakpoints e plataforma
/// Usado em todo o app para criar layouts responsivos
class ResponsiveBreakpoints {
  // Breakpoints padrão (em pixels)
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;

  /// Verifica se é dispositivo mobile (smartphone)
  static bool isMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < mobile;
  }

  /// Verifica se é tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }

  /// Verifica se é desktop ou tela grande
  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tablet;
  }

  /// Verifica se é web (browser)
  static bool get isWeb => kIsWeb;

  /// Verifica se é Android nativo
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Verifica se é iOS nativo
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Verifica se é desktop nativo (Windows, Linux, macOS)
  static bool get isDesktopNative =>
      !kIsWeb &&
      (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

  /// Verifica se é dispositivo mobile (Android ou iOS)
  static bool get isMobileNative => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Retorna largura responsiva baseada no breakpoint atual
  /// Use em vez de MediaQuery.of(context).size.width * multiplicador
  static double responsiveWidth(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    final tabletValue = tablet ?? mobile;
    final desktopValue = desktop ?? tabletValue;
    
    if (width >= desktopValue) {
      return desktopValue;
    } else if (width >= tabletValue) {
      return tabletValue;
    }
    return mobile;
  }

  /// Retorna altura responsiva (cuidado: use com moderação)
  static double responsiveHeight(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final height = MediaQuery.of(context).size.height;
    final tabletValue = tablet ?? mobile;
    final desktopValue = desktop ?? tabletValue;
    
    if (height >= desktopValue) {
      return desktopValue;
    } else if (height >= tabletValue) {
      return tabletValue;
    }
    return mobile;
  }

  /// Retorna padding horizontal responsivo
  static double responsivePadding(
    BuildContext context, {
    double mobile = 16.0,
    double tablet = 32.0,
    double desktop = 48.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= desktop) {
      return desktop;
    } else if (width >= tablet) {
      return tablet;
    }
    return mobile;
  }

  /// Retorna EdgeInsets simétrico horizontal responsivo
  static EdgeInsets responsiveHorizontalPadding(
    BuildContext context, {
    double mobile = 16.0,
    double tablet = 32.0,
    double desktop = 48.0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: responsivePadding(
        context,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      ),
    );
  }

  /// Retorna EdgeInsets completo responsivo
  static EdgeInsets responsiveEdgeInsets(
    BuildContext context, {
    double mobile = 16.0,
    double tablet = 24.0,
    double desktop = 32.0,
  }) {
    final padding = responsivePadding(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    return EdgeInsets.all(padding);
  }

  /// Retorna número de colunas para grid baseado na largura
  static int gridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= desktop) return 3;
    if (width >= tablet) return 2;
    return 1;
  }

  /// Retorna largura máxima para modal/dialog
  static double modalMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= desktop) return 800;
    if (width >= tablet) return 600;
    return width * 0.92;
  }

  /// Retorna se deve mostrar sidebar ou não
  static bool shouldShowSidebar(BuildContext context) {
    return MediaQuery.of(context).size.width >= tablet;
  }

  /// Retorna tamanho de fonte responsivo
  static double responsiveFontSize(
    BuildContext context, {
    double mobile = 14.0,
    double tablet = 16.0,
    double desktop = 18.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= desktop) return desktop;
    if (width >= tablet) return tablet;
    return mobile;
  }

  /// Retorna se tem espaço suficiente para layout lado a lado
  static bool canShowSideBySide(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }
}

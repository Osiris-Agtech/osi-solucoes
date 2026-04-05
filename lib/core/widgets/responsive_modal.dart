import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/utils/responsive_breakpoints.dart';

/// Modal responsivo que adapta seu tamanho baseado no dispositivo
/// Substitui o padrão antigo: height: MediaQuery.of(context).size.height * 0.9
/// 
/// Uso:
/// ```dart
/// ResponsiveModal.show(
///   context: context,
///   child: MeuConteudo(),
///   title: 'Título do Modal',
/// );
/// ```
class ResponsiveModal {
  /// Mostra modal responsivo via Get.bottomSheet
  static void show({
    required BuildContext context,
    required Widget child,
    String? title,
    Widget? header,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? mobileMaxWidth,
    double? tabletMaxWidth,
    double? desktopMaxWidth,
    EdgeInsets? padding,
  }) {
    Get.bottomSheet(
      _ResponsiveModalContent(
        child: child,
        title: title,
        header: header,
        mobileMaxWidth: mobileMaxWidth,
        tabletMaxWidth: tabletMaxWidth,
        desktopMaxWidth: desktopMaxWidth,
        padding: padding,
      ),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? Colors.transparent,
    );
  }

  /// Mostra modal de confirmação simples
  static void showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    Color? confirmColor,
  }) {
    Get.bottomSheet(
      _ResponsiveModalContent(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text(cancelText),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                    ),
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ],
        ),
        title: title,
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
}

/// Widget interno do modal responsivo
class _ResponsiveModalContent extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? header;
  final double? mobileMaxWidth;
  final double? tabletMaxWidth;
  final double? desktopMaxWidth;
  final EdgeInsets? padding;

  const _ResponsiveModalContent({
    required this.child,
    this.title,
    this.header,
    this.mobileMaxWidth,
    this.tabletMaxWidth,
    this.desktopMaxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveBreakpoints.modalMaxWidth(context);
    final defaultPadding = ResponsiveBreakpoints.responsiveEdgeInsets(
      context,
      mobile: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    );

    return Container(
      constraints: BoxConstraints(
        maxWidth: desktopMaxWidth ?? tabletMaxWidth ?? mobileMaxWidth ?? maxWidth,
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header opcional
          if (header != null)
            Padding(
              padding: defaultPadding,
              child: header!,
            ),
          
          // Título opcional
          if (title != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                defaultPadding.left,
                header != null ? 8 : 16,
                defaultPadding.right,
                16,
              ),
              child: Row(
                children: [
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
          
          // Conteúdo com scroll
          Flexible(
            child: SingleChildScrollView(
              padding: padding ?? defaultPadding,
              child: child,
            ),
          ),
          
          // Espaço bottom para segurança
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 16),
        ],
      ),
    );
  }
}

/// Widget para conteúdo de bottom sheet responsivo
/// Use dentro de Get.bottomSheet() customizado
class ResponsiveBottomSheetContent extends StatelessWidget {
  final Widget child;
  final double? maxHeightRatio;

  const ResponsiveBottomSheetContent({
    super.key,
    required this.child,
    this.maxHeightRatio,
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * (maxHeightRatio ?? 0.85);
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        maxWidth: ResponsiveBreakpoints.modalMaxWidth(context),
      ),
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }
}

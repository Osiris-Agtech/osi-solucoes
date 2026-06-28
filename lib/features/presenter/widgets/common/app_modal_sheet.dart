import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

/// Shared bottom sheet template with consistent styling.
///
/// Provides: header with title + close, scrollable body, safe area,
/// rounded top corners, consistent background and shadow.
class AppModalSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget body;
  final double maxHeightFactor;
  final double minHeightFactor;
  final EdgeInsetsGeometry bodyPadding;
  final bool showCloseButton;
  final Widget? bottomWidget;

  const AppModalSheet({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.body,
    this.maxHeightFactor = 0.85,
    this.minHeightFactor = 0.3,
    this.bodyPadding = const EdgeInsets.fromLTRB(24, 8, 24, 24),
    this.showCloseButton = true,
    this.bottomWidget,
  });

  /// Opens this modal sheet using Get.bottomSheet.
  static Future<T?> show<T>({
    required String title,
    String? subtitle,
    Widget? trailing,
    required Widget body,
    double maxHeightFactor = 0.85,
    double minHeightFactor = 0.3,
    EdgeInsetsGeometry bodyPadding = const EdgeInsets.fromLTRB(24, 8, 24, 24),
    bool showCloseButton = true,
    Widget? bottomWidget,
  }) {
    return Get.bottomSheet<T>(
      AppModalSheet(
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        body: body,
        maxHeightFactor: maxHeightFactor,
        minHeightFactor: minHeightFactor,
        bodyPadding: bodyPadding,
        showCloseButton: showCloseButton,
        bottomWidget: bottomWidget,
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * maxHeightFactor,
        minHeight: MediaQuery.of(context).size.height * minHeightFactor,
      ),
      decoration: const BoxDecoration(
        color: Constants.kSecondBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handle(),
          if (showCloseButton || title.isNotEmpty)
            _header(context),
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: bodyPadding,
              child: body,
            ),
          ),
          if (bottomWidget != null) bottomWidget!,
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _handle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: Constants.kGreyLight,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          if (showCloseButton)
            IconButton(
              icon: const Icon(Icons.close, size: 22),
              color: Constants.kGreyMedium,
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            )
          else
            const SizedBox(width: 48),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Constants.kText2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Constants.kGreyMedium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

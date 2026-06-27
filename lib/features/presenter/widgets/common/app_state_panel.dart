import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import 'app_primary_button.dart';

enum AppStateKind { loading, empty, error, searchEmpty }

class AppStatePanel extends StatelessWidget {
  final AppStateKind stateKind;
  final IconData? icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final bool isCompact;

  const AppStatePanel({
    super.key,
    required this.stateKind,
    required this.title,
    this.icon,
    this.message,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = icon ?? _defaultIcon;
    final topPadding = isCompact ? 32.0 : 96.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, topPadding, 16, 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(isCompact ? 16 : 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (stateKind == AppStateKind.loading)
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(effectiveIcon, size: 34, color: Constants.kPrimaryColor),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Constants.kText2,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: Constants.kGreyText2,
                    ),
                  ),
                ],
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 16),
                  AppPrimaryButton(
                    label: actionLabel!,
                    onPressed: onAction,
                    isFullWidth: false,
                  ),
                ],
                if (secondaryActionLabel != null &&
                    onSecondaryAction != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onSecondaryAction,
                    child: Text(secondaryActionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData get _defaultIcon {
    return switch (stateKind) {
      AppStateKind.loading => Icons.hourglass_empty,
      AppStateKind.empty => Icons.inbox_outlined,
      AppStateKind.error => Icons.error_outline,
      AppStateKind.searchEmpty => Icons.search_off_outlined,
    };
  }
}

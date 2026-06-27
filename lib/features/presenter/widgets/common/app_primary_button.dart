import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

enum AppButtonTone { primary, neutral, danger }

enum AppButtonSize { compact, regular }

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;
  final bool isFullWidth;
  final AppButtonSize size;
  final AppButtonTone tone;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.isFullWidth = true,
    this.size = AppButtonSize.regular,
    this.tone = AppButtonTone.primary,
  });

  @override
  Widget build(BuildContext context) {
    final canPress = isEnabled && !isLoading && onPressed != null;
    final height = size == AppButtonSize.compact ? 40.0 : 48.0;
    final color = _toneColor(tone);
    final child = isLoading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: canPress ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Constants.kGreyLight,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: child,
      ),
    );
  }

  Color _toneColor(AppButtonTone tone) {
    return switch (tone) {
      AppButtonTone.primary => Constants.kPrimaryColor,
      AppButtonTone.neutral => Constants.kButtonGrey,
      AppButtonTone.danger => Constants.kErrorColor,
    };
  }
}

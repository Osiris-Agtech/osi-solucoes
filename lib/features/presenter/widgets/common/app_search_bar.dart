import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final Widget? trailing;
  final bool autofocus;
  final bool enabled;
  final String hintText;

  const AppSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.trailing,
    this.autofocus = false,
    this.enabled = true,
    this.hintText = 'Buscar...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Constants.kGreyLight.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, size: 22, color: Constants.kGreyText2),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              autofocus: autofocus,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 15,
                  color: Constants.kGreyText2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (onClear != null)
            _ClearButton(controller: controller, onClear: onClear!),
          if (trailing != null) ...[
            const SizedBox(width: 4),
            trailing!,
            const SizedBox(width: 6),
          ] else
            const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback onClear;

  const _ClearButton({required this.controller, required this.onClear});

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return IconButton(
        onPressed: onClear,
        icon: const Icon(Icons.close, size: 18),
        color: Constants.kGreyText2,
      );
    }

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller!,
      builder: (context, value, child) {
        if (value.text.isEmpty) {
          return const SizedBox(width: 8);
        }

        return IconButton(
          onPressed: onClear,
          icon: const Icon(Icons.close, size: 18),
          color: Constants.kGreyText2,
        );
      },
    );
  }
}

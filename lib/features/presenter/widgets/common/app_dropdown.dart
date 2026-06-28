import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

/// A modern, standardized dropdown component with rounded borders,
/// consistent theming, and proper contrast.
///
/// Wraps a [DropdownButtonFormField] with the app's design tokens.
class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final String? hintText;
  final Widget? hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? labelText;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final Color? fillColor;
  final bool isExpanded;
  final Widget? suffixIcon;
  final FormFieldSetter<T>? onSaved;
  final String? Function(T?)? validator;
  final Key? fieldKey;

  const AppDropdown({
    super.key,
    this.value,
    this.hintText,
    this.hint,
    required this.items,
    this.onChanged,
    this.labelText,
    this.contentPadding,
    this.borderRadius = 12,
    this.fillColor,
    this.isExpanded = true,
    this.suffixIcon,
    this.onSaved,
    this.validator,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveFillColor = fillColor ?? Constants.kSecondBackgroundColor;

    return DropdownButtonFormField<T>(
      key: fieldKey,
      value: value,
      hint: hint ??
          (hintText != null
              ? Text(
                  hintText!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Constants.kGreyText2.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                )
              : null),
      isExpanded: isExpanded,
      icon: suffixIcon ??
          const Icon(Icons.expand_more, color: Constants.kPrimaryColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Constants.kGreyMedium,
        ),
        filled: true,
        fillColor: effectiveFillColor,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Constants.kGreyLight.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Constants.kGreyLight.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            color: Constants.kPrimaryColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Constants.kErrorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Constants.kErrorColor, width: 1.5),
        ),
      ),
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Constants.kText2,
      ),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      items: items,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
    );
  }
}

/// A lightweight dropdown without form decoration, for inline use.
/// Same visual style as [AppDropdown] but without border/label decoration.
class AppInlineDropdown<T> extends StatelessWidget {
  final T? value;
  final String? hintText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const AppInlineDropdown({
    super.key,
    this.value,
    this.hintText,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Constants.kGreyLight.withValues(alpha: 0.5),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: false,
          hint: hintText != null
              ? Text(
                  hintText!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Constants.kGreyText2.withValues(alpha: 0.8),
                  ),
                )
              : null,
          icon: const Icon(
            Icons.expand_more,
            size: 18,
            color: Constants.kPrimaryColor,
          ),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Constants.kPrimaryColor,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(10),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

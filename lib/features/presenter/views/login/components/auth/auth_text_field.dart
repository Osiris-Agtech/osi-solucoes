import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/login/components/auth/auth_badge.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool optional;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.optional = false,
    this.suffixIcon,
    this.validator,
    this.inputFormatters,
    this.onEditingComplete,
    this.onChanged,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      cursorColor: Constants.kPrimaryColor,
      textCapitalization: textCapitalization,
      style: const TextStyle(
        color: Constants.kContentColorLightTheme,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Constants.kSecondBackgroundColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        labelStyle: const TextStyle(color: Constants.kGreyText, fontSize: 14),
        errorStyle: const TextStyle(fontSize: 11, height: 1.1),
        enabledBorder: _border(Constants.kGreyLight),
        focusedBorder: _border(Constants.kPrimaryColor),
        errorBorder: _border(Constants.kErrorColor),
        focusedErrorBorder: _border(Constants.kErrorColor),
        suffixIcon: suffixIcon ??
            (optional
                ? const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Center(child: AuthBadge(text: 'Opcional')),
                  )
                : null),
        suffixIconConstraints: optional
            ? const BoxConstraints(minWidth: 0, minHeight: 0)
            : const BoxConstraints(minWidth: 48, minHeight: 48),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}

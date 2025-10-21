import 'package:formz/formz.dart';

extension StringExtension on String {
  bool isInvalidEmail() {
    final RegExp regex = RegExp(
        r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$");
    return !regex.hasMatch(this);
  }
}

extension StringExtensionMobilePhone on String {
  bool isInvalidMobilePhone() {
    final RegExp regex =
        RegExp(r'^\([1-9]{2}\) (?:[2-8]|9[1-9])[0-9]{3}\-[0-9]{4}$');
    return !regex.hasMatch(this);
  }
}

extension StringExtensionPostalCode on String {
  bool isInvalidPostalCode() {
    final RegExp regex = RegExp(r'/^\d{5}(-\d{3})?$/');
    return !regex.hasMatch(this);
  }
}

extension StringExtensionCPF on String {
  bool isInvalidCPF() {
    final RegExp regex = RegExp(r'(0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})');
    return !regex.hasMatch(this);
  }
}

extension StringExtensionCNPJ on String {
  bool isInvalidCNPJ() {
  
    final RegExp regex = RegExp(r'/^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/');
    return !regex.hasMatch(this);
  }
}

enum EmailValidationError { invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure([super.value = '']) : super.pure();
  const Email.dirty([super.value = '']) : super.dirty();

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidationError? validator(String? value) {
    return _emailRegex.hasMatch(value ?? '')
        ? null
        : EmailValidationError.invalid;
  }
}

enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure([super.value = '']) : super.pure();
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    return value != null && value.length >= 8
        ? null
        : PasswordValidationError.invalid;
  }
}

import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

String getCurrency(dynamic value) {
  if (value is String) {
    value = double.parse(value);
  }
  return NumberFormat.simpleCurrency(locale: "pt_BR")
      .format(value)
      .substring(3);
}

class CurrencyPtBrFormatter extends TextInputFormatter {
  CurrencyPtBrFormatter({this.maxDigits});
  final int? maxDigits;
  double? _uMaskValue;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    if (maxDigits != null && newValue.selection.baseOffset > maxDigits!) {
      return oldValue;
    }
    double value = double.parse(newValue.text);
    final formatter = NumberFormat("#,##0.00", "pt_BR");
    String newText = formatter.format(value / 100);
    //setting the umasked value
    _uMaskValue = value / 100;
    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }

  //here the method
  double getUnmaskedDouble() {
    return _uMaskValue!;
  }
}

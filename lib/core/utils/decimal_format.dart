import 'package:intl/intl.dart';

String getCurrency(dynamic value) {
  if (value is String) {
    value = double.parse(value);
  }
  return NumberFormat.simpleCurrency(locale: "pt_br")
      .format(value)
      .substring(3);
}

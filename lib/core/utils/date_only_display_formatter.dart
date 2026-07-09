class DateOnlyDisplayFormatter {
  const DateOnlyDisplayFormatter._();

  static String? formatShortBrazilian(String? rawDate) {
    final value = rawDate?.trim();
    if (value == null || value.isEmpty) return null;

    final datePortion = value.split(RegExp(r'[T\s]')).first;
    final match = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(
      datePortion,
    );
    if (match == null) return null;

    final secondSegment = int.tryParse(match.group(2)!);
    final thirdSegment = int.tryParse(match.group(3)!);
    if (secondSegment == null || thirdSegment == null) return null;

    final observedShape = _validDay(secondSegment) && _validMonth(thirdSegment);
    final isoShape = _validMonth(secondSegment) && _validDay(thirdSegment);

    if (observedShape) {
      return _format(secondSegment, thirdSegment);
    }

    if (isoShape) {
      return _format(thirdSegment, secondSegment);
    }

    return null;
  }

  static bool _validDay(int value) => value >= 1 && value <= 31;

  static bool _validMonth(int value) => value >= 1 && value <= 12;

  static String _format(int day, int month) {
    final paddedDay = day.toString().padLeft(2, '0');
    final paddedMonth = month.toString().padLeft(2, '0');
    return '$paddedDay/$paddedMonth';
  }
}

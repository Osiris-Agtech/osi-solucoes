import 'package:flutter/material.dart';

///  This function creates a MaterialColor(Color, Map<int, Color>) from a Color(int).
///
/// Returned object has this shape:
/// MaterialColor(
///   0xFF000000,
///   const <int, Color>{
///     50:  const Color(0xFFe0e0e0),
///     100: const Color(0xFFb3b3b3),
///     200: const Color(0xFF808080),
///     300: const Color(0xFF4d4d4d),
///     400: const Color(0xFF262626),
///     500: const Color(0xFF000000),
///     600: const Color(0xFF000000),
///     700: const Color(0xFF000000),
///     800: const Color(0xFF000000),
///     900: const Color(0xFF000000),
///   },
/// );
///
/// Example of use:
///   [...]
///   primarySwatch: createMaterialColor(Color(0xFF174378)),
///   [...]

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

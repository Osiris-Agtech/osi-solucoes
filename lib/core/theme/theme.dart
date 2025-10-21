import 'package:flutter/material.dart';

import '../constants/constants.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: Constants.kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme,
    cardColor: Constants.kCardColor,
    iconTheme: const IconThemeData(color: Constants.kContentColorLightTheme),
    textTheme: const TextTheme(bodyLarge: TextStyle(fontFamily: "Montserrat")),

    // GoogleFonts.interTextTheme(Theme.of(context).textTheme)
    //     .apply(bodyColor: kContentColorLightTheme),
    // colorScheme: ColorScheme.light(
    //   primary: kPrimaryColor,
    //   secondary: kSecondaryColor,
    //   error: kErrorColor,
    // ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Constants.kContentColorLightTheme.withValues(alpha: 0.7),
      unselectedItemColor: Constants.kContentColorLightTheme.withValues(alpha: 0.32),
      selectedIconTheme: const IconThemeData(color: Constants.kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

// ThemeData darkThemeData(BuildContext context) {
//   // Bydefault flutter provie us light and dark theme
//   // we just modify it as our need
//   return ThemeData.dark().copyWith(
//     primaryColor: kPrimaryColor,
//     scaffoldBackgroundColor: kContentColorLightTheme,
//     backgroundColor: kContentColorLightTheme,
//     appBarTheme: appBarTheme,
//     iconTheme: IconThemeData(color: kContentColorDarkTheme),
//     textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
//         .apply(bodyColor: kContentColorDarkTheme),
//     colorScheme: ColorScheme.dark().copyWith(
//       primary: kPrimaryColor,
//       secondary: kSecondaryColor,
//       error: kErrorColor,
//     ),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       backgroundColor: kContentColorLightTheme,
//       selectedItemColor: Colors.white70,
//       unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
//       selectedIconTheme: IconThemeData(color: kPrimaryColor),
//       showUnselectedLabels: true,
//     ),
//   );
// }

const appBarTheme = AppBarTheme(centerTitle: true, elevation: 0);

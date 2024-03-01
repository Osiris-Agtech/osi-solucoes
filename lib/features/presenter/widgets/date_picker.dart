import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/core/utils/color_creator.dart';
import 'package:osi_solucoes/features/presenter/widgets/rounded_date_picker/flutter_rounded_date_picker_widget.dart';
import 'package:osi_solucoes/features/presenter/widgets/rounded_date_picker/material_rounded_date_picker_style.dart';
import 'package:osi_solucoes/features/presenter/widgets/rounded_date_picker/material_rounded_year_picker_style.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

Future<DateTime?> datePicker({
  required BuildContext context,
  required DateTime initialDate,
  required String title,
}) {
  return showRoundedDatePicker(
    context: context,
    title: title,
    titleTextStyle: const TextStyle(
      color: Constants.kPrimaryColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    headerLine: Constants.kGreyLight,
    height: 300,
    initialDate: initialDate,
    firstDate: DateTime(DateTime.now().year - 100),
    lastDate:
        DateTime(DateTime.now().year + 100).subtract(const Duration(days: 1)),
    borderRadius: 16,
    textPositiveButton: "Selecionar",
    textNegativeButton: "Cancelar",
    locale: const Locale('pt', 'BR'),
    theme: ThemeData(
      primarySwatch: createMaterialColor(Constants.kBackgroundColor),
    ),
    styleDatePicker: MaterialRoundedDatePickerStyle(
      textStyleDayButton: const TextStyle(
        color: Constants.kPrimaryColor,
        fontWeight: FontWeight.w500,
      ),
      textStyleYearButton: const TextStyle(
        color: Constants.kPrimaryColor,
        fontWeight: FontWeight.w500,
      ),
      textStyleDayHeader: const TextStyle(
        color: Constants.kGreyMedium,
        fontWeight: FontWeight.bold,
      ),
      textStyleCurrentDayOnCalendar: const TextStyle(
        color: Constants.kGreyText,
        fontWeight: FontWeight.bold,
      ),
      textStyleDayOnCalendar: const TextStyle(color: Constants.kGreyMedium),
      textStyleDayOnCalendarSelected: const TextStyle(
        color: Constants.kBackgroundColor,
        fontWeight: FontWeight.bold,
      ),
      textStyleMonthYearHeader: const TextStyle(
        color: Constants.kPrimaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      paddingDatePicker: const EdgeInsets.all(0),
      // paddingMonthHeader: const EdgeInsets.fromLTRB(32, 22, 32, 22),
      paddingActionBar: const EdgeInsets.all(0),
      paddingDateYearHeader: const EdgeInsets.fromLTRB(32, 0, 32, 0),
      sizeArrow: 35,
      colorArrowNext: Constants.kPrimaryColor,
      colorArrowPrevious: Constants.kPrimaryColor,
      // marginLeftArrowPrevious: 16,
      // marginTopArrowPrevious: 16,
      // marginTopArrowNext: 16,
      // marginRightArrowNext: 32,
      textStyleButtonAction: const TextStyle(color: Colors.black),
      textStyleButtonPositive: const TextStyle(
        color: Constants.kPrimaryColor,
        fontWeight: FontWeight.bold,
      ),
      textStyleButtonNegative: const TextStyle(color: Constants.kGreyMedium),
      decorationDateSelected: const BoxDecoration(
          color: Constants.kPrimaryColor, shape: BoxShape.circle),
      phaseColors: {
        Colors.blueAccent: [
          DateTime(2024, 2, 1),
          DateTime(2024, 2, 2),
          DateTime(2024, 2, 3),
          DateTime(2024, 2, 4),
        ],
        Colors.orangeAccent: [
          DateTime(2024, 2, 5),
          DateTime(2024, 2, 6),
          DateTime(2024, 2, 7),
          DateTime(2024, 2, 8),
          DateTime(2024, 2, 9),
        ],
        Colors.amberAccent: [
          DateTime(2024, 2, 12),
          DateTime(2024, 2, 13),
          DateTime(2024, 2, 14)
        ],
      },
      backgroundPicker: Constants.kBackgroundColor, //getBackgroundColor(),
      backgroundActionBar: Constants.kBackgroundColor, //getBackgroundColor(),
      backgroundHeaderMonth: Constants.kBackgroundColor, //getBackgroundColor(),
    ),
    styleYearPicker: MaterialRoundedYearPickerStyle(
      textStyleYear: const TextStyle(color: Constants.kGreyMedium),
      textStyleYearSelected: const TextStyle(
          color: Constants.kPrimaryColor, fontWeight: FontWeight.bold),
      heightYearRow: 70,
      backgroundPicker: Constants.kBackgroundColor, //getBackgroundColor(),
    ),
  );
}

Future<DateTime?> datePickerNative(BuildContext context, DateTime initialDate) {
  return showDatePicker(
    context: context,
    // height: 320,
    initialDate: initialDate,
    firstDate: DateTime(DateTime.now().year - 100),
    lastDate:
        DateTime(DateTime.now().year + 100).subtract(const Duration(days: 1)),
    locale: const Locale('pt', 'BR'),

    builder: (BuildContext context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogTheme: DialogTheme(
            // backgroundColor: getBackgroundColor(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
        child: child!,
      );
    },

    // borderRadius: 16,
    // textPositiveButton: "Selecionar",
    // textNegativeButton: "Cancelar",
    // theme: ThemeData(
    //   primarySwatch: createMaterialColor(getBackgroundColor()),
    // ),
    // styleDatePicker: MaterialRoundedDatePickerStyle(
    //   textStyleDayButton: getRegularStyle(),
    //   textStyleYearButton: getRegularStyle(),
    //   textStyleDayHeader: const TextStyle(
    //     color: AppColors.greyLigth3,
    //     fontWeight: FontWeight.bold,
    //   ),
    //   textStyleCurrentDayOnCalendar: getBoldStyle(),
    //   textStyleDayOnCalendar: const TextStyle(color: AppColors.greyMedium),
    //   textStyleDayOnCalendarSelected: getWhiteStyle(),
    //   // textStyleDayOnCalendarDisabled:
    //   //     TextStyle(color: Colors.black.withOpacity(0.9)),
    //   textStyleMonthYearHeader: getPurpleStyle(),
    //   paddingDatePicker: const EdgeInsets.all(0),
    //   // paddingMonthHeader: const EdgeInsets.fromLTRB(32, 22, 32, 22),
    //   paddingActionBar: const EdgeInsets.all(0),
    //   paddingDateYearHeader: const EdgeInsets.fromLTRB(32, 32, 32, 0),
    //   sizeArrow: 35,
    //   colorArrowNext: AppColors.purpleDark,
    //   colorArrowPrevious: AppColors.purpleDark,
    //   // marginLeftArrowPrevious: 16,
    //   // marginTopArrowPrevious: 16,
    //   // marginTopArrowNext: 16,
    //   // marginRightArrowNext: 32,
    //   textStyleButtonAction: const TextStyle(color: Colors.black),
    //   textStyleButtonPositive: const TextStyle(
    //     color: AppColors.purpleDark,
    //     fontWeight: FontWeight.bold,
    //   ),
    //   textStyleButtonNegative: const TextStyle(color: AppColors.greyMedium),
    //   decorationDateSelected: const BoxDecoration(
    //       color: AppColors.purpleDark, shape: BoxShape.circle),
    //   backgroundPicker: getBackgroundColor(),
    //   backgroundActionBar: getBackgroundColor(),
    //   backgroundHeaderMonth: getBackgroundColor(),
    // ),
    // styleYearPicker: MaterialRoundedYearPickerStyle(
    //   textStyleYear: const TextStyle(color: AppColors.greyMedium),
    //   textStyleYearSelected:
    //       const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    //   heightYearRow: 100,
    //   backgroundPicker: getBackgroundColor(),
    // ),
  );
}

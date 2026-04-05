// ignore_for_file: constant_identifier_names

class ThaiDateUtils {
  static const List<String> MONTH_FULL_TH = [
    "มกราคม",
    "กุมภาพันธ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฎาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤศจิกายน",
    "ธันวาคม",
  ];

  static const List<String> MONTH_SHORT_TH = [
    "ม.ค.",
    "ก.พ.",
    "มี.ค.",
    "เม.ย.",
    "พ.ค.",
    "มิ.ย.",
    "ก.ค.",
    "ส.ค.",
    "ก.ย.",
    "ต.ค.",
    "พ.ย.",
    "ธ.ค.",
  ];

  static String getMonthNameShot(int month) {
    return MONTH_SHORT_TH[month - 1];
  }

  static String getMonthNameFull(int month) {
    return MONTH_FULL_TH[month - 1];
  }
}

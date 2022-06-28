import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex("#f5a523");
  static Color primaryOpacity70 = HexColor.fromHex("#B3f5a523");
  static Color success = HexColor.fromHex("#009f29");
  static Color info = HexColor.fromHex("#0066be");
  static Color blue = HexColor.fromHex("#3866df");
  static Color warning = HexColor.fromHex("#f5a523");
  static Color btnBuy = HexColor.fromHex("#a70ecc");
  static Color error = HexColor.fromHex("#dc3545");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color lightGray = HexColor.fromHex("#f3f5f6");
  static Color subtitle = HexColor.fromHex("#818588");
  static Color gray = HexColor.fromHex("#d0d2d4");
  static Color dark = HexColor.fromHex("#404553");
  static Color black = HexColor.fromHex("#3c3e4e");

  static Map<int, Color> swatch = {
    50: const Color(0x1Affffff), //10%
    100: const Color(0x33ffffff), //20%
    200: const Color(0x4Dffffff), //30%
    300: const Color(0x66ffffff), //40%
    400: const Color(0x80ffffff), //50%
    500: const Color(0x99ffffff), //60%
    600: const Color(0xBFffffff), //70%
    700: const Color(0xCCffffff), //80%
    800: const Color(0xE6ffffff), //90%
    900: const Color(0xffffffff), //100%
  };

  static MaterialColor primaryColor = MaterialColor(0xffffffff, swatch);
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll("#", "");
    if (hexColorString.length == 6) {
      hexColorString = "FF" + hexColorString;
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}

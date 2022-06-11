import 'package:flutter/material.dart';

class ConstValues {
  static Color primaryColor = HexColor.fromHex('#dc211e');
  static Color secondaryColor = HexColor.fromHex('#191d1f');

  static Map<int, Color> red = {
    50: Color.fromRGBO(220, 33, 30, .1),
    100: Color.fromRGBO(220, 33, 30, .2),
    200: Color.fromRGBO(220, 33, 30, .3),
    300: Color.fromRGBO(220, 33, 30, .4),
    400: Color.fromRGBO(220, 33, 30, .5),
    500: Color.fromRGBO(220, 33, 30, .6),
    600: Color.fromRGBO(220, 33, 30, .7),
    700: Color.fromRGBO(220, 33, 30, .8),
    800: Color.fromRGBO(220, 33, 30, .9),
    900: Color.fromRGBO(220, 33, 30, 1),
  };
  static MaterialColor myRedColor = MaterialColor(0xFFdc211e, red);

  static Map<int, Color> black = {
    50: Color.fromRGBO(220, 33, 30, .1),
    100: Color.fromRGBO(220, 33, 30, .2),
    200: Color.fromRGBO(220, 33, 30, .3),
    300: Color.fromRGBO(220, 33, 30, .4),
    400: Color.fromRGBO(220, 33, 30, .5),
    500: Color.fromRGBO(220, 33, 30, .6),
    600: Color.fromRGBO(220, 33, 30, .7),
    700: Color.fromRGBO(220, 33, 30, .8),
    800: Color.fromRGBO(220, 33, 30, .9),
    900: Color.fromRGBO(220, 33, 30, 1),
  };
  static MaterialColor myBlackColor = MaterialColor(0xFF191d1f, black);
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String? hexString) {
    if (hexString == null || hexString.isEmpty) {
      return ConstValues.primaryColor;
    }
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

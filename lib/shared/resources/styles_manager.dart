import 'package:flutter/material.dart';

import 'font_manager.dart';

TextStyle _getTextStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
  String fontFamily = FontConstant.fontFamily,
  double height = 1.5,
}) =>
    TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      height: height,
    );

TextStyle getRegularStyle({
  double fontSize = FontSize.s16,
  required Color color,
}) =>
    _getTextStyle(
      fontSize: fontSize,
      fontWeight: FontWeightManager.regular,
      color: color,
    );

TextStyle getBoardingStyle({
  double fontSize = FontSize.s40,
  required Color color,
}) =>
    _getTextStyle(
      fontSize: fontSize,
      fontWeight: FontWeightManager.bold,
      fontFamily: FontConstant.SerifFont,
      color: color,
    );

TextStyle getBoldStyle({
  double fontSize = FontSize.s18,
  required Color color,
}) =>
    _getTextStyle(
      fontSize: fontSize,
      fontWeight: FontWeightManager.bold,
      color: color,
    );

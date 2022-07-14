import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'font_manager.dart';
import 'styles_manager.dart';
import 'values_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    dividerColor: Colors.transparent,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: ColorManager.primaryColor,
    ),

    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
    // main colors of the app
    primaryColor: ColorManager.primary,
    // primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.dark,
    // ripple color
    splashColor: ColorManager.primary,
    // will be used incase of disabled button for example
    accentColor: ColorManager.primary,
    // App bar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      titleTextStyle:
          getBoldStyle(color: ColorManager.white, fontSize: FontSize.s20),
    ),
    // Button theme
    buttonTheme: ButtonThemeData(
        shape: StadiumBorder(),
        disabledColor: ColorManager.gray,
        buttonColor: ColorManager.primary,
        splashColor: ColorManager.primaryOpacity70),

    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            textStyle: getRegularStyle(color: ColorManager.white),
            primary: ColorManager.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s12)))),

    // Text theme
    textTheme: TextTheme(
      headline1: getBoldStyle(color: ColorManager.dark, fontSize: FontSize.s30),
      headline2: getBoldStyle(color: ColorManager.dark, fontSize: FontSize.s24),
      headline3: getBoldStyle(color: ColorManager.dark, fontSize: FontSize.s18),
      headline4: getBoldStyle(color: ColorManager.dark, fontSize: FontSize.s16),
      headline5: getBoldStyle(color: ColorManager.dark, fontSize: FontSize.s14),
      bodyText1: getBoldStyle(color: ColorManager.dark, fontSize: FontSize.s20),
      bodyText2:
          getRegularStyle(color: ColorManager.gray, fontSize: FontSize.s16),
      caption:
          getRegularStyle(color: ColorManager.dark, fontSize: FontSize.s14),
      subtitle1: getRegularStyle(color: ColorManager.subtitle, fontSize: 12),
      subtitle2: getRegularStyle(color: ColorManager.subtitle, fontSize: 10),
    ),

    // input decoration theme (text form field)
    inputDecorationTheme: InputDecorationTheme(
      prefixStyle: TextStyle(
        color: ColorManager.primary,
      ),
      suffixStyle: TextStyle(
        color: ColorManager.primary,
      ), // hint style
      hintStyle: getRegularStyle(color: ColorManager.dark.withOpacity(0.4)),

      // label style
      labelStyle: getRegularStyle(color: ColorManager.gray),
      // error style
      errorStyle: getRegularStyle(color: ColorManager.error, fontSize: 14),

      // enabled border
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: ColorManager.gray),
      ),

      // focused border
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: ColorManager.primary),
      ),

      // error border
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: ColorManager.error),
      ),

      // focusedError border
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: ColorManager.primary),
      ),
    ),
  );
}

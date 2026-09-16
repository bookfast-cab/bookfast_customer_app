import 'package:flutter/material.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_constants.dart';

class AppTextStyles {
  /// Heading Text Styles
  // Heading - H1 Text Style
  static TextStyle headingH1TextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.2,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 60,
          String fontFamily = AppConstants.fontLexendSemiBold}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Heading - H2 Text Style
  static TextStyle headingH2TextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.2,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 52,
          String fontFamily = AppConstants.fontLexendSemiBold}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Heading - H3 Text Style
  static TextStyle headingH3TextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 40,
          String fontFamily = AppConstants.fontLexendSemiBold}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Heading - H4 Text Style
  static TextStyle headingH4TextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 36,
          String fontFamily = AppConstants.fontLexendSemiBold}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Heading - H5 Text Style
  static TextStyle headingH5TextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 24,
          String fontFamily = AppConstants.fontLexendSemiBold}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Heading - H5 Text Style
  static TextStyle headingH5BoldTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w700,
          double fontSize = 24,
          String fontFamily = AppConstants.fontLexendSemiBold}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Heading - H6 Text Style
  static TextStyle headingH6TextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 28,
          String fontFamily = AppConstants.fontLexendSemiBold}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Heading - H7 Text Style
  static TextStyle headingH7TextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w600,
          double fontSize = 12,
          String fontFamily = AppConstants.fontLexendSemiBold}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );


  // Paragraph 2 - Text Style
  static TextStyle paragraph2TextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w400,
          double fontSize = 14,
          String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  /// Action Text Styles
  // Extra Large - XL Text Style
  static TextStyle actionXLTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 24,
          String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Extra Large - L Text Style
  static TextStyle actionLTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 20,
          String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Medium - M Text Style
  static TextStyle actionMTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 16,
          String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Small - S Text Style
  static TextStyle actionSTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 14,
          String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Extra Small - XS Text Style
  static TextStyle actionXSTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 12,
          String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  /// Body Light
  // Body - Light - Extra Large - XL Text Style
  static TextStyle bodyLightXLTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w400,
          double fontSize = 24,
          String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Body - Light - Large - L Text Style
  static TextStyle bodyLightLTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w400,
          double fontSize = 20,
          String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Body - Light - Medium - M Text Style
  static TextStyle bodyLightMTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w400,
          double fontSize = 16,
          String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Body - Light - Small - S Text Style
  static TextStyle bodyLightSTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w400,
          double fontSize = 14,
          String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Body - Light - Extra Small - XS Text Style
  static TextStyle bodyLightXSTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w400,
          double fontSize = 12,
          String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  /// Body Heavy
  // Body - Light - Extra Large - XL Text Style
  static TextStyle bodyHeavyXLTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 24,
          String fontFamily = AppConstants.fontLexendSemiBold}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Body - Light - Large - L Text Style
  static TextStyle bodyHeavyLTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 20,
          String fontFamily = AppConstants.fontLexendSemiBold}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Body - Light - Medium - M Text Style
  static TextStyle bodyHeavyMTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 16,
          String fontFamily = AppConstants.fontLexendSemiBold}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Body - Light - Small - S Text Style
  static TextStyle bodyHeavySTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 14,
          String fontFamily = AppConstants.fontLexendSemiBold}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  // Body - Light - Extra Small - XS Text Style
  static TextStyle bodyHeavyXSTextStyle(
          {TextDecoration? decoration,
          Color textColor = AppColors.textColor100,
          double height = 1.1,
          FontWeight fontWeight = FontWeight.w500,
          double fontSize = 12,
          String fontFamily = AppConstants.fontLexendSemiBold}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  static TextStyle textStyle(
          {TextDecoration? decoration,
          Color? textColor,
          double? height,
          FontWeight fontWeight = FontWeight.normal,
          double fontSize = 15,
          String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: decoration ?? TextDecoration.none,
        height: height,
        color: textColor ?? AppColors.textColor100,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  static TextStyle titleTextStyle({
    Color? textColor,
    double? height,
    FontWeight fontWeight = FontWeight.normal,
    double fontSize = 20,
    String fontFamily = AppConstants.fontLexendRegular,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration decoration = TextDecoration.none,
  }) =>
      TextStyle(
        decoration: decoration,
        height: height,
        color: textColor ?? AppColors.whiteColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontStyle: fontStyle,
        fontFamily: fontFamily,
      );

  static TextStyle largeTitleTextStyle(
          {Color? textColor, double? height, FontWeight fontWeight = FontWeight.normal, double fontSize = 30, String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: TextDecoration.none,
        height: height,
        color: textColor ?? AppColors.whiteColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  static TextStyle appTextStyle(
          {Color? textColor, double? height, FontWeight fontWeight = FontWeight.normal, double fontSize = 15, String fontFamily = AppConstants.fontLexendRegular}) =>
      TextStyle(
        decoration: TextDecoration.none,
        height: height,
        color: textColor ?? AppColors.whiteColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
      );

  static TextStyle subTitleTextStyle({
    Color? textColor,
    double? height,
    FontWeight fontWeight = FontWeight.normal,
    double fontSize = 15,
    String fontFamily = AppConstants.fontLexendRegular,
    Color bgColor = Colors.transparent,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration decoration = TextDecoration.none,
  }) =>
      TextStyle(
          decoration: decoration,
          height: height,
          color: textColor ?? AppColors.whiteColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
          fontFamily: fontFamily,
          backgroundColor: bgColor,
          fontStyle: fontStyle);

  static TextStyle body1RegularTextStyle({
    Color? textColor,
    double? height,
    FontWeight fontWeight = FontWeight.w300,
    double fontSize = 16,
    String fontFamily = AppConstants.fontLexendRegular,
    Color bgColor = Colors.transparent,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration decoration = TextDecoration.none,
  }) =>
      TextStyle(
          decoration: decoration,
          height: height,
          color: textColor ?? AppColors.whiteColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
          fontFamily: fontFamily,
          backgroundColor: bgColor,
          fontStyle: fontStyle);

  static TextStyle body2RegularTextStyle({
    Color? textColor,
    double? height,
    FontWeight fontWeight = FontWeight.w300,
    double fontSize = 14,
    String fontFamily = AppConstants.fontLexendRegular,
    Color bgColor = Colors.transparent,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration decoration = TextDecoration.none,
  }) =>
      TextStyle(
          decoration: decoration,
          height: height,
          color: textColor ?? AppColors.whiteColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
          fontFamily: fontFamily,
          backgroundColor: bgColor,
          fontStyle: fontStyle);
}

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'app_colors.dart';
import 'app_constants.dart';
import 'app_dimens.dart';

class AppHtmlStyle {
  static Style txtStyleHeader() {
    return Style(
      // height: 1.2,
      padding: HtmlPaddings.zero,
      fontFamily: AppConstants.fontLexendRegular,
      // fontSize: widget.isDetail
      //     ? FontSize(AppDimensions.nineteen)
      //     : FontSize(Get.width * 0.04),
      // fontStyle: FontStyle.normal,
      // fontWeight: Strings.FONT_FAMILY_WEIGHT, // FontWeight.w400,
      color: Colors.black,
      // textDecorationColor: AppColor.black,
      // textDecorationThickness: 4,
    );
  }

  static Style txtStyle() {
    return Style(
      // height: 1.2,
      padding: HtmlPaddings.symmetric(horizontal: 5, vertical: 0),
      margin: Margins.zero,
      fontFamily: AppConstants.fontLexendRegular,
      fontSize: FontSize(AppDimensions.dmFifteen),
      // fontSize: widget.isDetail
      //     ? FontSize(AppDimensions.nineteen)
      //     : FontSize(Get.width * 0.04),
      // fontStyle: FontStyle.normal,
      // fontWeight: Strings.FONT_FAMILY_WEIGHT, // FontWeight.w400,
      color: AppColors.backColor20,
      // textDecorationColor: AppColor.black,
      // textDecorationThickness: 4,
    );
  }

  static Style txtStyleA() {
    // if(widget.isForm){
    //   return Style(
    //     // height: 1.2,
    //     padding: EdgeInsets.zero,
    //     fontFamily: Strings.FONT_FAMILY_ROBOTO,
    //     fontStyle: FontStyle.normal,
    //     fontWeight: FontWeight.w400,
    //     fontSize: widget.descriptionFontSize ?? FontSize(AppDimensions.nineteen),
    //     color: Utils.getColorFromMode(
    //         AppColor.darkTextColor, AppColor.white, context),
    //     textDecorationColor: AppColor.black,
    //     textDecorationThickness: 4,
    //   );
    // } else {
    return Style(
      // height: 1.2,
      padding: HtmlPaddings.zero,
      fontFamily: AppConstants.fontLexendRegular,
      fontSize: FontSize(AppDimensions.dmSeventeen),
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      // maxLines: widget.maxlines,

      lineHeight: LineHeight(1.4),
      // color: Utils.getColorFromMode(
      //     AppColor.darkTextColor, AppColor.white, context),
      // textDecorationColor: Colors.black,
      //textDecorationColor: AppColor.black,
      textDecorationThickness: 1,
    );
    // }
  }

  static Map<String, Style> htmlAllStyle() {
    return {
      "h1": txtStyle(),
      "h2": txtStyle(),
      "h3": txtStyle(),
      "h4": txtStyle(),
      "h5": txtStyle(),
      "ul": txtStyle(),
      "li": txtStyle(),
      "span": txtStyle(),
      "p": txtStyle(),      // For paragraph elements
      "p > a": txtStyle(),  // Links inside paragraphs
      "div": txtStyle(),    // Target div elements as well
      "body": txtStyle(),   // Apply a default style to body
      "#footer": txtStyle(),
    };
  }
}

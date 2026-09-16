import 'package:flutter/material.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';

class AppTextWidgets {
  static Widget titleText(String text, {TextAlign textAlign = TextAlign.start, TextOverflow? textOverflow, TextStyle? style}) => Text(
        text,
        textAlign: textAlign,
        style: style ?? AppTextStyles.textStyle(),
      );
}

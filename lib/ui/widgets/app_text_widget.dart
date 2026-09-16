import 'package:flutter/material.dart';
import 'package:bookfast_customer/utils/app_constants.dart';
import 'package:bookfast_customer/utils/app_dimens.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';

class AppTextWidget extends StatelessWidget {
  AppTextWidget(this.text,
      {Key? key,
      this.textAlign = TextAlign.start,
      this.style,
      this.maxLines,
      this.overflow,
      this.fontFamily = AppConstants.fontLexendRegular,
      this.padding,
      this.onTap})
      : super(key: key);

  String text;
  TextAlign textAlign;
  TextStyle? style;
  int? maxLines;
  TextOverflow? overflow;
  String fontFamily;
  Function? onTap;
  EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    var shouldAbsorb = true;
    if (onTap == null) {
      shouldAbsorb = false;
    }

    // print("maxLines  ---> $maxLines text $text");

    return AbsorbPointer(
      absorbing: !shouldAbsorb,
      child: InkWell(
        onTap: () {
          print("pressed -->");
          if (onTap != null) {
            onTap!();
          }
        },
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(vertical: shouldAbsorb ? AppDimensions.dmThree : 0),
          child: Text(
            text,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
            style: style ?? AppTextStyles.textStyle(),
          ),
        ),
      ),
    );
  }
}

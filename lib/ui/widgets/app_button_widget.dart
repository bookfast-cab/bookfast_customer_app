import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bookfast_customer/utils/app_constants.dart';

import '../../../utils/app_colors.dart';
import '../../utils/app_dimens.dart';

class AppButton extends StatelessWidget {
  final Function()? onClick;
  final String? title;
  final Widget? titleWidget;
  final Color? bgColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? buttonRadius;
  final Color? borderColor;
  final double? fontSize;
  final bool enabled;
  final bool shrinkWrap;
  final double? minWidth;
  final double borderWidth;
  bool showShadow;
  bool showBorder;
  Offset? shadowOffset;
  Color? shadowColor;
  double shadowSpreadRadius;
  double shadowBlurRadius;
  bool showGradient;
  List<Color>? gradientColors;

  AppButton({
    Key? key,
    this.onClick,
    this.title,
    this.titleWidget,
    this.bgColor,
    this.textColor,
    this.padding,
    this.margin,
    this.buttonRadius = 10,
    this.minWidth,
    this.borderColor,
    this.enabled = true,
    this.shrinkWrap = false,
    this.fontSize = 14,
    this.borderWidth = 1.0,
    this.showShadow = true,
    this.shadowBlurRadius = 10.0,
    this.shadowColor,
    this.shadowSpreadRadius = 0.0,
    this.shadowOffset,
    this.showGradient = false,
    this.showBorder = false,
    this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!enabled) {
            return;
          }
          FocusScope.of(context).requestFocus(FocusNode());

          if (onClick != null) onClick!();
        },
        child: shrinkWrap
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [_button(context)],
              )
            : _button(context));
  }

  _button(context) {
    print("enabled --> $enabled");
    return Container(
      // width: double.infinity,
      constraints: shrinkWrap
          ? const BoxConstraints()
          : BoxConstraints(
              minWidth: minWidth ?? MediaQuery.of(context).size.width / 2,
              // maxWidth: minWidth ?? MediaQuery.of(context).size.width / 2,
            ),
      decoration: BoxDecoration(
        color: !enabled ? AppColors.textColor30 : bgColor ?? AppColors.primaryColor100,
        border: !showBorder ? null : Border.all(color: !enabled ? Colors.grey : borderColor ?? AppColors.primaryColor100, width: borderWidth),
        borderRadius: BorderRadius.all(Radius.circular(buttonRadius ?? 10)),
        boxShadow: [
          if (showShadow)
            BoxShadow(
                offset: shadowOffset ?? const Offset(0, 0),
                blurRadius: shadowBlurRadius,
                spreadRadius: shadowSpreadRadius,
                color: shadowColor ?? Colors.grey.shade200,
                blurStyle: BlurStyle.outer)
        ],
        gradient: !showGradient
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: gradientColors ??
                    [
                      Colors.white,
                      AppColors.primaryColor100.withOpacity(0.001),
                    ],
                stops: const [0.5, 1.0],
              ),
      ),
      margin: margin,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: AppDimensions.dmTwentyFive, vertical: AppDimensions.dmFifteen),
      alignment: Alignment.center,
      child: titleWidget != null
          ? titleWidget!
          : Text(
              title ?? "",
              style: TextStyle(
                  fontSize: fontSize,
                   //fontWeight: FontWeight.w300,
                  color: !enabled ? AppColors.textColor10 : textColor ?? AppColors.whiteColor,
                  fontFamily: AppConstants.fontLexendSemiBold),
            ),
    );
  }
}

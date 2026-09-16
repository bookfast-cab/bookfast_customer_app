import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_dimens.dart';
import 'app_common_widgets.dart';

class AppListTileWidget extends StatelessWidget {
  const AppListTileWidget(
      {Key? key,
      this.titleText,
      this.titleWidget,
      this.trailing,
      this.padding,
      this.margin = EdgeInsets.zero,
      this.onLeadingPress,
      this.onTrailingPress,
      this.leadingWidget,
      this.backgroundColor = AppColors.backgroundColor,
      this.titleTextColor = AppColors.secondaryColor100,
      this.isTitleCenter = false,
      this.titleTextSize = AppDimensions.dmFifteen,
      this.onTap,
      this.allBorderRadius = 0,
      this.topLeftRadius = 0,
      this.topRightRadius = 0,
      this.bottomLeftRadius = 0,
      this.bottomRightRadius = 0,
      this.borderWidth = 0,
      this.borderColor = Colors.transparent})
      : super(key: key);

  final String? titleText;
  final Color titleTextColor;
  final Widget? titleWidget;
  final Widget? trailing;
  final Function? onLeadingPress;
  final Function? onTrailingPress;
  final bool? isTitleCenter;
  final EdgeInsets? padding;
  final EdgeInsets margin;
  final Color backgroundColor;
  final Widget? leadingWidget;
  final double titleTextSize;
  final Function? onTap;
  final double allBorderRadius;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: AppCommonWidgets.borderRadius(
              isAll: allBorderRadius > 0, allRadius: allBorderRadius, topLeft: topLeftRadius, topRight: topRightRadius, bottomLeft: bottomLeftRadius, bottomRight: bottomRightRadius),
        ),
        // padding: padding ?? EdgeInsets.all(AppDimensions.twentyFive),
        padding: padding ??
            EdgeInsets.only(
                left: AppDimensions.dmTwentyFive,
                top: kIsWeb
                    ? AppDimensions.dmFifteen
                    : Platform.isIOS
                        ? 0.0
                        : AppDimensions.dmFifteen,
                right: AppDimensions.dmTwentyFive,
                bottom: AppDimensions.dmTwenty),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          if (leadingWidget != null) leadingWidget!,
          if (leadingWidget != null)
            const SizedBox(
              width: AppDimensions.dmTen,
            ),
          if (titleText != null)
            Expanded(
                child: Align(
                    alignment: isTitleCenter == true ? Alignment.center : Alignment.centerLeft,
                    child: AppTextWidget(
                      titleText ?? "",
                      style: AppTextStyles.appTextStyle(textColor: titleTextColor, fontSize: titleTextSize),
                    ))),
          if (titleWidget != null) Expanded(child: Align(alignment: isTitleCenter == true ? Alignment.center : Alignment.centerLeft, child: titleWidget!)),
          if (trailing != null)
            InkWell(
                onTap: () {
                  print("pressed");
                  if (onTrailingPress != null) {
                    onTrailingPress!();
                  }
                },
                child: trailing!),
          if (trailing == null)
            const SizedBox(
              height: AppDimensions.dmTwentyFive,
              width: AppDimensions.dmTwentyFive,
            ),
        ]),
      ),
    );
  }
}

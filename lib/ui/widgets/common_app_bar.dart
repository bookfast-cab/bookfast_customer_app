import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_images.dart';

class CommonAppBar extends StatelessWidget {
  final bool showBackButton;
  final String? titleText;
  final Color titleTextColor;
  final Widget? titleWidget;
  final Widget? trailing;
  final Function? onBackPress;
  final Function? onTrailingPress;
  final bool? isTitleCenter;
  final EdgeInsets? padding;
  final Color backgroundColor;
  final Color backArrowColor;
  final Widget? leadingWidget;
  final String? backButtonImage;
  final double backButtonPadding;
  final TextStyle? titleTextStyle;

  CommonAppBar({
    Key? key,
    this.showBackButton = true,
    this.titleText,
    this.titleWidget,
    this.trailing,
    this.padding,
    this.onBackPress,
    this.onTrailingPress,
    this.leadingWidget,
    this.backgroundColor = Colors.transparent,
    this.backArrowColor = AppColors.secondaryColor100,
    this.titleTextColor = AppColors.whiteColor,
    this.backButtonImage,
    this.isTitleCenter = false,
    this.backButtonPadding = 13,
    this.titleTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: AppDimensions.dmSixty,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        // border: const Border(
        //     bottom: BorderSide(
        //   color: AppColors.borderMediumColor,
        //   width: 1,
        // )),
      ),
      // padding: padding ?? EdgeInsets.all(AppDimensions.twentyFive),
      padding: padding ?? EdgeInsets.only(left: AppDimensions.dmFive, top: Platform.isIOS ? 0.0 : AppDimensions.dmFive, right: AppDimensions.dmFive, bottom: AppDimensions.dmFive),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        if (showBackButton && leadingWidget == null)
          InkWell(
            onTap: () {
              //debugPrint("Tha tha tha tha");
              if (onBackPress != null) {
                onBackPress!();
              } else {
                Get.back();
              }
            },
            child: Container(
              height: AppDimensions.dmFortyFive,
              width: AppDimensions.dmFortyFive,
              padding: EdgeInsets.all(backButtonPadding),
              child: Image.asset(
                backButtonImage ?? AppImages.icBackWithPadding,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        if (leadingWidget != null) leadingWidget!,
        const SizedBox(
          width: AppDimensions.dmTen,
        ),
        if (titleText != null)
          Expanded(
              child: Align(
                  alignment: isTitleCenter == true ? Alignment.center : Alignment.centerLeft,
                  child: AppTextWidget(
                    titleText ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: titleTextStyle ?? AppTextStyles.bodyHeavyMTextStyle(textColor: titleTextColor),
                  ))),
        if (titleWidget == null && trailing == null && showBackButton)
          const SizedBox(
            width: AppDimensions.dmFifty,
          ),
        if (titleWidget != null) Expanded(child: titleWidget!),
        if (trailing != null)
          InkWell(
              onTap: () {
                print("pressed");
                if (onTrailingPress != null) {
                  onTrailingPress!();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: trailing!,
              )),
        if (trailing == null)
          const SizedBox(
            height: AppDimensions.dmTwentyFive,
            width: AppDimensions.dmTwentyFive,
          ),
      ]),
    );
  }

}

import 'package:bookfast_customer/ui/widgets/app_container_widget.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_dimens.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_strings.dart';

class AppTutorialTooltipWidget extends StatelessWidget {
  AppTutorialTooltipWidget(
      {Key? key,
      required this.title,
      required this.subTitle,
      this.arrowAlignment = Alignment.centerRight,
      this.bottomText,
      this.trailing,
      this.trailingOnTap,
      this.bottomWidgetOnTap,
      this.alignment,
      this.arrowMargin,
      this.isTopArrow = true})
      : super(key: key);

  final String title;
  final String subTitle;
  final String? bottomText;
  final String? trailing;
  bool isTopArrow;
  Alignment arrowAlignment;
  CrossAxisAlignment? alignment;
  EdgeInsets? arrowMargin;

  final Function? trailingOnTap;
  final Function? bottomWidgetOnTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width / 1.5,
      child: Column(
        crossAxisAlignment: alignment ?? CrossAxisAlignment.end,
        children: [
          if (isTopArrow)
            Align(
              alignment: arrowAlignment,
              child: Container(
                margin: arrowMargin ?? EdgeInsets.only(right: Get.width / 16),
                height: 23,
                width: 20,
                child: Icon(
                  Icons.arrow_drop_up,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          AppContainer(
            color: Colors.white,
            padding: EdgeInsets.all(10),
            allBorderRadius: 15,
            width: Get.width / 1.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: AppTextWidget(
                        title,
                        style: AppTextStyles.appTextStyle(height: 1, fontSize: AppDimensions.dmFourteen, textColor: AppColors.secondaryColor100, fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (trailing != null)
                      AppTextWidget(
                        trailing ?? "",
                        style: AppTextStyles.appTextStyle(height: 1, fontSize: AppDimensions.dmTwelve, textColor: AppColors.primaryColor100, fontWeight: FontWeight.w600),
                        onTap: () {
                          if (trailingOnTap != null) {
                            trailingOnTap!();
                          }
                        },
                      ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                AppTextWidget(
                  subTitle,
                  style: AppTextStyles.appTextStyle(
                    height: 1,
                    fontSize: AppDimensions.dmEleven,
                    textColor: AppColors.secondaryColor100,
                  ),
                ),
                if (bottomText != null)
                  AppTextWidget(
                    bottomText ?? "",
                    style: AppTextStyles.appTextStyle(height: 1, fontSize: AppDimensions.dmTwelve, textColor: AppColors.primaryColor100, fontWeight: FontWeight.w600),
                    onTap: () {
                      if (bottomWidgetOnTap != null) {
                        bottomWidgetOnTap!();
                      }
                    },
                  ).paddingOnly(top: 5, right: 5).marginOnly(top: 3),
              ],
            ),
          ),
          if (!isTopArrow)
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: arrowMargin ?? EdgeInsets.only(left: Get.width / 16),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    top: BorderSide(color: Colors.white, width: 10),
                    left: BorderSide(color: Colors.transparent, width: 10),
                    right: BorderSide(color: Colors.transparent, width: 10),
                    bottom: BorderSide(color: Colors.transparent, width: 12),
                  ),
                ),
                height: 20,
                width: 20,
              ),
            ),
        ],
      ),
    );
  }
}

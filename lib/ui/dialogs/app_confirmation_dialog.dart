import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookfast_customer/ui/widgets/app_container_widget.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_dimens.dart';
import 'package:bookfast_customer/utils/app_strings.dart';

import '../../utils/app_constants.dart';
import '../../utils/app_images.dart';
import '../../utils/app_text_styles.dart';
import '../widgets/app_button_widget.dart';
import '../widgets/app_common_widgets.dart';
import '../widgets/app_text_widget.dart';

class AppConfirmationDialog extends StatelessWidget {
  AppConfirmationDialog(
      {Key? key,
      required this.titleText,
      required this.bodyText,
      this.imagePath,
      this.imageSize,
      this.imagePadding,
      this.dialogMargin,
      this.callback1,
      this.callback2,
      this.button1text,
      this.button2text})
      : super(key: key);

  String titleText;
  String bodyText;
  String? button1text;
  String? button2text;
  String? imagePath;
  double? imageSize;
  EdgeInsets? imagePadding;
  EdgeInsets? dialogMargin;
  Function? callback1;
  Function? callback2;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Dialog(shadowColor: Colors.transparent,
      insetPadding: dialogMargin ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.dmTwentyFive)),
      child: Wrap(
        children: [
          AppContainer(
            color: AppColors.whiteColor,
            allBorderRadius: AppDimensions.dmTwentyFive,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.dmFifteen, vertical: AppDimensions.dmTwenty),
            showGradient: true,
            gradientColors: [
              Colors.white,
              AppColors.primaryColor100.withOpacity(0.01),
              Colors.white,
            ],
            gradientStops: [0.1, 0.5, 2],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(AppImages.imgBackground,
                          height: AppDimensions.dmTwentyFive,
                          width: AppDimensions.dmTwentyFive,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        Get.back(result: true);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: imagePadding ?? const EdgeInsets.all(0.0),
                  child: Image.asset(
                    imagePath ?? AppImages.icWarning,
                    height: imageSize ?? AppDimensions.dmSixty,
                    width: imageSize ?? AppDimensions.dmSixty,
                    fit: BoxFit.cover,
                  ),
                ),

                AppCommonWidgets.vrtSpaceWidget(AppDimensions.dmTen),

                AppTextWidget(titleText,
                    textAlign: TextAlign.center,
                    style:
                        AppTextStyles.textStyle(textColor: AppColors.textColor100, fontWeight: FontWeight.bold, fontSize: AppDimensions.dmTwentyFive, fontFamily: AppConstants.fontLexendRegular)),

                if (bodyText != null) AppCommonWidgets.vrtSpaceWidget(AppDimensions.dmTen),
                if (bodyText != null)
                  AppTextWidget(bodyText ?? "",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textStyle(textColor: AppColors.textColor100, fontSize: AppDimensions.dmSixteen, fontFamily: AppConstants.fontLexendRegular, height: 1.2)),

                AppCommonWidgets.vrtSpaceWidget(AppDimensions.dmTwenty),

                /// Assign Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.dmEight, horizontal: AppDimensions.dmFifty),
                      shrinkWrap: true,
                      titleWidget: AppTextWidget(button1text ?? AppStrings.deleteConfirmationButton,
                          style: AppTextStyles.textStyle(
                            textColor: AppColors.textColor100,
                            fontWeight: FontWeight.w600,
                            fontSize: AppDimensions.dmSixteen,
                            fontFamily: AppConstants.fontLexendRegular,
                          )),
                      fontSize: AppDimensions.dmThirteen,
                      buttonRadius: AppDimensions.dmTen,
                      margin: const EdgeInsets.only(top: AppDimensions.dmTen),
                      onClick: () {
                        //Get.back(result: true);
                        if (callback1 != null) {
                          callback1!();
                        }
                      },
                    ),
                  ],
                ),

                AppCommonWidgets.vrtSpaceWidget(AppDimensions.dmTwentyFive),

                InkWell(
                  child: AppTextWidget(button2text ?? AppStrings.deleteConfirmationButtonCancel,
                      style: AppTextStyles.textStyle(
                        textColor: AppColors.primaryColor100,
                        fontWeight: FontWeight.w500,
                        fontSize: AppDimensions.dmSixteen,
                        fontFamily: AppConstants.fontLexendRegular,
                      )),
                  onTap: () {
                    Get.back(result: true);

                    if (callback2 != null) {
                      callback2!();
                    }
                  },
                ),

                AppCommonWidgets.vrtSpaceWidget(AppDimensions.dmTwenty),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

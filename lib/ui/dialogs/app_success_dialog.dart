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

class AppSuccessDialog extends StatelessWidget {
  AppSuccessDialog({Key? key, required this.titleText, this.bodyText, this.imagePath, this.imageSize, this.imagePadding, this.dialogMargin, this.callback, this.showImage = true}) : super(key: key);

  String titleText;
  String? bodyText;
  String? imagePath;
  double? imageSize;
  bool showImage;
  EdgeInsets? imagePadding;
  EdgeInsets? dialogMargin;
  Function()? callback;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Dialog(
      shadowColor: Colors.transparent,
      insetPadding: dialogMargin ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.dmTwentyFive)),
      child: Wrap(
        children: [
          AppContainer(
            color: AppColors.whiteColor,
            allBorderRadius: AppDimensions.dmTwentyFive,
            showGradient: true,
            gradientColors: [
              Colors.white,
              AppColors.primaryColor100.withOpacity(0.25),
              Colors.white,
            ],
            gradientStops: [0.01, 0.5, 20],
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.dmFifteen, vertical: AppDimensions.dmTwenty),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          AppImages.icCancel,
                          height: AppDimensions.dmTwentyTwo,
                          width: AppDimensions.dmTwentyTwo,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        Get.back(result: true);
                      },
                    ),
                  ],
                ),
                if (showImage)
                  Padding(
                    padding: imagePadding ?? const EdgeInsets.all(0.0),
                    child: Image.asset(
                      imagePath ?? AppImages.icSuccess,
                      height: imageSize ?? AppDimensions.dmSixty,
                      width: imageSize ?? AppDimensions.dmSixty,
                      fit: BoxFit.cover,
                    ),
                  ),

                AppCommonWidgets.vrtSpaceWidget(AppDimensions.dmTen),

                AppTextWidget(titleText,
                    textAlign: TextAlign.center,
                    style:
                        AppTextStyles.textStyle(textColor: AppColors.textColor100, fontWeight: FontWeight.bold, fontSize: AppDimensions.dmTwentyTwo, fontFamily: AppConstants.fontLexendRegular)),

                if (bodyText != null) AppCommonWidgets.vrtSpaceWidget(AppDimensions.dmTen),
                if (bodyText != null)
                  AppTextWidget(bodyText!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textStyle(
                          height: 1.2, textColor: AppColors.textColor100, fontWeight: FontWeight.w500, fontSize: AppDimensions.dmFifteen, fontFamily: AppConstants.fontLexendRegular)),

                AppCommonWidgets.vrtSpaceWidget(AppDimensions.dmTwenty),

                /// Assign Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.dmTen, horizontal: AppDimensions.dmFifty),
                      shrinkWrap: true,
                      titleWidget: AppTextWidget(AppStrings.okButton,
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
                        Get.back(result: true);

                        if (callback != null) {
                          callback!();
                        } else{
                          // Get.back(result: true);
                        }
                      },
                    ),
                  ],
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

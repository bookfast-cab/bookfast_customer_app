
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_styles.dart';
import '../widgets/app_button_widget.dart';
import '../widgets/app_container_widget.dart';
import '../widgets/app_text_widget.dart';

class BookingSuccessfullDialog extends StatefulWidget {
  BookingSuccessfullDialog({super.key, required this.trackOrderCallback, required this.homeCallback});

  Function() trackOrderCallback;
  Function() homeCallback;

  @override
  State<BookingSuccessfullDialog> createState() => _BookingSuccessfullDialogState();
}

class _BookingSuccessfullDialogState extends State<BookingSuccessfullDialog> {


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        insetPadding: const EdgeInsets.only(left: 15, right: 15),
        child: WillPopScope(
          onWillPop: ()async{
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo Section
                AppContainer(
                  width: Get.width / 1.8,
                  height: Get.width / 1.8,
                  padding: const EdgeInsets.all(30),
                  color: AppColors.primaryColor10.withOpacity(0.3),
                  allBorderRadius: 200,
                  child: Image.asset(
                    AppImages.icBookFastLogo  ,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                const SizedBox(height: 20,),
      
                // Success Payment Text
                Align(
                  alignment: Alignment.center,
                  child: AppTextWidget(
                    "Successfull",
                    style: AppTextStyles.headingH1TextStyle(
                      fontSize: AppDimensions.dmEighteen,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.bfPrimaryColor,
                    ),
                  ),
                ),
                // const SizedBox(height: AppDimensions.dmTen),
                //
                // // Success Title
                // AppTextWidget(
                // //  AppStrings.strSuccessTitle,
                //   "SuccessFull",
                //   style: AppTextStyles.body1RegularTextStyle(
                //     fontWeight: FontWeight.w300,
                //     fontSize: AppDimensions.dmThirteen,
                //     textColor: AppColors.backColor1,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                const SizedBox(height: 10),
      
                // Success Subtitle
                AppTextWidget(
                  "Your ride has been successfully booked!",
                  style: AppTextStyles.body1RegularTextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: AppDimensions.dmThirteen,
                    textColor: AppColors.backColor1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.dmThirty),
      
                // Button Section: Track and Home
      
                AppButton(
                  title: "Track",
                  textColor: AppColors.whiteColor,
                  bgColor: AppColors.bfPrimaryColor,
                  onClick: () {
                    widget.homeCallback();
                  },
                ),
      
      
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Track Button
                    Expanded(
                      child: AppButton(
                        title: AppStrings.strTrack,
                        textColor: AppColors.primaryColor100,
                        bgColor: AppColors.primaryColor10,
                        onClick: () {
                          widget.trackOrderCallback();
                        },
                      ),
                    ),
                    const SizedBox(width: AppDimensions.dmFifteen),
      
                    // Home Button
                    Expanded(
                      child: AppButton(
                        title: AppStrings.strHome,
      
                        textColor: AppColors.whiteColor,
                        bgColor: AppColors.primaryColor100,
                        onClick: () {
                          widget.homeCallback();
                        },
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

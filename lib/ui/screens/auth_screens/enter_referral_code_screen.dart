import 'dart:ffi';

import 'package:bookfast_customer/controllers/referral_conde_screen_controller.dart';
import 'package:bookfast_customer/ui/screens/home_map_view_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_base_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_container_widget.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnterReferralCode extends StatefulWidget {
  const EnterReferralCode({super.key});

  @override
  State<EnterReferralCode> createState() => _EnterReferralCodeState();
}

final ReferralCodeController _controller = Get.put(ReferralCodeController());

class _EnterReferralCodeState extends State<EnterReferralCode> {

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bfprimarythemeColor2,
      child: SafeArea(
        left: true,
        top: true,
        right: true,
        bottom: true,
        child: Scaffold(
          body: AppBaseScreen(
              child: Column(
            children: [
              CommonAppBar(
                showBackButton: true,
                onBackPress: () {
                  Get.back();
                },
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppTextWidget(
                          AppStrings.strEnterReferralCode,
                          style: AppTextStyles.headingH7TextStyle(textColor: AppColors.textColor90, fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 6),
                      AppTextWidget(
                        "Referral code is optional. You can skip if you don’t have one.",
                        style: AppTextStyles.body1RegularTextStyle(
                          textColor: AppColors.textColor60,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _controller.referralCodeController.value,
                        decoration: InputDecoration(
                          hintText: AppStrings.strReferralCode,
                          hintStyle: const TextStyle(color: AppColors.textColor60),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor90),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor90, width: 1),
                          ),
                        ),
                        cursorColor: AppColors.backColor1,
                      ),
                      const SizedBox(height: 50),
                   /*   Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppContainer(
                              height: 60,
                              width: 60,
                              allBorderRadius: 100,
                              color: AppColors.bprimarycolor,
                              child: Image.asset(
                                AppImages.icRightArrow,
                                height: 25,
                                width: 30,
                                color: AppColors.whiteColor,
                              ),
                              onTap: () {
                                if (_controller.referralCodeController.value.text.trim().isEmpty) {
                                  Get.to(const HomeMapViewScreen());
                                } else {
                                  _controller.hitReferralCodeApi(callBack: () {
                                    Get.to(const HomeMapViewScreen());
                                  });
                                }
                              })
                        ],
                      )*/

                      Row(
                        children: [
                          Expanded(
                            child: AppContainer(
                              height: 40,
                              color: AppColors.bfprimarythemeColor2,
                              allBorderRadius: 4,
                              child: AppTextWidget(
                                'Next',
                                style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.whiteColor, fontWeight: FontWeight.w600),
                              ),
                              onTap: () {
                                if (_controller.referralCodeController.value.text.trim().isEmpty) {
                                  Get.to(const HomeMapViewScreen());
                                } else {
                                  _controller.hitReferralCodeApi(callBack: () {
                                    Get.to(const HomeMapViewScreen());
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 15,),
                          AppContainer(
                            padding: EdgeInsets.all(8),
                            height: 40,
                            color: AppColors.textColor30,
                            allBorderRadius: 4,
                            child: AppTextWidget(
                              ' Skip ',
                              style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor90, fontWeight: FontWeight.w600),
                            ),
                            onTap: () {
                            Get.to(HomeMapViewScreen());
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ))
            ],
          )),
        ),
      ),
    );
  }
}

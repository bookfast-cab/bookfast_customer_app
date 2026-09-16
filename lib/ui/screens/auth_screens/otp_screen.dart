import 'package:bookfast_customer/controllers/phone_number_screen_controler.dart';
import 'package:bookfast_customer/ui/widgets/app_otp_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/otp_screen_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_text_styles.dart';
import '../../widgets/app_base_screen.dart';
import '../../widgets/app_container_widget.dart';
import '../../widgets/app_text_widget.dart';
import '../../widgets/common_app_bar.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({super.key,this.phoneNumber, this.token, this.isNewCustomer = false});
  String? phoneNumber;
  String? token;
  bool isNewCustomer;

  @override
  State<OtpScreen> createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  final OtpScreenController _controller = Get.put(OtpScreenController());
  final PhoneNumberScreenController _phoneNumberScreenController = Get.put(PhoneNumberScreenController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    if (widget.phoneNumber != null) {
      _phoneNumberScreenController.phoneNumberController.value.text = widget.phoneNumber!;
    }

    if (widget.token != null) {
      _controller.token.value = widget.token!;
    }
    _controller.isNewCustomer.value = widget.isNewCustomer;
      _controller.startTimer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bfPrimaryColor,
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
                backButtonImage: AppImages.icBackWithPadding,
                titleText: AppStrings.strEnterYourOtp,
                isTitleCenter: false,
                titleTextColor: AppColors.textColor100,
                 showBackButton: true,
                 onBackPress: (){
                   Get.back();
                },
              ),
              Expanded(
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: SingleChildScrollView(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(AppImages.imgOtpVerify,height: Get.height/4),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppTextWidget(
                          "Account Verification",
                          style: AppTextStyles.body2RegularTextStyle(fontWeight: FontWeight.w600, fontSize: 16, textColor: AppColors.textColor90),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppTextWidget(
                          AppStrings.strEnterTheCodeYouHave,
                          style: AppTextStyles.body2RegularTextStyle(fontWeight: FontWeight.w400, fontSize: 14, textColor: AppColors.textColor90),
                        ),
                      ),
                      const SizedBox(height: 30),
                      AppOtpField(
                        otpCount: 6,
                        onChange: (v) {
                          if (v.length < 6) {
                            _controller.isButtonEnabled.value = false;
                          } else {
                            _controller.isButtonEnabled.value = true;
                          }
                        },
                        onComplete: (v) {
                          print("_controller.isButtonEnabled.value ${_controller.isButtonEnabled.value}");
                          _controller.isButtonEnabled.refresh();
                          _controller.enteredOtp.value = v;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Obx(() {
                          return GestureDetector(
                            onTap: _controller.isResendActive.value
                                ? _controller.resendOtp
                                : null,
                            child: Text(
                              _controller.isResendActive.value
                                  ? "Resend OTP"
                                  : "Resend Code in ${_controller.timerValue.value}",
                              style: TextStyle(
                                color: _controller.isResendActive.value
                                    ? AppColors.textColor90
                                    : AppColors.textColor60,
                                decoration: _controller.isResendActive.value
                                    ? TextDecoration.underline
                                    : null,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                             ),
                            );
                           }
                          ),
                        ),
                      const SizedBox(height: 30),
                     /* Row(
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
                              _controller.onVerifyOtpClick();
                               },
                              ),
                            ],
                          )*/
                      AppContainer(
                        height: 45,
                        allBorderRadius: 12,
                        color: AppColors.bfPrimaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Icon(Icons.arrow_forward_ios,color: Colors.white,size: 16,)
                          ],),
                        onTap: () {
                          _controller.onVerifyOtpClick();
                        },
                      )
                        ],
                      ),
                  ),
                  )
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}

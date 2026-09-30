import 'package:bookfast_customer/controllers/phone_number_screen_controler.dart';
import 'package:bookfast_customer/ui/widgets/app_otp_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/otp_screen_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../widgets/app_base_screen.dart';
import '../../widgets/common_app_bar.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({super.key, this.phoneNumber, this.token, this.isNewCustomer = false});
  final String? phoneNumber;
  final String? token;
  final bool isNewCustomer;

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
      color: AppColors.bfbackgroundColor, // Modern soft background
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: AppBaseScreen(
            child: Column(
              children: [
                CommonAppBar(
                  backButtonImage: AppImages.icBackWithPadding,
                  titleText: 'Verification',
                  isTitleCenter: false,
                  titleTextColor: Colors.black87,
                  backgroundColor: Colors.transparent,
                  showBackButton: true,
                  onBackPress: () {
                    Get.back();
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          // Illustration
                          
                          Padding(
                          padding:  EdgeInsets.only(left: 50,bottom: 30,top: 30),
                          child: Image.asset(AppImages.imgOtpVerify,height: Get.height/4.5)),
                          const SizedBox(height: 32),
                          
                          // Header Texts
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Verify Account",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                                children: [
                                  const TextSpan(text: "Please enter the 6-digit code sent to\n"),
                                  TextSpan(
                                    text: "+91 ${widget.phoneNumber ?? 'your number'}",
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Custom OTP Field
                          AppOtpField(
                            controller: _controller.otpController,
                            otpCount: 6,
                            onChange: (v) {
                              if (v.length < 6) {
                                _controller.isButtonEnabled.value = false;
                              } else {
                                _controller.isButtonEnabled.value = true;
                              }
                            },
                            onComplete: (v) {
                              _controller.isButtonEnabled.refresh();
                              _controller.enteredOtp.value = v;
                              FocusScope.of(context).unfocus();
                              _controller.onVerifyOtpClick();
                            },
                          ),
                          const SizedBox(height: 32),
                          
                          // Timer & Resend
                          Center(
                            child: Obx(() {
                              return GestureDetector(
                                onTap: _controller.isResendActive.value ? _controller.resendOtp : null,
                                child: Text(
                                  _controller.isResendActive.value
                                      ? "Didn't receive code? Resend OTP"
                                      : "Resend Code in ${_controller.timerValue.value}",
                                  style: TextStyle(
                                    color: _controller.isResendActive.value
                                        ? AppColors.bfprimarythemeColor2
                                        : Colors.grey.shade500,
                                    fontWeight: _controller.isResendActive.value 
                                        ? FontWeight.bold 
                                        : FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Modern Submit Button
                          InkWell(
                            onTap: () {
                              // Ensure keyboard hides on tap
                              FocusScope.of(context).unfocus();
                              _controller.onVerifyOtpClick();
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              height: 54,
                              decoration: BoxDecoration(
                                color: AppColors.bfprimarythemeColor2,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.bfprimarythemeColor2.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Verify & Continue',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
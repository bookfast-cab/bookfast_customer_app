import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookfast_customer/utils/app_dimens.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../utils/app_colors.dart';

class AppOtpField extends StatelessWidget {
  AppOtpField({Key? key, this.onComplete, this.onChange, this.otpCount = 4}) : super(key: key);

  Function(String)? onComplete;
  Function(String)? onChange;
  int otpCount;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      hintCharacter: "",
      hintStyle: AppTextStyles.titleTextStyle(textColor: AppColors.textColor30),
      backgroundColor: Colors.transparent,
      autoDisposeControllers: false,
      // controller: _otpVerifyController.controller,
      validator: (value) {
        if (value!.isEmpty || value.length < otpCount) {
          // _otpVerifyController.isEnabledLoginButton.value = false;
          return 'Please enter verification code'.tr;
        }
        return null;
      },
      appContext: context,
      length: otpCount,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        print(value);

        if (onChange != null) {
          onChange!(value);
        }
      },
      pinTheme: PinTheme(
        borderWidth: 1,
        activeBorderWidth: 1,
        errorBorderWidth: 1,
        inactiveBorderWidth: 1,
        fieldWidth: /*(Get.width / 6.5)+*/ Get.width / (otpCount + 1),
        fieldHeight: Get.width / 7,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        // fieldHeight: Get.height * 0.072,
        // fieldWidth: Get.width * 0.5,
        inactiveColor: AppColors.textColor40,
        activeColor: Colors.grey,
        selectedColor: Colors.grey,
      ),
      onCompleted: (value) {
        print(value.length);
        if (value.length == otpCount) {
          // _otpVerifyController.isEnabledLoginButton.value = true;
          if (onComplete != null) {
            onComplete!(value);
          }
          print("valid pin");
        } else {
          // _otpVerifyController.isEnabledLoginButton.value = false;

          print("invalid pin");
        }
      },
    );
  }
}

import 'package:bookfast_customer/controllers/phone_number_screen_controler.dart';
import 'package:bookfast_customer/ui/widgets/app_button_widget.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../utils/app_images.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final PhoneNumberScreenController _controller = Get.put(PhoneNumberScreenController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bfPrimaryColor,
      child: SafeArea(
        left: true,
        right: true,
        top: true,
        bottom: true,
        child: Scaffold(
          body: Stack(
            children: [
              Image.asset(AppImages.imgSplash,fit: BoxFit.cover,height: double.infinity,width: double.infinity,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      AppTextWidget(
                       AppStrings.strWelComeToBookFast,style: AppTextStyles.headingH7TextStyle(textColor: AppColors.textColor90,fontSize: 18,fontWeight: FontWeight.w500),),
                      const SizedBox(height: 8),
                      AppTextWidget(
                          AppStrings.strEnterYourNumberToContinue,style: AppTextStyles.headingH7TextStyle(textColor: AppColors.textColor60,fontSize: 16,fontWeight: FontWeight.w400),),
                      const SizedBox(height: 20),
                       TextFormField(
                         controller: _controller.phoneNumberController.value,
                        decoration: const InputDecoration(
                          hintText: '+91',
                          hintStyle: TextStyle(color: AppColors.textColor60),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor90),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textColor90,width: 1),
                          ),
                        ),
                        cursorColor: AppColors.backColor1,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                         validator: (value) {
                           if (value == null || value.isEmpty) {
                             return 'Please enter your phone number';
                           }
                           if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                             return 'Please enter a valid 10-digit phone number';
                           }
                           return null;
                         },
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: AppButton(
                          bgColor: AppColors.bfPrimaryColor,
                          title: AppStrings.strSendOtp,
                          buttonRadius: 20,
                          onClick: () {
                            if (formKey.currentState!.validate()) {
                              _controller.onRegisterClick();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

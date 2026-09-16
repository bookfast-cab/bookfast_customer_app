import 'package:bookfast_customer/ui/screens/auth_screens/enter_referral_code_screen.dart';
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
import '../../../controllers/create_email_screen_contoller.dart';

class CreateEmailScreen extends StatefulWidget {
  const CreateEmailScreen({super.key,required this.editProfile});
  final bool editProfile;
  @override
  State<CreateEmailScreen> createState() => _CreateEmailScreenState();
}

class _CreateEmailScreenState extends State<CreateEmailScreen> {
  final CreateEmailScreenController _controller = Get.put(CreateEmailScreenController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller.editProfile.value = widget.editProfile;
    _controller.hitGetProfile(callBack: (){});
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
                    titleText: AppStrings.strCreateEmail,
                    isTitleCenter: false,
                    titleTextColor: AppColors.textColor100,
                    onBackPress: () {
                      Get.back();
                    },
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextWidget(
                                "What's your email?",
                                style: AppTextStyles.headingH5TextStyle(
                                  textColor: AppColors.textColor100,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(height: 8),
                              AppTextWidget(
                                "Please enter a valid email address.\nWe’ll use this to send you important updates.",
                                style: AppTextStyles.body2RegularTextStyle(
                                  textColor: AppColors.textColor70,
                                  fontSize: 14,
                                ),
                              ),
                              // Align(
                              //   alignment: Alignment.centerLeft,
                              //   child: AppTextWidget(
                              //     AppStrings.strEnterYourEmail,
                              //     style: AppTextStyles.headingH7TextStyle(textColor: AppColors.textColor90, fontWeight: FontWeight.w500, fontSize: 18),
                              //   ),
                              // ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _controller.emailController.value,
                                decoration:  InputDecoration(
                                  hintText: AppStrings.strJohnGmail,
                                  hintStyle: const TextStyle(color: AppColors.textColor60),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.textColor90),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.textColor90,width: 1),
                                  ),
                               //   prefixIcon: Icon(Icons.email)
                                ),
                                cursorColor: AppColors.backColor1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 50),
                            /*  Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AppContainer(
                                    height: 60,
                                    width: 60,
                                    allBorderRadius: 100,
                                    color: AppColors.bprimarycolor,
                                    child: Image.asset(AppImages.icRightArrow,height: 25,width: 30,color: AppColors.whiteColor,),
                                    onTap: (){
                                      if(_formKey.currentState!.validate()) {
                                        _controller.hitCustomerUpdateProfile(callBack: () {
                                          if (widget.editProfile) {
                                            //  _controller.hitGetProfile(callBack: () {
                                            Get.back();
                                            //  });
                                          } else {
                                            Get.to(const EnterReferralCode());
                                          }
                                         }
                                        );
                                      }
                                    },
                                  ),
                                ],
                              )*/
                              AppContainer(
                                height: 40,
                                color: AppColors.bfPrimaryColor,
                                allBorderRadius: 4,
                                child: AppTextWidget(
                                  'Next',
                                  style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.whiteColor, fontWeight: FontWeight.w600),
                                ),
                                onTap: () {
                                  if(_formKey.currentState!.validate()) {
                                    _controller.hitCustomerUpdateProfile(callBack: () {
                                      if (widget.editProfile) {
                                        Get.back();
                                      } else {
                                        Get.to(const EnterReferralCode());
                                      }
                                    }
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              )),
        ),
      ),
    );
  }
}

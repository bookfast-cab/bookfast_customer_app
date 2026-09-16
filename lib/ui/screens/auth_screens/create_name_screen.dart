import 'package:bookfast_customer/controllers/create_name_screen_controller.dart';
import 'package:bookfast_customer/ui/screens/auth_screens/create_email_screen.dart';
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

class CreateNameScreen extends StatefulWidget {
  const CreateNameScreen({super.key, required this.editProfile});
  final bool editProfile;
  @override
  State<CreateNameScreen> createState() => CreateNameScreenState();
}

class CreateNameScreenState extends State<CreateNameScreen> {
  final CreateNameScreenController _controller = Get.put(CreateNameScreenController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.editProfile.value = widget.editProfile;
      _controller.hitGetProfile(callBack: () {});
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
                titleText: AppStrings.strCreateName,
                isTitleCenter: false,
                titleTextColor: AppColors.textColor100,
                onBackPress: () {
                  Get.back();
                },
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Form(
                  key: _controller.formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AppTextWidget(
                            "What's your name?",
                            style: AppTextStyles.headingH5TextStyle(
                              textColor: AppColors.textColor100,
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AppTextWidget(
                            "Please enter your first and last name.\nThis will be shown on your profile.",
                            style: AppTextStyles.body2RegularTextStyle(
                              textColor: AppColors.textColor70,
                              fontSize: 14,
                            ),
                          ),
                        ),


                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: AppTextWidget(
                        //     AppStrings.strEnterYourName,
                        //     style: AppTextStyles.headingH7TextStyle(textColor: AppColors.textColor90, fontWeight: FontWeight.w500, fontSize: 18),
                        //   ),
                        // ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _controller.firstNameController.value,
                                decoration: InputDecoration(
                                  hintText: AppStrings.strFirst,
                                  hintStyle: const TextStyle(color: AppColors.textColor60),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.textColor90),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.textColor90, width: 1),
                                  ),
                                ),
                                cursorColor: AppColors.backColor1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _controller.lastNameController.value,
                                decoration: InputDecoration(
                                  hintText: AppStrings.strLast,
                                  hintStyle: const TextStyle(color: AppColors.textColor60),
                                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textColor90)),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.textColor90, width: 1),
                                  ),
                                ),
                                cursorColor: AppColors.backColor1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                       /* Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppContainer(
                              height: 60,
                              width: 60,
                              allBorderRadius: 100,
                              color: AppColors.bprimarycolor,
                              child: Image.asset(AppImages.icRightArrow, height: 25, width: 30, color: AppColors.whiteColor),
                              onTap: () {
                                if (_controller.formKey.currentState!.validate()) {
                                  _controller.hitCustomerUpdateProfileApi(callBack: () {
                                    if (widget.editProfile) {
                                    //  _controller.hitGetProfile(callBack: () {
                                        Get.back();
                                    //  });
                                    } else {
                                      Get.to(const CreateEmailScreen(editProfile: false,));
                                    }
                                  });
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
                            if (_controller.formKey.currentState!.validate()) {
                              _controller.hitCustomerUpdateProfileApi(callBack: () {
                                if (widget.editProfile) {
                                  Get.back();
                                } else {
                                  Get.to(const CreateEmailScreen(editProfile: false,));
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
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

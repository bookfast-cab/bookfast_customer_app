import 'dart:io';
import 'package:bookfast_customer/ui/screens/auth_screens/enter_referral_code_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_base_screen.dart';
import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/create_email_screen_contoller.dart';

class CreateEmailScreen extends StatefulWidget {
  const CreateEmailScreen({super.key, required this.editProfile});
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
    _controller.hitGetProfile(callBack: () {});
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
                  titleText: widget.editProfile ? 'Update Email' : AppStrings.strCreateEmail,
                  isTitleCenter: false,
                  titleTextColor: Colors.black87,
                  backgroundColor: Colors.transparent,
                  onBackPress: () {
                    Get.back();
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header texts
                          const Text(
                            "What's your email?",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Please enter a valid email address.\nWe’ll use this to send you important ride updates and invoices.",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Modern Text Field
                          TextFormField(
                            controller: _controller.emailController.value,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. john.doe@gmail.com',
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: AppColors.bfprimarythemeColor2,
                                size: 22,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: AppColors.bfprimarythemeColor2, width: 1.5),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: Colors.red.shade300, width: 1.2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
                              ),
                            ),
                            cursorColor: AppColors.bfprimarythemeColor2,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          
                          // Modern Submit Button
                          InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                // Hide keyboard
                                FocusScope.of(context).unfocus();
                                
                                _controller.hitCustomerUpdateProfile(callBack: () {
                                  if (widget.editProfile) {
                                    Get.back();
                                  } else {
                                    Get.to(() => const EnterReferralCode());
                                  }
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              height: 52,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.bfprimarythemeColor2,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.bfprimarythemeColor2.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.editProfile ? 'Update Email' : 'Next',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
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
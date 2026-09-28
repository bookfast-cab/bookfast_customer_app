import 'dart:io';
import 'package:bookfast_customer/controllers/create_name_screen_controller.dart';
import 'package:bookfast_customer/ui/screens/auth_screens/create_email_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_base_screen.dart';
import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
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
      color: AppColors.bfbackgroundColor, // Modern soft background
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: AppBaseScreen(
            child: Column(
              children: [
                CommonAppBar(
                  backButtonImage: AppImages.icBackWithPadding,
                  titleText: widget.editProfile ? 'Update Name' : AppStrings.strCreateName,
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
                      key: _controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header texts
                          const Text(
                            "What's your name?",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Please enter your first and last name.\nThis will be shown on your profile and to your drivers.",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // First Name Field
                          TextFormField(
                            controller: _controller.firstNameController.value,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            decoration: _buildInputDecoration(
                              hintText: AppStrings.strFirst,
                              icon: Icons.person_outline,
                            ),
                            cursorColor: AppColors.bfprimarythemeColor2,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Last Name Field
                          TextFormField(
                            controller: _controller.lastNameController.value,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            decoration: _buildInputDecoration(
                              hintText: AppStrings.strLast,
                              icon: Icons.person_outline,
                            ),
                            cursorColor: AppColors.bfprimarythemeColor2,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),

                          // Modern Submit Button
                          InkWell(
                            onTap: () {
                              if (_controller.formKey.currentState!.validate()) {
                                // Hide keyboard
                                FocusScope.of(context).unfocus();

                                _controller.hitCustomerUpdateProfileApi(callBack: () {
                                  if (widget.editProfile) {
                                    Get.back();
                                  } else {
                                    Get.to(() => const CreateEmailScreen(editProfile: false));
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
                                widget.editProfile ? 'Update Name' : 'Next',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Extracted input decoration for cleaner code
  InputDecoration _buildInputDecoration({required String hintText, required IconData icon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400),
      prefixIcon: Icon(
        icon,
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
    );
  }
}
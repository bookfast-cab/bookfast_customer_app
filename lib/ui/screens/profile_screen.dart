import 'dart:io';
import 'package:bookfast_customer/controllers/profile_screen_controller.dart';
import 'package:bookfast_customer/ui/screens/auth_screens/create_email_screen.dart';
import 'package:bookfast_customer/ui/screens/auth_screens/create_name_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_base_screen.dart';
import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_functions.dart';
import '../../utils/app_network_image.dart';
import 'app_drawer.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final ProfileScreenController _controller = Get.put(ProfileScreenController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          drawer: const AppDrawer(),
          body: Column(
            children: [
              CommonAppBar(
                titleText: AppStrings.strProfile,
                isTitleCenter: false,
                titleTextColor: Colors.black87,
                backgroundColor: Colors.transparent,
                leadingWidget: IconButton(
                  icon: Image.asset(AppImages.icDrawer, height: 28, width: 28),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // --- Profile Picture Section ---
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                height: 115,
                                width: 115,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.bfprimarythemeColor2, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.bfprimarythemeColor2.withOpacity(0.15),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: _controller.fileName.value.isNotEmpty
                                      ? (_controller.fileName.value.startsWith("http")
                                          ? AppNetworkImage(
                                              imageUrl: '${_controller.fileName.value}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                              height: 115,
                                              width: 115,
                                              radius: 100,
                                            )
                                          : Image.file(
                                              File(_controller.fileName.value),
                                              fit: BoxFit.cover,
                                              height: 115,
                                              width: 115,
                                            ))
                                      : (_controller.profilePicUrl.value.isNotEmpty
                                          ? AppNetworkImage(
                                              imageUrl: '${_controller.profilePicUrl.value}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                              height: 115,
                                              width: 115,
                                              radius: 100,
                                            )
                                          : Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Image.asset(
                                                AppImages.icUser,
                                                fit: BoxFit.contain,
                                              ),
                                          )),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => _controller.pickFile(),
                                  child: Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.bfprimarythemeColor2,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "${_controller.firstNameController.value.text} ${_controller.lastNameController.value.text}".trim().isEmpty 
                            ? "Loading..." 
                            : "${_controller.firstNameController.value.text} ${_controller.lastNameController.value.text}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _controller.phoneNumberController.value.text,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // --- Personal Info Card ---
                        _buildSectionHeader("Personal Details"),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _profileInfoTile(
                                title: AppStrings.strFirstName,
                                value: _controller.firstNameController.value.text,
                                icon: Icons.person_outline,
                                isEditable: true,
                                onTap: () {
                                  Get.to(const CreateNameScreen(editProfile: true))!.then((value) => _controller.hitGetProfile(callBack: () {}));
                                },
                              ),
                              Divider(height: 1, color: Colors.grey.shade100, indent: 50),
                              _profileInfoTile(
                                title: AppStrings.strLastName,
                                value: _controller.lastNameController.value.text,
                                icon: Icons.person_outline,
                                isEditable: true,
                                onTap: () {
                                  Get.to(const CreateNameScreen(editProfile: true))!.then((value) => _controller.hitGetProfile(callBack: () {}));
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- Contact Info Card ---
                        _buildSectionHeader("Contact Information"),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _profileInfoTile(
                                title: AppStrings.strPhoneNumber,
                                value: _controller.phoneNumberController.value.text,
                                icon: Icons.phone_outlined,
                                isEditable: false, // Phone usually locked to account
                                onTap: () {},
                              ),
                              Divider(height: 1, color: Colors.grey.shade100, indent: 50),
                              _profileInfoTile(
                                title: AppStrings.strEmail,
                                value: _controller.emailController.value.text.isEmpty ? "Add Email Address" : _controller.emailController.value.text,
                                icon: Icons.email_outlined,
                                isEditable: true,
                                onTap: () {
                                  Get.to(const CreateEmailScreen(editProfile: true))!.then((value) => _controller.hitGetProfile(callBack: () {}));
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for Section Titles
  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Helper widget for rendering a clean, modern list tile for profile fields
  Widget _profileInfoTile({
    required String title,
    required String value,
    required IconData icon,
    required bool isEditable,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEditable ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.bfCardLightBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.bfprimarythemeColor2, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isEditable)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_outlined, size: 18, color: Colors.black54),
                )
              else
                const Icon(Icons.verified_user_outlined, size: 20, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
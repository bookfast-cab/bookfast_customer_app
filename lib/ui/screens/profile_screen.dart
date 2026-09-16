import 'dart:io';
import 'package:bookfast_customer/controllers/profile_screen_controller.dart';
import 'package:bookfast_customer/ui/screens/auth_screens/create_email_screen.dart';
import 'package:bookfast_customer/ui/screens/auth_screens/create_name_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_base_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_container_widget.dart';
import 'package:bookfast_customer/ui/widgets/app_text_field_widget.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
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
      _controller.hitGetProfile(callBack: (){});
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
          key: _scaffoldKey,
          drawer: const AppDrawer(),
          body: AppBaseScreen(
            child: Column(
              children: [
                CommonAppBar(
                  titleText: AppStrings.strProfile,
                  isTitleCenter: false,
                  titleTextColor: AppColors.textColor100,
                  leadingWidget: IconButton(
                    icon: Image.asset(AppImages.icDrawer, height: 33, width: 33),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                    child: Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  AppContainer(
                                    height: 100,
                                    width: 100,
                                    borderColor: AppColors.bfPrimaryColor,
                                    allBorderRadius: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: _controller.fileName.value.isNotEmpty
                                          ? _controller.fileName.value.startsWith("http")
                                          ? AppNetworkImage(
                                        imageUrl: '${_controller.fileName.value}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                        height: 110,
                                        width: 110,
                                        radius: 100,
                                      )
                                          : Image.file(
                                        File(_controller.fileName.value),
                                        fit: BoxFit.cover,
                                        height: 110,
                                        width: 110,
                                      )
                                          : _controller.profilePicUrl.value.isNotEmpty
                                          ? AppNetworkImage(
                                        imageUrl: '${_controller.profilePicUrl.value}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                        height: 110,
                                        width: 110,
                                        radius: 100,
                                      )
                                          : Image.asset(
                                        AppImages.icUser,
                                        fit: BoxFit.cover,
                                        height: 110,
                                        width: 110,
                                      ),
                                    ),

                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 0,
                                    child: AppContainer(
                                      height: 25,
                                      width: 25,
                                      borderColor: AppColors.bfPrimaryColor,
                                      color: AppColors.whiteColor,
                                      allBorderRadius: 100,
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      onTap: () {
                                        _controller.pickFile();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            // _divider(),
                            // const SizedBox(height: 15),
                            AppTextWidget(AppStrings.strFirstName,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor60,fontSize: 14),),
                           _textField(_controller.firstNameController.value,(){
                             Get.to(const CreateNameScreen(editProfile: true))!.then((value) => _controller.hitGetProfile(callBack: () {}));
                           }),
                            const SizedBox(height: 15),
                            AppTextWidget(AppStrings.strLastName,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor60,fontSize: 14),),
                            const SizedBox(height: 5),
                            _textField(_controller.lastNameController.value,(){
                              Get.to(const CreateNameScreen(editProfile: true))!.then((value) => _controller.hitGetProfile(callBack: () {}));
                            }),
                            const SizedBox(height: 15),
                            AppTextWidget(AppStrings.strPhoneNumber,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor60,fontSize: 14),),
                            const SizedBox(height: 5),
                            _textField(_controller.phoneNumberController.value,(){}),
                            const SizedBox(height: 15),
                            AppTextWidget(AppStrings.strEmail,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor60,fontSize: 14),),
                            const SizedBox(height: 5),
                            _textField(_controller.emailController.value,(){
                              Get.to(const CreateEmailScreen(editProfile: true))!.then((value) => _controller.hitGetProfile(callBack: () {}));
                            }),
                            // const SizedBox(height: 20),
                            // AppTextWidget(AppStrings.strGender,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor60,fontSize: 14),),
                            // const SizedBox(height: 8),
                            // _textField(_controller.genderController.value),
                          ],
                        );
                      }
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
  _textField(TextEditingController controller, Callback onTap){
    return AppTextFieldWidget(
      readOnly: true,
      controller: controller,
      onTap: onTap,
    );

    // return TextFormField(
    //   readOnly: true,
    //     controller: controller,
    //     decoration: const InputDecoration(
    //       // enabledBorder: UnderlineInputBorder(
    //       //   borderSide: BorderSide(color: AppColors.textColor40),
    //       // ),
    //       focusedBorder: UnderlineInputBorder(
    //         borderSide: BorderSide(color: AppColors.textColor40,width: 1),
    //       ),
    //     ),
    //     cursorColor: AppColors.backColor1,
    //   onTap: onTap,
    // );
  }
  _divider() {
    return AppContainer(
      height: 1,
      color: AppColors.textColor40,
    );
  }
}

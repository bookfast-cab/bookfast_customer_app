import 'dart:io';

import 'package:bookfast_customer/controllers/app_drawer_controller.dart';
import 'package:bookfast_customer/controllers/profile_screen_controller.dart';
import 'package:bookfast_customer/ui/screens/about_us_screen.dart';
import 'package:bookfast_customer/ui/screens/admin_chat_screen.dart';
import 'package:bookfast_customer/ui/screens/auth_screens/phone_number_screen.dart';
import 'package:bookfast_customer/ui/screens/chat_support_screen.dart';
import 'package:bookfast_customer/ui/screens/home_map_view_screen.dart';
import 'package:bookfast_customer/ui/screens/my_rides_history_screen.dart';
import 'package:bookfast_customer/ui/screens/notificatoin_screen.dart';
import 'package:bookfast_customer/ui/screens/privacy_policy_screen.dart';
import 'package:bookfast_customer/ui/screens/wallet_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:get/get.dart';
import '../../handlers/session_handler/session_manager.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_functions.dart';
import '../../utils/app_images.dart';
import '../../utils/app_network_image.dart';
import '../../utils/app_strings.dart';
import '../dialogs/common_alert_dialog.dart';
import 'profile_screen.dart';
import 'refer_and_earn_screen.dart';
import 'reward_screen.dart';
import 'sos_setting_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AppDrawerController _controller = Get.put(AppDrawerController());
  final ProfileScreenController _profileScreenController = Get.put(ProfileScreenController());

  @override
  void initState() {
    _profileScreenController.hitGetProfile(callBack: () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              AppContainer(
                height: 70,
                width: 70,
                allBorderRadius: 100,
                borderColor: AppColors.bfPrimaryColor,
                child: _profileScreenController.profilePicUrl.value.isNotEmpty
                    ? AppNetworkImage(
                        imageUrl: AppFunctions.getImagePath(
                          '${_profileScreenController.profilePicUrl.value}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                        ),
                        height: 90,
                        width: 90,
                        radius: 100,
                      )
                    : Image.asset(
                        AppImages.icUser,
                        height: 90,
                        width: 90,
                        fit: BoxFit.contain,
                      ),
              ),
              const SizedBox(height: 10),
              AppTextWidget(
                "Hi! ${_profileScreenController.firstNameController.value.text} ${_profileScreenController.lastNameController.value.text}",
                style: AppTextStyles.headingH7TextStyle(textColor: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(height: 20),
              _listTile(0, Icons.home_outlined, 'Home', () {
                _controller.selectItem(0);
                Get.to(const HomeMapViewScreen());
              }),
              _listTile(1, Icons.directions_car_rounded, 'My Rides', () {
                _controller.selectItem(1);
                Get.to(const MyRidesHistoryScreen());
              }),
              // _listTile(2, Icons.messenger_outline, 'Admin Chat', () {
              //   _controller.selectItem(2);
              //   Get.to(const AdminChatScreen());
              // }),
              _listTile(3, Icons.perm_identity, 'Profile Setting', () {
                _controller.selectItem(3);
                Get.to(const MyProfileScreen());
              }),
              // _listTile(4, Icons.account_balance_wallet_outlined, 'Wallet', () {
              //   _controller.selectItem(4);
              //   Get.to(const WalletScreen());
              // }),
              _listTile(5, Icons.notifications_none, 'Notification', () {
                _controller.selectItem(5);
                Get.to(const NotificationScreen());
              }),
              // _listTile(6, Icons.bookmark_outline_outlined, 'Rewards', () {
              //   _controller.selectItem(6);
              //   Get.to(const RewardScreen());
              // }),
              // _listTile(6, Icons.support_agent, 'Chat Support', () {
              //   _controller.selectItem(6);
              //   Get.to(const ChatSupportScreen());
              // }),
              _listTile(7, Icons.share, 'Share', () {
                _controller.selectItem(7);

                AppFunctions.shareMyApp("Bookfast – Book your ride, anytime! 🚕"
                    "\nFast, reliable cab booking for local & outstation trips."
                    "\nDownload now 👉${AppConstants.urlBookFastAppSore}");
              }),
              // _listTile(8, Icons.call, 'SOS Settings', () {
              //   _controller.selectItem(8);
              //   Get.to(const SOSSettingScreen());
              // }),
              _listTile(9, Icons.privacy_tip, 'Privacy Policies', () {
                _controller.selectItem(9);
                Get.to(const PrivacyPolicyScreen());
              }),
              // _listTile(10, Icons.app_blocking_outlined, 'About Us', () {
              //   _controller.selectItem(10);
              //   Get.to(const AboutUsScreen());
              // }),
              _listTile(11, Icons.logout_outlined, 'Logout', () {
                _controller.selectItem(11);
                showDialog(
                    context: Get.overlayContext!,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return CommonAlertDialog(
                        description: AppStrings.strAreYouSureToLogout,
                        showCancelButton: true,
                        title: AppStrings.strConfirmation,
                        okButtonText: AppStrings.strOk,
                        cancelButtonText: AppStrings.strCancel,
                        okCallback: () {
                          _controller.hitLogOutApi(callBack: () {
                            SessionManager.clearSharedPrefs();
                            //  Get.offAll(const PhoneNumberScreen());
                            Navigator.pushAndRemoveUntil(
                              Get.overlayContext!,
                              MaterialPageRoute(builder: (BuildContext context) => const PhoneNumberScreen()),
                              (route) => false,
                            );
                          });
                        },
                      );
                    });
              }),
              Divider(
                endIndent: 15,
                indent: 15,
                color: AppColors.textColor40,
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppTextWidget('Follow Us',style: AppTextStyles.body2RegularTextStyle(
                    fontWeight: FontWeight.w600,fontSize: 16,textColor: AppColors.textColor90
                  ),),
                  const SizedBox(height: 8),
                  AppTextWidget('on our social networks',style: AppTextStyles.body2RegularTextStyle(
                      fontWeight: FontWeight.w400,fontSize: 14,textColor: AppColors.textColor60
                  ),),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      AppFunctions.launchURL('https://www.facebook.com/bookfastofficial/');
                    },
                    child: Image.asset(
                      AppImages.icFaceBook,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      AppFunctions.launchURL('https://www.instagram.com/bookfast.in/?hl=en');
                    },
                    child: Image.asset(
                      AppImages.icInstagram,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      AppFunctions.launchURL('https://www.bookfast.in/');
                    },
                    child: Image.asset(
                      AppImages.icBrowser,
                      height: 30,
                      width: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }

  Widget _listTile(int index, IconData icon, String title, Function() onTap) {
    bool isSelected = _controller.selectedIndex.value == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          _controller.selectedIndex.value = index;
          onTap();
        },
        child: AppContainer(
          height: 50,
          allBorderRadius: 10,
          color: isSelected ? AppColors.bfPrimaryColor.withOpacity(0.2) : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.bfPrimaryColor),
                const SizedBox(width: 20),
                Expanded(
                  child: AppTextWidget(
                    title,
                    style: AppTextStyles.headingH7TextStyle(textColor: isSelected ? Colors.blueAccent : AppColors.textColor70, fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

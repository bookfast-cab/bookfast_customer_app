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
    return Drawer(
      backgroundColor: Colors.white,
      child: Obx(() {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Modern Profile Header
              Container(
                padding: const EdgeInsets.only(top: 60, bottom: 24, left: 20, right: 20),
                decoration: const BoxDecoration(
                  color: AppColors.bfCardLightBlue,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.bfprimarythemeColor2, width: 2.5),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.bfprimarythemeColor2.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _profileScreenController.profilePicUrl.value.isNotEmpty
                            ? AppNetworkImage(
                                imageUrl: AppFunctions.getImagePath(
                                  '${_profileScreenController.profilePicUrl.value}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                ),
                                height: 75,
                                width: 75,
                                radius: 100,
                              )
                            : Image.asset(
                                AppImages.icUser,
                                height: 75,
                                width: 75,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back,",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${_profileScreenController.firstNameController.value.text} ${_profileScreenController.lastNameController.value.text}",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Navigation Links
              _listTile(0, Icons.home_outlined, 'Home', () {
                _controller.selectItem(0);
                Get.to(const HomeMapViewScreen());
              }),
              _listTile(1, Icons.directions_car_outlined, 'My Rides', () {
                _controller.selectItem(1);
                Get.to(const MyRidesHistoryScreen());
              }),
              // _listTile(2, Icons.messenger_outline, 'Admin Chat', () {
              //   _controller.selectItem(2);
              //   Get.to(const AdminChatScreen());
              // }),
              _listTile(3, Icons.person_outline, 'Profile Setting', () {
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
              _listTile(7, Icons.share_outlined, 'Share', () {
                _controller.selectItem(7);
                AppFunctions.shareMyApp(
                    "Bookfast – Book your ride, anytime! 🚕\nFast, reliable cab booking for local & outstation trips.\nDownload now 👉${AppConstants.urlBookFastAppSore}");
              }),
              // _listTile(8, Icons.call, 'SOS Settings', () {
              //   _controller.selectItem(8);
              //   Get.to(const SOSSettingScreen());
              // }),
              _listTile(9, Icons.privacy_tip_outlined, 'Privacy Policies', () {
                _controller.selectItem(9);
                Get.to(const PrivacyPolicyScreen());
              }),
              // _listTile(10, Icons.info_outline, 'About Us', () {
              //   _controller.selectItem(10);
              //   Get.to(const AboutUsScreen());
              // }),
              
              const SizedBox(height: 10),
              Divider(
                endIndent: 20,
                indent: 20,
                color: Colors.grey.shade200,
                thickness: 1.5,
              ),
              const SizedBox(height: 10),
              
              _listTile(11, Icons.logout_rounded, 'Logout', () {
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
                          Navigator.pushAndRemoveUntil(
                            Get.overlayContext!,
                            MaterialPageRoute(builder: (BuildContext context) => const PhoneNumberScreen()),
                            (route) => false,
                          );
                        });
                      },
                    );
                  },
                );
              }, isLogout: true),

              const SizedBox(height: 25),

              // Social Media Section
              Column(
                children: [
                  Text(
                    'Follow Us',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'on our social networks',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIcon(AppImages.icFaceBook, 'https://www.facebook.com/bookfastofficial/'),
                      const SizedBox(width: 16),
                      _socialIcon(AppImages.icInstagram, 'https://www.instagram.com/bookfast.in/?hl=en'),
                      const SizedBox(width: 16),
                      _socialIcon(AppImages.icBrowser, 'https://www.bookfast.in/'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _listTile(int index, IconData icon, String title, Function() onTap, {bool isLogout = false}) {
    bool isSelected = _controller.selectedIndex.value == index;
    
    // Assign specific colors for normal items vs logout
    Color iconColor = isLogout ? Colors.red.shade400 : (isSelected ? AppColors.bfprimarythemeColor2 : Colors.grey.shade600);
    Color textColor = isLogout ? Colors.red.shade600 : (isSelected ? AppColors.bfprimarythemeColor2 : Colors.grey.shade800);
    Color bgColor = isSelected ? AppColors.bfCardLightBlue : Colors.transparent;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InkWell(
        onTap: () {
          _controller.selectedIndex.value = index;
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected && !isLogout)
                Icon(
                  Icons.chevron_right,
                  color: AppColors.bfprimarythemeColor2,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(String imagePath, String url) {
    return GestureDetector(
      onTap: () {
        AppFunctions.launchURL(url);
      },
      child: Container(
        height: 44,
        width: 44,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.bfbackgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }
}
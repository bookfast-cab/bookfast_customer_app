import 'package:bookfast_customer/ui/screens/add_sos_contacts_screen.dart';
import 'package:bookfast_customer/ui/screens/app_drawer.dart';
import 'package:bookfast_customer/ui/widgets/app_base_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_common_widgets.dart';
import 'package:bookfast_customer/ui/widgets/app_container_widget.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SOSSettingScreen extends StatefulWidget {
  const SOSSettingScreen({super.key});

  @override
  State<SOSSettingScreen> createState() => _SOSSettingScreenState();
}

class _SOSSettingScreenState extends State<SOSSettingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bfprimarythemeColor2,
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
                  titleText: AppStrings.strSOSSettings,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppCommonWidgets.noDataWidget(text: 'No sos found'),
                      ],
                    ),
                  ),
                ),
                AppContainer(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.bfprimarythemeColor2,
                  child: AppTextWidget(
                    AppStrings.strADD,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.whiteColor,fontWeight: FontWeight.w600),
                  ),
                  onTap: (){
                    Get.to(const AddSOSContactScreen());
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:bookfast_customer/controllers/refer_and_earn_screen_controller.dart';
import 'package:bookfast_customer/ui/screens/app_drawer.dart';
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


class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ReferAndFriendScreenController _controller = Get.put(ReferAndFriendScreenController());
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
                  titleText: AppStrings.strReferAndEarn,
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
                        //AppCommonWidgets.noDataWidget(text: 'No rewards'),
                        AppTextWidget(
                          AppStrings.strReferYourFriendAndGet,
                          style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor80, fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        AppTextWidget(
                          AppStrings.strHiWhenYourFriendsOrRelatives,
                          style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor60, fontWeight: FontWeight.w500, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                AppContainer(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.bfPrimaryColor,
                  child: AppTextWidget(
                    AppStrings.strReferFriends,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.whiteColor,fontWeight: FontWeight.w600),
                  ),
                  onTap: (){
                    _controller.shareReferCode('123456');
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

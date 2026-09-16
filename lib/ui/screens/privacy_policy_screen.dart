import 'package:bookfast_customer/controllers/privacy_policy_screen_controller.dart';
import 'package:bookfast_customer/ui/widgets/app_base_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../widgets/common_app_bar.dart';
import 'app_drawer.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PrivacyPolicyController _controller = Get.put(PrivacyPolicyController());

  @override
  void initState() {
    _controller.hitPrivacyPolicyApi(callBack: (){});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bfPrimaryColor,
      child: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const AppDrawer(),
          body: AppBaseScreen(
            child: Column(
              children: [
                CommonAppBar(
                  titleText: AppStrings.strPrivacyPolicy,
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
                  child: Obx((){
                    return ListView.builder(
                      itemCount: _controller.privacyPolicy.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextWidget(
                                _controller.privacyPolicy[index].title ?? '',style: AppTextStyles.body2RegularTextStyle(
                                  textColor: AppColors.textColor90,fontSize: 16,fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 10),
                              AppTextWidget(
                                  _controller.privacyPolicy[index].description ?? '',style: AppTextStyles.body2RegularTextStyle(
                                  textColor: AppColors.textColor70,fontSize: 14,fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                         );
                       },
                     );
                    }
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

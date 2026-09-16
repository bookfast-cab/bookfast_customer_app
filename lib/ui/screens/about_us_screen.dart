import 'package:bookfast_customer/ui/screens/app_drawer.dart';
import 'package:bookfast_customer/ui/widgets/app_base_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
                  titleText: AppStrings.strAboutUs,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextWidget(AppStrings.strWhoWeAre,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor80,fontSize: 16),),
                        const SizedBox(height: 20),
                        AppTextWidget(AppStrings.strYouCanNowGetAnAdvancedApp,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor60,fontSize: 13),),
                        const SizedBox(height: 20),
                        AppTextWidget(AppStrings.strContactDetails,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor80,fontSize: 16),),
                        const SizedBox(height: 20),
                        _contactDetails(const Icon(Icons.call,color: AppColors.bfPrimaryColor,size: 16,),AppStrings.str919084518000),
                        const SizedBox(height: 20),
                        _contactDetails(const Icon(Icons.mail,color: AppColors.bfPrimaryColor,size: 16,),'Contact@bookfast.in'),
                        const SizedBox(height: 20),
                        _contactDetails(const Icon(Icons.location_on,color: AppColors.bfPrimaryColor,size: 16,),AppStrings.strChandigarh),
                      ],
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
  _contactDetails(Icon icons, String  text){
    return Row(
      children: [
        icons,
        const SizedBox(width: 10),
        AppTextWidget(text,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor60,fontSize: 13),),
      ],
    );
  }
}

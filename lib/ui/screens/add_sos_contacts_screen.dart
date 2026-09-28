import 'package:bookfast_customer/ui/widgets/app_base_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_container_widget.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class AddSOSContactScreen extends StatefulWidget {
  const AddSOSContactScreen({super.key});

  @override
  State<AddSOSContactScreen> createState() => _AddSOSContactScreenState();
}

class _AddSOSContactScreenState extends State<AddSOSContactScreen> {
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
          body: AppBaseScreen(
            child: Column(
              children: [
                CommonAppBar(
                  titleText: AppStrings.strAddContacts,
                  isTitleCenter: false,
                  titleTextColor: AppColors.textColor100,
                 showBackButton: true,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      AppTextWidget(AppStrings.strPhoneNumber,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor80,fontSize: 18),),
                        _sosTextField(AppStrings.strPhoneNumber,isPhone: true),
                        const SizedBox(height: 20),
                        AppTextWidget(AppStrings.strName,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.textColor80,fontSize: 18),),
                        _sosTextField(AppStrings.strFirst),

                      ],
                    ),
                  ),
                ),
                AppContainer(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.bfprimarythemeColor2,
                  child: AppTextWidget(
                    AppStrings.strSUBMIT,style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.whiteColor,fontWeight: FontWeight.w600),
                  ),
                  onTap: (){},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  _sosTextField( String hintText, {bool isPhone = false}){
    return TextField(
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration:  InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textColor60),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.textColor90),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.textColor90,width: 1),
        ),
      ),
      cursorColor: AppColors.backColor1,
    );
  }
}

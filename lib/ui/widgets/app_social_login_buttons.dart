import 'dart:io';

import 'package:bookfast_customer/ui/widgets/app_container_widget.dart';
import 'package:bookfast_customer/utils/app_dimens.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:flutter/material.dart';

class AppSocialLoginButtons extends StatelessWidget {
  AppSocialLoginButtons({Key? key, required this.appleLoginOnTap, required this.facebookLoginOnTap,required this.googleLoginOnTap}) : super(key: key);

  Function() appleLoginOnTap;
  Function() googleLoginOnTap;
  Function() facebookLoginOnTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        if (Platform.isIOS)
          AppContainer(
            onTap: () {
              appleLoginOnTap();
            },
            height: AppDimensions.dmForty,
            width: AppDimensions.dmForty,
            child: Image.asset(
              AppImages.icAppleLogo,
              // height: MediaQuery.of(context).size.width / 1.8,
              // width: MediaQuery.of(context).size.width / 1.8,
              fit: BoxFit.fitHeight,
            ),
          ),
        if (!Platform.isIOS)
          AppContainer(
            onTap: () {
              googleLoginOnTap();
            },
            height: AppDimensions.dmForty,
            width: AppDimensions.dmForty,
            child: Image.asset(
              AppImages.imgGoogle,
              // height: MediaQuery.of(context).size.width / 1.8,
              // width: MediaQuery.of(context).size.width / 1.8,
              fit: BoxFit.fitHeight,
            ),
          ),
        SizedBox(
          width: AppDimensions.dmTen,
        ),
        AppContainer(
          onTap: () {
            facebookLoginOnTap();
          },
          height: AppDimensions.dmForty,
          width: AppDimensions.dmForty,
          child: Image.asset(
            AppImages.imgFacebook,
            // height: MediaQuery.of(context).size.width / 1.8,
            // width: MediaQuery.of(context).size.width / 1.8,
            fit: BoxFit.fitHeight,
          ),
        ),
        Spacer(),
      ],
    );
  }
}

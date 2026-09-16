import 'package:flutter/material.dart';
import 'package:bookfast_customer/ui/widgets/app_container_widget.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_dimens.dart';

class AppAddImageWidget extends StatelessWidget {
  AppAddImageWidget({Key? key, required this.onTap, this.height, this.width, this.iconData = Icons.add, this.borderRadius =  AppDimensions.dmTwelve, this.iconSize = AppDimensions.dmTwenty,}) : super(key: key);

  Function() onTap;
  double? height;
  double? width;
  double borderRadius;
  double iconSize;
  IconData iconData;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
        // backgroundColor: AppColors.dark_100,
        width: width,
        height: height,
        allBorderRadius: borderRadius,
        // borderColor: AppColors.dark_200,
        borderWidth: 1.5,
        onTap: onTap,
        child: Icon(
          iconData,
          size: iconSize,
          // color: AppColors.dark_400,
        ));
  }
}

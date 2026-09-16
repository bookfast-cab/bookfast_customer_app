import 'package:flutter/material.dart';
import 'package:bookfast_customer/utils/app_colors.dart';

class AppCircularWidget extends StatelessWidget {
  AppCircularWidget({
    Key? key,
    this.height,
    this.width,
    this.onPress,
    this.child,
    this.backgroundColor,
    this.padding,

  }) : super(key: key);
  double? height;
  double? width;
  Function? onPress;
  Widget? child;
  Color? backgroundColor;
  EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onPress != null) {
          onPress!();
        }


      },

      child: Container(
        padding: padding??EdgeInsets.zero,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.whiteColor,
          shape: BoxShape.circle
        ),
        alignment: Alignment.center,
        child: child ?? const SizedBox(),
      ),
    );
  }
}

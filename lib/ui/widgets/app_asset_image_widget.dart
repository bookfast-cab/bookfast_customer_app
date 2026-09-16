import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class AppAssetsImageWidget extends StatelessWidget {
  AppAssetsImageWidget({super.key, required this.imagePath,  this.showShadow = false, required this.height, required this.width, this.borderRadius = 0});

  String imagePath;
  bool showShadow;
  double height;
  double width;
  double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        boxShadow: [
          BoxShadow(
            color: showShadow ? AppColors.textColor20.withOpacity(0.7) : Colors.transparent,
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Image.asset(
        imagePath,
        height: height,
        width: width,
      ),
    );
  }
}

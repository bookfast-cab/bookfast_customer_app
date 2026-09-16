import 'package:flutter/material.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import 'app_common_widgets.dart';

class AppInkWellWidget extends StatelessWidget {
  AppInkWellWidget(
      {Key? key, this.onTap, required this.child, this.allBorderRadius = 0.0, this.topLeftRadius = 0.0, this.topRightRadius = 0.0, this.bottomLeftRadius = 0.0, this.bottomRightRadius = 0.0})
      : super(key: key);
  Function()? onTap;
  Widget child;
  final double allBorderRadius;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;

  @override
  Widget build(BuildContext context) {
    return TouchRippleEffect(
      borderRadius: AppCommonWidgets.borderRadius(
          isAll: allBorderRadius > 0, allRadius: allBorderRadius, topLeft: topLeftRadius, topRight: topRightRadius, bottomLeft: bottomLeftRadius, bottomRight: bottomRightRadius),

      rippleColor: onTap == null ? Colors.transparent : Colors.grey.shade400,
      // rippleColor: Colors.grey.shade400,
      onTap: onTap ?? () {},
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:bookfast_customer/ui/widgets/app_common_widgets.dart';

import '../../utils/app_colors.dart';

class AppContainer extends StatelessWidget {
  AppContainer(
      {Key? key,
      this.child,
      this.onTap,
      this.padding = EdgeInsets.zero,
      this.allBorderRadius = 0,
      this.topLeftRadius = 0,
      this.topRightRadius = 0,
      this.bottomLeftRadius = 0,
      this.bottomRightRadius = 0,
      this.borderColor = Colors.transparent,
      this.color = Colors.transparent,
      this.height,
      this.width,
      this.showShadow = false,
      this.margin = EdgeInsets.zero,
      this.borderWidth = 1.0,
      this.alignment = Alignment.center,
      this.shadowColor,
      this.showGradient = false,
      this.gradientColors,
      this.shadowSpreadRadius = 0.0,
      this.shadowBlurRadius = 1.0,
      this.gradientStops,
      this.linearGradient,
      this.shadowOffset,
      this.constraints})
      : super(key: key);

  Widget? child;
  Function()? onTap;
  EdgeInsets padding;
  double allBorderRadius;
  double topLeftRadius;
  double topRightRadius;
  double bottomLeftRadius;
  double bottomRightRadius;
  Color borderColor;
  Color color;
  double? height;
  double? width;
  EdgeInsets margin;
  double borderWidth;
  Alignment alignment;
  bool showShadow;
  Offset? shadowOffset;
  Color? shadowColor;
  double shadowSpreadRadius;
  double shadowBlurRadius;
  bool showGradient;
  List<Color>? gradientColors;
  List<double>? gradientStops;
  BoxConstraints? constraints;
  LinearGradient? linearGradient;

  @override
  Widget build(BuildContext context) {
    var shouldAbsorb = true;
    if (onTap == null) {
      shouldAbsorb = false;
    }
    return InkWell(
      onTap: onTap,
      // onTap: () {
      //   if (onTap != null) {
      //     onTap!();
      //   }
      // },
      child: Container(
          width: width,
          height: height,
          margin: margin,
          alignment: alignment,
          constraints: constraints,
          decoration: BoxDecoration(
              color: showGradient ? null : color,
              border: Border.all(color: borderColor, width: borderWidth),
              gradient: showGradient
                  ? linearGradient ??
                      LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        tileMode: TileMode.clamp,
                        colors: gradientColors ??
                            [
                              Colors.white,
                              AppColors.primaryColor100.withOpacity(0.16),
                            ],
                        stops: gradientStops ??
                            [
                              0.3,
                              0.3,
                            ],
                      )
                  : null,
              borderRadius: AppCommonWidgets.borderRadius(
                  isAll: allBorderRadius > 0, allRadius: allBorderRadius, topLeft: topLeftRadius, topRight: topRightRadius, bottomLeft: bottomLeftRadius, bottomRight: bottomRightRadius),
              boxShadow: [
                if (showShadow)
                  BoxShadow(offset: shadowOffset ?? Offset(0, 0), blurRadius: shadowBlurRadius, spreadRadius: shadowSpreadRadius, color: shadowColor ?? Colors.grey, blurStyle: BlurStyle.outer)
              ]),
          padding: padding,
          child: child ?? const SizedBox()),
    );
  }
}

import 'dart:io';

import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_dimens.dart';
import 'package:bookfast_customer/utils/app_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBaseScreen extends StatelessWidget {
  AppBaseScreen(
      {Key? key,
      required this.child,
      this.gradientColors,
      this.showGradient = true,
      this.isTopPadding = true,
      this.isBottomPadding = true,
      this.titleText,
      this.showDefaultAppBar = false,
      this.resizeToAvoidBottomInset = true,
      this.appBar,
      this.bottomNavigationBar,
      this.backgroundColor ,
      this.backgroundImage,
      this.padding})
      : super(key: key);

  List<Color>? gradientColors;
  bool showGradient;
  bool showDefaultAppBar;
  bool isTopPadding;
  bool isBottomPadding;
  bool resizeToAvoidBottomInset;
  String? titleText;
  Widget? bottomNavigationBar;
  Widget child;
  Widget? appBar;
  Color? backgroundColor;
  String? backgroundImage;
  EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: Container(
          height: double.infinity,
          padding: padding ??
              EdgeInsets.only(
                  top: isTopPadding ? AppFunctions.getStatusBarPadding(context) : 0,
                  bottom: !isBottomPadding
                      ? 0
                      : Platform.isAndroid
                          ? 0
                          : AppDimensions.dmTen),
          decoration: backgroundImage != null
              ? BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(backgroundImage!),
                    fit: BoxFit.fill,
                  ),
                )
              : BoxDecoration(),
          child: Stack(
            children: [

              Positioned(
                child: Column(
                  children: [
                    if (showDefaultAppBar || titleText != null) _appBar(), // This is default app bar with title only
                    if (appBar != null) appBar!, // This is Custom app bar with title only
                    Expanded(child: child),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }

  _appBar() {
    return CommonAppBar(
      titleText: titleText ?? "",
    );
  }
}

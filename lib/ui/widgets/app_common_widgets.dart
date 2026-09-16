import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_dimens.dart';

class AppCommonWidgets {
  /// Vertical Space
  static Widget vrtSpaceWidget(double space) => SizedBox(
        height: space,
      );

  /// Horizontal Space
  static Widget hrzSpaceWidget(double space) => SizedBox(
        width: space,
      );

  /// Border Radius
  static BorderRadius borderRadius({double allRadius = 0, double topLeft = 0, double topRight = 0, double bottomRight = 0, double bottomLeft = 0, bool isAll = true}) => isAll
      ? BorderRadius.all(Radius.circular(allRadius))
      : BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          topRight: Radius.circular(topRight),
          bottomLeft: Radius.circular(bottomLeft),
          bottomRight: Radius.circular(bottomRight),
        );

  static showAppToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        // backgroundColor: Colors.red,
        // textColor: Colors.white,
        fontSize: 15.0);
  }

  static noDataWidget({String text = "No data available", EdgeInsets? margin}) {
    return Padding(
      padding: margin ?? EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
      child: Center(
        child: AppTextWidget(
          text,
          style: AppTextStyles.subTitleTextStyle(fontWeight: FontWeight.normal, textColor: AppColors.textColor80, fontSize: AppDimensions.dmFourteen),
        ),
      ),
    );
  }
  /// convert html format in string
  static convertHtmlToString(String htmlString) {
    return parse(htmlString).documentElement?.text ?? '';
  }
}

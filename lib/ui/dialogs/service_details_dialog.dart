import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_html_style.dart';
import '../../utils/app_text_styles.dart';
import '../widgets/app_container_widget.dart';

class ServiceDetailsDailog extends StatelessWidget {
  ServiceDetailsDailog({super.key, required this.data, required this.title});

  String data;
  String title;
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppContainer(
            color: AppColors.primaryColor100,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: AppTextWidget(title,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.textStyle(
                          textColor: AppColors.whiteColor, fontWeight: FontWeight.bold, fontSize: AppDimensions.dmSixteen, fontFamily: AppConstants.fontLexendRegular)),
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Html(
                  data: data,
                  style: AppHtmlStyle.htmlAllStyle(),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}

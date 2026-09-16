import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookfast_customer/utils/app_functions.dart';

import 'app_colors.dart';

class AppLoaderDialog {
  static bool isShowingLoader = false;

  static Future<void> showLoadingDialog({String text = " Loading... "}) async {
    if (isShowingLoader) {
      return;
    }
    AppFunctions.openDialog(
        WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
                contentPadding: const EdgeInsets.all(5),
                // key: key,
                backgroundColor: Colors.white,
                elevation: 0,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                children: <Widget>[
                  Wrap(
                    children: [
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  // height: 100,
                                  // width: 100,
                                  padding: const EdgeInsets.all(10),
                                  // color: Colors.white,
                                  child: SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      backgroundColor: AppColors.bfPrimaryColor.withOpacity(0.2),
                                      color: AppColors.bfPrimaryColor,
                                    ),
                                  ),
                                ),
                                if (text.length <= 15) Text(text)
                              ],
                            ),
                            if (text.length > 15)
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  text,
                                  textAlign: TextAlign.center,
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  )
                ])),
        barrierDismissible: false);
    isShowingLoader = true;
  }

  static hideLoadingDialog() {
    print("under hideLoadingDialog --> $isShowingLoader");
    if (isShowingLoader) {
      isShowingLoader = false;
      Get.back();
    }
  }
}

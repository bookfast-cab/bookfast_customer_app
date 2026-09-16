import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/login_model.dart';
import '../services/networking/api_constants.dart';
import '../services/networking/api_handler.dart';
import '../ui/dialogs/common_alert_dialog.dart';
import '../ui/widgets/app_common_widgets.dart';
import '../utils/app_functions.dart';
import '../utils/app_strings.dart';

class ReferralCodeController extends GetxController{
  var loginModel = LoginModel().obs;
  var referralCodeController = TextEditingController().obs;

  Future<void> hitReferralCodeApi({
    required Function() callBack,
  }) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    Map<String, dynamic> map = {
      "referralCode": referralCodeController.value.text.trim(),
    };
    var response = await ApiHandler().post(
      endPoint: ApiConstants.apiCustomerApplyReferralCode,
      data: map,
      addAuthorization: true,
    );
    print("Response: $response");

    loginModel.value = LoginModel.fromJson(response);

    if (loginModel.value.success == true) {
      AppCommonWidgets.showAppToast("Applied referral code success");
      callBack();
    } else {
      AppFunctions.openDialog(CommonAlertDialog(
        description: loginModel.value.message ?? 'Already applied this referral code',
        okCallback: () {},
      ));
    }
  }
}
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../handlers/session_handler/session_manager.dart';
import '../models/login_model.dart';
import '../services/networking/api_constants.dart';
import '../services/networking/api_handler.dart';
import '../ui/dialogs/common_alert_dialog.dart';
import '../ui/screens/auth_screens/enter_referral_code_screen.dart';
import '../ui/widgets/app_common_widgets.dart';
import '../utils/app_functions.dart';
import '../utils/app_strings.dart';

class CreateEmailScreenController extends GetxController{
  var loginModel = LoginModel().obs;
  var userData = UserModelData().obs;
  var emailController = TextEditingController().obs;
  var editProfile = false.obs;

  handleData(LoginModel? userData) async {
    String? userJson = json.encode(userData?.toJson());
    log("SessionManager-----> 3 $userJson");
    await SessionManager.setUserData(userJson);
  }

  hitCustomerUpdateProfile({required Function() callBack}) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    Map<String, dynamic> map = {
      "email": emailController.value.text.trim(),
    };

    var response = await ApiHandler().put(
      endPoint: ApiConstants.apiCustomerUpdateProfile,
      data: map,
      addAuthorization: true,
    );

    loginModel.value = LoginModel.fromJson(response);
    print('--------->$response');
    if (loginModel.value.success == true) {
      if(loginModel.value.data != null) {
        handleData(loginModel.value);
        callBack();
      }
    } else {
      if (loginModel.value.message != null) {
        AppFunctions.openDialog(CommonAlertDialog(
          description: loginModel.value.message!,
          okCallback: (){},
        ));
      }
    }
  }

  hitGetProfile({required Function() callBack}) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    var response = await ApiHandler().get(endPoint: ApiConstants.apiCustomerGetProfile);
    loginModel.value = LoginModel.fromJson(response);
    if (loginModel.value.success == true) {
      print('user data-------->${loginModel.value.data!}');
      if (loginModel.value.data != null) {
        userData.value = loginModel.value.data!;
        emailController.value.text = userData.value.email ?? '';
        SessionManager.setUserData(json.encode(loginModel.value.toJson()));
        callBack();
      }
    } else {
      if (loginModel.value.message != null) {
        AppFunctions.openDialog(
            CommonAlertDialog(description: loginModel.value.message!, okCallback: () {}));
      }
    }
  }
}
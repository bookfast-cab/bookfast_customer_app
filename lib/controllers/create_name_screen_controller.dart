import 'dart:convert';
import 'dart:developer';
import 'package:bookfast_customer/models/login_model.dart';
import 'package:bookfast_customer/ui/screens/auth_screens/create_email_screen.dart';
import 'package:bookfast_customer/ui/screens/auth_screens/create_name_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../handlers/session_handler/session_manager.dart';
import '../services/networking/api_constants.dart';
import '../services/networking/api_handler.dart';
import '../ui/dialogs/common_alert_dialog.dart';
import '../ui/widgets/app_common_widgets.dart';
import '../utils/app_functions.dart';
import '../utils/app_strings.dart';

class CreateNameScreenController extends GetxController {
  var loginModel = LoginModel().obs;
  var userData = UserModelData().obs;
  var firstNameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>();
  var editProfile = false.obs;


  handleData(LoginModel? userData) async {
    String? userJson = json.encode(userData?.toJson());
    log("SessionManager-----> 2 $userJson");
    await SessionManager.setUserData(userJson);
  }

  /// Update Profile api ////////////
  Future<void> hitCustomerUpdateProfileApi({required Function() callBack,}) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    Map<String, dynamic> map = {
      "first_name": firstNameController.value.text.trim(),
      "last_name": lastNameController.value.text.trim(),
      "country_id": 1,
      "currency": 1
    };
    var response = await ApiHandler().put(endPoint: ApiConstants.apiCustomerUpdateProfile,data: map,addAuthorization: true,);
    print("update profile -------> $response");
    loginModel.value = LoginModel.fromJson(response);
    if (loginModel.value.success == true) {
      if(loginModel.value.data != null) {
        handleData(loginModel.value);
        callBack();
      }
    } else {
      if (loginModel.value.message != null) {
        AppFunctions.openDialog(CommonAlertDialog(
          description: loginModel.value.message!,
          okCallback: () {},
          )
        );
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
        firstNameController.value.text = userData.value.firstName ?? '';
        lastNameController.value.text = userData.value.lastName ?? '';
        SessionManager.setUserData(json.encode(loginModel.value.toJson()));
        callBack();
      }
    } else {
      if (loginModel.value.message != null) {
        AppFunctions.openDialog(CommonAlertDialog(description: loginModel.value.message!, okCallback: () {}));
      }
    }
  }
}

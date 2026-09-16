import 'dart:convert';
import 'package:bookfast_customer/controllers/otp_screen_controller.dart';
import 'package:bookfast_customer/handlers/session_handler/session_manager.dart';
import 'package:bookfast_customer/models/login_model.dart';
import 'package:bookfast_customer/services/networking/api_constants.dart';
import 'package:bookfast_customer/services/networking/api_handler.dart';
import 'package:bookfast_customer/ui/screens/auth_screens/otp_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_common_widgets.dart';
import 'package:bookfast_customer/utils/app_functions.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ui/dialogs/common_alert_dialog.dart';

class PhoneNumberScreenController extends GetxController{
 var loginModel = LoginModel().obs;
 var timerValue = 30.obs;
 var phoneNumberController = TextEditingController().obs;


 onRegisterClick() {
   hitRegisterApi(callBack: () {
     print("under SignupDetailsScreen");
      // handleData(loginModel.value);
     final otpController = Get.put(OtpScreenController());
     otpController.token.value = loginModel.value.token ?? "";
     final phoneNumber = phoneNumberController.value.text.trim();
     Get.to(OtpScreen(phoneNumber: phoneNumber,token: otpController.token.value, isNewCustomer : loginModel.value.isNewCustomer??false));
     /*Navigator.pushAndRemoveUntil(
       Get.overlayContext!,
       MaterialPageRoute(builder: (BuildContext context) =>  OtpScreen(phoneNumber: phoneNumber,token: otpController.token.value, isNewCustomer : loginModel.value.isNewCustomer??false)),
           (route) => false,
     );*/
    }
   );
 }

 handleData(LoginModel? userData) {
   /// Setting Data to local storage
   if (userData?.token != null) {
     SessionManager.setAuthToken(userData!.token!);
   }
   SessionManager.setUserData(json.encode(userData!.data?.toJson()));
 }

 hitRegisterApi({required Function() callBack}) async {
   if (!await AppFunctions.hasNetwork()) {
     AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
     return;
   }
   Map<String, dynamic> map = {
     "country_code": '+91',
     "phone_number": phoneNumberController.value.text.trim(),
   };
   var response = await ApiHandler().post(data: map, endPoint: ApiConstants.apiCustomerLogIn,addAuthorization: false);

   loginModel.value = LoginModel.fromJson(response);

   if (loginModel.value.success ?? false) {
     if (loginModel.value.data != null) {
     } else {
       callBack();
     }
   } else {
     if (loginModel.value.message != null) {
       AppFunctions.openDialog(CommonAlertDialog(description: loginModel.value.message!, okCallback: () {}));
       AppCommonWidgets.showAppToast(loginModel.value.message!);
     }
   }
 }
}
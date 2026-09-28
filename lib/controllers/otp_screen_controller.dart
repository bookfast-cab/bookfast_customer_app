import 'dart:async';
import 'dart:convert';
import 'package:bookfast_customer/controllers/phone_number_screen_controler.dart';
import 'package:bookfast_customer/models/login_model.dart';
import 'package:bookfast_customer/ui/screens/home_map_view_screen.dart';
import 'package:bookfast_customer/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../handlers/session_handler/session_manager.dart';
import '../services/networking/api_constants.dart';
import '../services/networking/api_handler.dart';
import '../ui/dialogs/common_alert_dialog.dart';
import '../ui/screens/auth_screens/create_name_screen.dart';
import '../ui/widgets/app_common_widgets.dart';
import '../utils/app_functions.dart';
import '../utils/app_strings.dart';
import 'package:smart_auth/smart_auth.dart';

class OtpScreenController extends GetxController{
  final PhoneNumberScreenController _phoneNumberScreenController = Get.put(PhoneNumberScreenController());
  var timerValue = 30.obs;
  var isResendActive = false.obs;
  var loginModel =  LoginModel().obs;
  var enteredOtp = "".obs;
  var isButtonEnabled = false.obs;
  var token = "".obs;
  var isNewCustomer = false.obs;
  var phoneNumberController = TextEditingController().obs;
  
  var otpController = TextEditingController();
  final SmartAuth _smartAuth = SmartAuth.instance;

  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _listenForSms();
  }

  void _listenForSms() async {
    final res = await _smartAuth.getSmsWithUserConsentApi();
    if (res.hasData && res.data?.code != null) {
      otpController.text = res.data!.code!;
      enteredOtp.value = res.data!.code!;
      isButtonEnabled.value = true;
      // Auto submit OTP
      onVerifyOtpClick();
    }
  }

  void startTimer() {
    isResendActive.value = false;
    timerValue.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1),(timer) {
      if (timerValue.value == 0) {
        isResendActive.value = true;
        _timer.cancel();
      } else {
        timerValue.value--;
        }
      }
    );
  }

  void resendOtp() {
    if (isResendActive.value) {
      startTimer();
      hitReSendOtpApi(callBack: () {});
  }
  }

  @override
  void onClose() {
    _timer.cancel();
    _smartAuth.removeUserConsentApiListener();
    otpController.dispose();
    super.onClose();
  }

  onVerifyOtpClick() {
    print("enteredOtp --> ${enteredOtp.value}");
    if (enteredOtp.value.isEmpty) {
      CommonWidgets.snackBar(AppStrings.strPleaseEnterOtp, isError: true);
      return false;
    } else if (enteredOtp.value.length < 6) {
      CommonWidgets.snackBar(AppStrings.strPleaseEnter6DigitsOtp, isError: true);
      return false;
    } else {
      hitVerifyOtpApi(callBack: (){}
      );
    }
  }

  handleData(LoginModel? userData) async {
    String? userJson = json.encode(userData?.data?.toJson());
    await SessionManager.setUserData(userJson);
    print('SessionManager ----->1 $userJson');
  }

  hitVerifyOtpApi({required Function() callBack}) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    print("Token received in OTP screen ----> $token");
    Map<String, dynamic> map = {
      "phone_number": _phoneNumberScreenController.phoneNumberController.value.text.trim(),
      "otp": enteredOtp.value,
      "token": token.value,
      "fcm_token":await AppFunctions.getDeviceFCMToken()

    };
    var response = await ApiHandler().post(data: map, endPoint: ApiConstants.apiCustomerVerifyOtp, addAuthorization: false,);

    print("Full API Response: $response");

    response['success'] = response['authToken'] != null;
    loginModel.value = LoginModel.fromJson(response);

    if (response['authToken'] != null) {
      SessionManager.setAuthToken(response['authToken']);
    }
    if (loginModel.value.success ?? false) {
      print('API success ----->');

      showSuccessGifDialog(Get.context!);
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(Get.context!).pop();
        if (isNewCustomer.value) {
          Get.to(const CreateNameScreen(editProfile: false,));
        } else {
          Get.offAll(const HomeMapViewScreen());
        }
      });
      handleData(loginModel.value);
      callBack();
    } else {
      print("API Error Message: ${loginModel.value.message}");
      AppFunctions.openDialog(
        CommonAlertDialog(
          description: loginModel.value.message ?? "Invalid OTP / OTP expired",
          okCallback: () {},
        ),
      );
    }
  }

  /// resend otp api /////////////////////

  hitReSendOtpApi({required Function() callBack}) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    Map<String, dynamic> map = {
      "token": token.value,
      "phone_number": _phoneNumberScreenController.phoneNumberController.value.text.trim(),
    };
    var response = await ApiHandler().post(data: map, endPoint: ApiConstants.apiCustomerResendOtp, addAuthorization: false);

    loginModel.value = LoginModel.fromJson(response);

    if (loginModel.value.success ?? false) {
      AppCommonWidgets.showAppToast('Resend OTP Successfully');
      callBack();
    } else {
      if (loginModel.value.message != null) {
        AppCommonWidgets.showAppToast(loginModel.value.message!);
      }
    }
  }

  void showSuccessGifDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(200)),
              child: Image.asset(
                'assets/gifs/ic_verified_custom.gif',
                height: 100,
              ),
            ),
          ),
        );
      },
    );
  }
}
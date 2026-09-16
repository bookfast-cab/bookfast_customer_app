import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../handlers/session_handler/session_constants.dart';
import '../handlers/session_handler/session_manager.dart';
import '../utils/app_constants.dart';
import '../utils/app_functions.dart';

class PaymentController extends GetxController {
  var selectedPaymentMethod = 'RazorPay'.obs;
  var isSelected = false.obs;
  var noteController = TextEditingController();
  Razorpay razorpay = Razorpay();

  void clearData() {
    selectedPaymentMethod.value = '';
  }

  // performPayment({required Function(PaymentSuccessResponse response) handlePaymentSuccessResponse, int? totalPrice,required String orderId,}) async {
  //   String? email = await SessionManager.getString(SessionConstants.email);
  //   String? phoneNumber = await SessionManager.getString(SessionConstants.phoneNumber);
  //   if ((email??"").isEmpty  ||(phoneNumber??"").isEmpty) {
  //     print("User data not found");
  //     return;
  //   }
  //
  //   var userInfo = {'contact': phoneNumber ??"8888888888", 'email': email??"test@gmail.com"};
  //
  //   var options = {
  //     'key': AppConstants.razorPayKey,
  //     'amount': totalPrice,
  //     'order_id': orderId,
  //     'name': 'bookFast',
  //     'description': 'Cab Service',
  //     'retry': {'enabled': true, 'max_count': 1},
  //     'send_sms_hash': true,
  //     'prefill':userInfo ,
  //     'external': {'wallets': ['paytm']}
  //   };
  //
  //   razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
  //   razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
  //     print("response.signature ${response.signature} data ${response.data}");
  //     // if (response.signature != null || response.paymentId != null) {
  //     // handlePaymentErrorResponse(response);
  //     handlePaymentSuccessResponse(response);
  //     // } else {
  //     // handlePaymentSuccessResponse(response);
  //     // }
  //   });
  //   razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  //   razorpay.open(options);
  // }


  Future<void> performPayment({
    required Function(PaymentSuccessResponse response) handlePaymentSuccessResponse,
    required int totalPrice,
    required String orderId,
  }) async {
    try {
      final userModel = await SessionManager.getUserDataModel();
      if (userModel == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      final options = {
        'key': AppConstants.razorPayKey,
        'amount': totalPrice,
        'order_id': orderId,
        'name': 'bookFast',
        'description': 'Cab Service',
        'prefill': {
          'contact': userModel.phoneNumber ?? '8888888888',
          'email': userModel.email ?? 'test@gmail.com',
        },
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'external': {'wallets': ['paytm']}
      };

      print("Opening RazorPay with options: $options");

      // 3. Open payment gateway
      razorpay.open(options);
    } catch (e) {
      print("Payment Error: $e");
      Get.snackbar("Payment Error", "Failed to initiate payment");
    }
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    // showAlertDialog(Get.context!, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    // showAlertDialog(Get.context!, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(Get.context!, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

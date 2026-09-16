import 'package:bookfast_customer/utils/app_constants.dart';
import 'package:bookfast_customer/utils/app_functions.dart';
import 'package:get/get.dart';

class ReferAndFriendScreenController extends GetxController{

  void shareReferCode(String referCode) {
    AppFunctions.shareMyApp("Join this app using my referral code: $referCode. Download the app now! ${AppConstants.urlBookFastAppSore}");
    // const String downloadLink = 'https://yourappdownloadlink.com';
    // final String message = 'Join this app using my referral code: $referCode. Download the app now! $downloadLink';
    // Share.share(message);
  }
}
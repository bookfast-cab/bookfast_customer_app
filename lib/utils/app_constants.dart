import 'dart:io';

class AppConstants {
  static const fontLexendRegular = 'lexend_regular';
  static const fontLexendBold = 'lexend_bold';
  static const fontLexendSemiBold = 'lexend_semi_bold';
  static const fontLexendMedium = 'lexend_medium';

  // Other urls

  // static const keyAndroidGoogleMap = 'AIzaSyA7zh8ogzWlvH3c4eyuPEE42i9PVsI_vio';
  static const keyAndroidGoogleMap = 'AIzaSyByWZryRtT2dQJCMX8yOVtvNrWICobwZzo';
  static const agoraAppId = 'e0bdda965204423b95bde547c6c57de7';

  // book-fast urls
  static String urlBookFastAppSore =Platform.isAndroid? 'https://play.google.com/store/apps/details?id=com.bookfast&hl=en_IN': 'https://apps.apple.com/in/app/bookfast/id1591549503';
  static const razorPayKey = 'rzp_live_ZUiXb4ePjBRqOB';
  static const testRazorPayKey = 'rzp_test_HsBWMMJy9RPwqt';
  static const adminNumber = "+91-8817030000";

  static const statusNewRide = 0;
  static const statusAccepted = 1;
  static const statusStarted = 3;
  static const statusCompleted = 4;
  static const statusCancelled = 5;
  static const statusScheduled = 6;
  static const statusOnTheWay = 7;
  static const statusArrivedToPick = 8;
  static const statusMissed = 9; // If any driver didn't pick the ride
// 6 for outstation advance booking time more than 30 mints
}

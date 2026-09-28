class ApiConstants {

  static String apiBaseUrl = "https://service.bookfast.in/";
  static String imageBaseUrl = "https://service.bookfast.in/customerProfilePic/";
  static String socketBaseUrl = "https://service.bookfast.in/customerSocket";

  // New Staging Server Api's Url
  // static String apiBaseUrl = "https://service-dev.bookfast.in/";
  // static String imageBaseUrl = "https://service-dev.bookfast.in/customerProfilePic/";
  // static String socketBaseUrl = "https://service-dev.bookfast.in/customerSocket";



  // static String apiBaseUrl = "http://192.168.29.153:3300/";
  // static String imageBaseUrl = "http://192.168.29.153:3300/customerProfilePic/";
  // static String socketBaseUrl = "http://192.168.29.153:3300/customerSocket";



  // Google Map keys
  static String mapIosKey = "AIzaSyByWZryRtT2dQJCMX8yOVtvNrWICobwZzo";
  static String mapAndroidKey = "AIzaSyByWZryRtT2dQJCMX8yOVtvNrWICobwZzo";

  // Socket Constants
  static String ioCustomerSocket = "customerSocket";
  static String ioListenUpdatedLocation(String? userId) => "userLocationUpdated_$userId";

  // BookFast Common APIs
  static String apiCustomerLogIn = "${apiBaseUrl}api/customers/login";
  static String apiCustomerVerifyOtp = "${apiBaseUrl}api/customers/verifyOtp";
  static String apiCustomerResendOtp = "${apiBaseUrl}api/customers/resendOtp";
  static String apiCustomerUpdateProfile = "${apiBaseUrl}api/customers/updateProfile";
  static String apiCustomerGetProfile = "${apiBaseUrl}api/customers/profile";
  static String apiCustomerApplyReferralCode = "${apiBaseUrl}api/customers/applyReferralCode";
  static String apiCustomerNotification = "${apiBaseUrl}api/customers/getNotificationsList?page=1&limit=20";
  static String apiCustomerPrivacyPolicy = "${apiBaseUrl}api/customers/privacy-policies";
  static String apiCustomerCheckFare = "${apiBaseUrl}api/customers/checkFare";
  static String apiCustomerConfirmBooking = "${apiBaseUrl}api/customers/confirmBooking";
  static String apiCustomerGetTripCancelReasons = "${apiBaseUrl}api/customers/getTripCancelReasons";
  static String apiCustomerGetTripDetail(String tripId) {return "${apiBaseUrl}api/customers/getTripDetail?tripId=$tripId";}
  static String apiCustomerTripHistory = "${apiBaseUrl}api/customers/getTripHistory";
  static String apiCustomerCancelTrip = "${apiBaseUrl}api/customers/cancelTrip";
  static String apiCustomerLogOut = "${apiBaseUrl}api/customers/logout";
  static String apiCustomerGetDashBoard = "${apiBaseUrl}api/customers/getDashboard";
  static String apiCustomerUploadProfilePicture = "${apiBaseUrl}api/customers/uploadProfilePicture";
  static String apiCustomerGetCouponsList = "${apiBaseUrl}api/customers/getCouponsList";
  static String apiCallToDriver = "${apiBaseUrl}api/customers/callToDriver";
  static String apiLogBannerView ="${apiBaseUrl}api/customers/log-banner-view";

}

import 'dart:async';
import 'package:bookfast_customer/handlers/app_fb_event_controller.dart';
import 'package:bookfast_customer/ui/screens/auth_screens/phone_number_screen.dart';
import 'package:bookfast_customer/ui/screens/home_map_view_screen.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:get/get.dart';
import '../handlers/session_handler/session_manager.dart';

class SplashScreenController extends GetxController{
  static final facebookAppEvents = FacebookAppEvents();

  initFbEvents() async {
    var id = await facebookAppEvents.getAnonymousId();
    print("event id $id");

    facebookAppEvents.logEvent(
      name: 'first_time_app_open',
      parameters: {
        'splash_screen': 'splash_screen_opened',
      },
    );

    facebookAppEvents.logEvent(
      name: 'login',
      parameters: {
        'login': '8684871725',
      },
    );

    facebookAppEvents.setAdvertiserTracking(enabled: true);
    // facebookAppEvents.setUserData(
    //   email: 'opensource@oddbit.id',
    //   firstName: 'Oddbit',
    //   dateOfBirth: '2019-10-19',
    //   city: 'Denpasar',
    //   country: 'Indonesia',
    // );
  }

  Future<void> inIt() async {
    initFbEvents();
    // return;
    String? authToken = await SessionManager.getAuthToken();
    Timer(const Duration(seconds: 3), () async {
      if (authToken != null && authToken.isNotEmpty) {
        Get.offAll(const HomeMapViewScreen());
      } else {
        Get.offAll(const PhoneNumberScreen());
      }
    });
  }
}
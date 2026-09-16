import 'package:get/get.dart';
import 'package:facebook_app_events/facebook_app_events.dart';

class AppFbEventController extends GetxController {
  static final facebookAppEvents = FacebookAppEvents();

  initFbEvents() async {
    var id = await facebookAppEvents.getAnonymousId();
    print("event id $id");
    facebookAppEvents.logEvent(
      name: 'app_opened',
      parameters: {
        'splash_screen': 'splash_screen_opened',
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
}

import 'package:get/get.dart';

import '../models/notification_model.dart';
import '../services/networking/api_constants.dart';
import '../services/networking/api_handler.dart';
import '../ui/widgets/app_common_widgets.dart';
import '../utils/app_functions.dart';
import '../utils/app_strings.dart';

class NotificationScreenController extends GetxController{

  var notificationsList = <dynamic>[].obs;
  hitDriverNotificationApi({required Function() callBack,}) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    var response = await ApiHandler().get(endPoint: ApiConstants.apiCustomerNotification, addAuthorization: true);
    NotificationModel model = NotificationModel.fromJson(response);
    if (model.success == 1) {
      notificationsList.value = model.data ?? [];
    } else {
      AppCommonWidgets.showAppToast("Failed to fetch data");
    }
  }


}
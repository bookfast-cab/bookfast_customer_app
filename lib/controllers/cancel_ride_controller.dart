import 'package:get/get.dart';

import '../models/cancell_ride_model.dart';
import '../services/networking/api_constants.dart';
import '../services/networking/api_handler.dart';
import '../ui/dialogs/common_alert_dialog.dart';
import '../ui/widgets/app_common_widgets.dart';
import '../utils/app_functions.dart';
import '../utils/app_strings.dart';

class CancelRideController extends GetxController {
  var cancelRideModel = <CancelRideData>[].obs;

  var selectedReason = CancelRideData();

  hitTripCancelReasonsApi({
    required Function() callBack,
  }) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    var response = await ApiHandler().get(endPoint: ApiConstants.apiCustomerGetTripCancelReasons, addAuthorization: true);
    CancelRideModel model = CancelRideModel.fromJson(response);
    if ((model.success ?? 0) == 1) {
      if (model.data != null) {
        cancelRideModel.value = model.data!;
      }
      callBack();
    } else {
      AppCommonWidgets.showAppToast("Failed to fetch data");
    }
  }


  Future<void> hitCustomerCancelTripApi({required Function() callBack,required int tripId,}) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    Map<String, dynamic> map = {
      "reason": selectedReason.reason ?? '',
      "reasonId": selectedReason.reasonId.toString(),
      "tripId": tripId,
    };
    var response = await ApiHandler().post(endPoint: ApiConstants.apiCustomerCancelTrip,data: map,addAuthorization: true,);
    print("update profile -------> $response");
    CancelRideModel model = CancelRideModel.fromJson(response);
    if ((model.success ?? 0) == 1) {
      if(model.data != null) {
        callBack();
      }
    } else {
      if (model.message != null) {
        AppFunctions.openDialog(CommonAlertDialog(
          description: model.message!,
          okCallback: () {},
        )
        );
      }
    }
  }
}

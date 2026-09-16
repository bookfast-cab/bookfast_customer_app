import 'package:get/get.dart';
import '../models/cancell_ride_model.dart';
import '../models/trip_detail_model.dart';
import '../services/networking/api_constants.dart';
import '../services/networking/api_handler.dart';
import '../ui/dialogs/common_alert_dialog.dart';
import '../ui/widgets/app_common_widgets.dart';
import '../utils/app_functions.dart';
import '../utils/app_strings.dart';

class DriverFindScreenController extends GetxController {
  var showCancelDialog = false.obs;
  var tripDetail = TripDetailData().obs;
  String ? tripId;
  var selectedReason = CancelRideData().obs;


  hitTripDetailApi({required Function() callBack,required String tripId,}) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    var response = await ApiHandler().get(endPoint: ApiConstants.apiCustomerGetTripDetail(tripId), addAuthorization: true);
    TripDetailModel model = TripDetailModel.fromJson(response);
    if ((model.success ?? 0) == 1) {
      if (model.data != null) {
        tripDetail.value = model.data!;
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
      "reason": selectedReason.value.reason ?? '',
      "reasonId": selectedReason.value.reasonId.toString(),
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

import 'package:bookfast_customer/models/trip_histroy_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/cancell_ride_model.dart';
import '../services/networking/api_constants.dart';
import '../services/networking/api_handler.dart';
import '../ui/dialogs/common_alert_dialog.dart';
import '../ui/widgets/app_common_widgets.dart';
import '../utils/app_functions.dart';
import '../utils/app_strings.dart';

class MyRidesHistoryScreenController extends GetxController {
  ScrollController scrollController = ScrollController();

  var myRides = <TripHistoryListData>[].obs;
  var cancelRideModel = <CancelRideData>[].obs;
  var selectedReason = CancelRideData().obs;
  var  tripId;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var isLoading = false.obs;
  var hasMore = true.obs;
  var totalRecords = 0;
  var selectedStatus = 0.obs;
  var isListenerAdded = false;

  void addScrollListener() {
    if (!isListenerAdded) {
      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          if (hasMore.value && !isLoading.value) {
            hitHasMoreTripHistory(showLoader: false, callBack: () {});
          }
        }
      });
      isListenerAdded = true;
    }
  }

  void removeScrollListener() {
    if (isListenerAdded) {
      scrollController.removeListener(() {});
      isListenerAdded = false;
    }
  }

  @override
  void onClose() {
    removeScrollListener();
    scrollController.dispose();
    super.onClose();
  }

  hitTripHistory({required Function() callBack, bool showLoader = true}) async {
    myRides.clear();
    currentPage.value = 1;

    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    isLoading.value = true;
    String url = "${ApiConstants.apiCustomerTripHistory}?page=${currentPage.value}&limit=20";

    if (selectedStatus.value == 0) {
      url = url + "&type=";
    } else {
      url = url + "&type=${selectedStatus.value}";
    }

    var response = await ApiHandler()
        .get(endPoint: url, showLoader: showLoader, addAuthorization: true);
    TripHistoryModel model = TripHistoryModel.fromJson(response);
    if ((model.success ?? 0) == 1) {
      if (model.data != null) {
        myRides.addAll(model.data ?? []);
        currentPage.value = model.pagination?.page ?? 0;
        totalPages.value = model.pagination?.totalPages ?? 0;
        print('model----- ${model.data}');
        if ((model.data?.length ?? 0) < 20) {
          hasMore.value = false;
        } else {
          hasMore.value = true;
          //  currentPage.value++;
        }
      }
      callBack();
    } else {
      AppCommonWidgets.showAppToast("Failed to fetch data");
    }
    isLoading.value = false;
  }

  hitHasMoreTripHistory({required Function() callBack, bool showLoader = true}) async {

    var requiredPage = currentPage.value + 1;

    if (requiredPage > totalPages.value) {
      return;
    }

    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    isLoading.value = true;
    var response = await ApiHandler()
        .get(endPoint: "${ApiConstants.apiCustomerTripHistory}?page=${requiredPage}&limit=20", showLoader: showLoader, addAuthorization: true);
    TripHistoryModel model = TripHistoryModel.fromJson(response);
    if ((model.success ?? 0) == 1) {
      if (model.data != null) {
        print("Sohan ====>>>> $myRides");
        myRides.addAll(model.data ?? []);
        print("Sohan ====>>>>");
        print("Total Count ${myRides.length}");
        currentPage.value = model.pagination?.page ?? 0;
        if ((model.data?.length ?? 0) < 20) {
          hasMore.value = false;
        } else {
          hasMore.value = true;
          //  currentPage.value++;
        }
      }
      callBack();
    } else {
      AppCommonWidgets.showAppToast("Failed to fetch data");
    }
    isLoading.value = false;
  }

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

  Future<void> hitCustomerCancelTripApi({
    required Function() callBack,
    required int tripId,
  }) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    Map<String, dynamic> map = {
      "reason": selectedReason.value.reason ?? '',
      "reasonId": selectedReason.value.reasonId.toString(),
      "tripId": tripId,
    };
    var response = await ApiHandler().post(
      endPoint: ApiConstants.apiCustomerCancelTrip,
      data: map,
      addAuthorization: true,
    );
    print("update profile -------> $response");
    CancelRideModel model = CancelRideModel.fromJson(response);
    if ((model.success ?? 0) == 1) {
      if (model.data != null) {
        callBack();
      }
    } else {
      if (model.message != null) {
        AppFunctions.openDialog(CommonAlertDialog(
          description: model.message!,
          okCallback: () {},
        ));
      }
    }
  }
}

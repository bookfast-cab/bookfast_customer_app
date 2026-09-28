import 'dart:convert';
import 'package:location/location.dart' as loc;
import 'dart:io';
import 'dart:math';
import 'package:bookfast_customer/controllers/search_drop_location_screen_controller.dart';
import 'package:bookfast_customer/models/booking_ride_model.dart';
import 'package:bookfast_customer/models/coupon_list_model.dart';
import 'package:bookfast_customer/models/dashboard_model.dart';
import 'package:bookfast_customer/services/networking/api_constants.dart';
import 'package:bookfast_customer/ui/screens/current_ride_detail.dart';
import 'package:bookfast_customer/utils/app_functions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../handlers/session_handler/session_manager.dart';
import '../services/networking/api_handler.dart';
import '../ui/dialogs/common_alert_dialog.dart';
import '../ui/dialogs/membership_dialog.dart';
import '../ui/widgets/app_common_widgets.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_images.dart';
import '../utils/app_strings.dart';

class BookingRideScreenController extends GetxController {
  final SearchDropLocationController _controller =
      Get.put(SearchDropLocationController());
  var applyCoupon = TextEditingController().obs;
  var bookingRideModel = BookingRideModel().obs;
  var dashboardData = DashBoardData().obs;
  var appUpdateData = AppUpdate().obs;
  var couponList = <CouponListData>[].obs;
  var appliedCouponCode = ''.obs;
  var isCouponAppliedAndLocked = false.obs;
  var selectedVehicleTypeIndex = 1.obs;
  var selectedTripTypeIndex = 1.obs;
  var selectedDateTime = DateTime.now().obs;
  var isDateTimeSelected = false.obs;
  var isTripDateSelected = false.obs;
  var isBottomSheetOpen = false.obs;
  var paymentMethod = 0.obs;

  GoogleMapController? mapController;
  Rx<Position?> currentPosition = Rx<Position?>(null);
  var currentAddress = ''.obs;

  bool isMapReady = false;
  bool isDriverIconLoaded = false;

  Rx<Marker?> selectedMarker = Rx<Marker?>(null);
  var polyline = Rx<Polyline?>(null);

  RxSet<Marker> driverMarkers = <Marker>{}.obs;
  late BitmapDescriptor driverIcon;

  Future<void> loadDrCustomMarkers() async {
    driverIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      AppImages.icMapCarSmall,
    );
    isDriverIconLoaded = true;
  }

  var tripType = 3.obs;
  var tripMode = 1.obs;
  var roundTripDays = 1.obs;
  var oneWayDate = ''.obs;
  var roundTripDates = <String>[].obs;
  var selectedPaymentModeIndex = 0.obs;

  var showCelebration = false.obs;

  void applyCouponCode(String code) {
    appliedCouponCode.value = code;
    isCouponAppliedAndLocked.value = true;
    showCelebration.value = true;
    Future.delayed(Duration(seconds: 2), () {
      showCelebration.value = false;
    });
  }

  void selectVehicleType(int index) {
    selectedVehicleTypeIndex.value = index;
  }

  final Map<int, Map<String, dynamic>> vehicleDetailsMap = {
    1: {
      "title": "Hatchback",
      "image": AppImages.icHatchback,
      "vehicles": [
        {"name": "Alto", "image": AppImages.imgAlto},
        {"name": "WagonR", "image": AppImages.imgWagonr}, 
        {"name": "Spresso", "image": AppImages.imgSpresso},
        {"name": "Celerio", "image": AppImages.imgCelerio},
      ],
    },
    2: {
      "title": "Sedan",
      "image": AppImages.icSedan,
      "vehicles": [
        {"name": "Swift Dzire", "image": AppImages.imgSwiftDzire},
        {"name": "Aura", "image": AppImages.imgAura},
        {"name": "Honda Amaze", "image": AppImages.imgHondaAmaze},
        {"name": "Xcent", "image": AppImages.imgXcent},
      ],
    },
    3: {
      "title": "SUV",
      "image": AppImages.icSUV,
      "vehicles": [
        {"name": "Ertiga", "image": AppImages.imgErtiga},
        {"name": "Marazzo", "image": AppImages.imgMrazzo},
        {"name": "XL6", "image": AppImages.imgX16},
        {"name": "Rumion", "image": AppImages.imgRumion},
      ],
    },
    4: {
      "title": "SUV Prime",
      "image": AppImages.imgSuvPrime,
      "vehicles": [
        {"name": "Kia Carens", "image": AppImages.imgKiaCarens},
        {"name": "Innova Crysta", "image": AppImages.imgInnovaCrysta},
        {"name": "Innova Hybrid", "image": AppImages.imgInnovaHybrid},
      ],
    },
  };

  void selectTripType(int index) {
    selectedTripTypeIndex.value = index;
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    isMapReady = true;
  }

  late BitmapDescriptor customerIcon;

  // Future<void> loadCustomMarker() async {
  //   customerIcon = await BitmapDescriptor.fromAssetImage(
  //     const ImageConfiguration(size: Size(48, 48)),
  //     AppImages.icUserMarker,
  //   );
  // }

  Rx<Marker?> driverMarker = Rx<Marker?>(null);

  /// fetch current location ///////////////
  Future<void> getCurrentLocation(
      {bool zoomToCurrentLocation = false, Function()? callback}) async {
    print("getCurrentLocation started...");

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled. Prompting native dialog.");
      loc.Location location = loc.Location();
      bool isTurnedOn = await location.requestService();
      if (!isTurnedOn) {
        return Future.error('Location services are disabled.');
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied.");
      return Future.error('Location permissions are permanently denied.');
    }

    await Future.delayed(const Duration(milliseconds: 500));

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("Current Position: ${position.latitude}, ${position.longitude}");

    currentPosition.value = position;

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    currentAddress.value =
        "${place.street}, ${place.name}, ${place.administrativeArea}, ${place.postalCode}";

    print("Current Address: ${currentAddress.value}");

    double zoomLevel = zoomToCurrentLocation ? 18.0 : 14.0;
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: zoomLevel,
        ),
      ),
    );

    if (callback != null) {
      callback();
    }
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   currentPosition.refresh();
    // });
  }

  void updateMarkerPosition(double lat, double lng) async {
    //  BitmapDescriptor customIcon = await getCustomMarker();
    selectedMarker.value = Marker(
      markerId: const MarkerId('selectedLocation'),
      position: LatLng(lat, lng),
      infoWindow: const InfoWindow(title: "Drop Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      // icon: customIcon,
    );
    selectedMarker.refresh();
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16.0),
    );
    await fetchRoute();
    polyline.refresh();
  }

  /// Check route /////////////////////////
  Future<void> fetchRoute() async {
    print("Fetching route...");

    // Check if pick and drop locations are set
    if (_controller.pickLat.value == 0.0 ||
        _controller.pickLng.value == 0.0 ||
        _controller.dropLat.value == 0.0 ||
        _controller.dropLng.value == 0.0) {
      print("Pick or Drop locations are not set properly");
      print("Pick: ${_controller.pickLat.value}, ${_controller.pickLng.value}");
      print("Drop: ${_controller.dropLat.value}, ${_controller.dropLng.value}");
      return;
    }

    final origin = '${_controller.pickLat.value},${_controller.pickLng.value}';
    final destination =
        '${_controller.dropLat.value},${_controller.dropLng.value}';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=${AppConstants.keyAndroidGoogleMap}';

    print("API URL: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("API Status: ${data['status']}");

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final polylinePoints =
              data['routes'][0]['overview_polyline']['points'];
          final decodedPoints = PolylinePoints().decodePolyline(polylinePoints);
          final polylineCoordinates = decodedPoints
              .map((p) => LatLng(p.latitude, p.longitude))
              .toList();

          print("Polyline points decoded: ${polylineCoordinates.length}");

          polyline.value = Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: polylineCoordinates,
          );

          polyline.refresh();
          update();
          _adjustCameraBounds(polylineCoordinates);

          print("Polyline created successfully");
        } else {
          print("No routes found or API error: ${data['status']}");
          print("Error message: ${data['error_message']}");
        }
      } else {
        print("Failed to fetch directions: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching directions: $e");
    }
  }

  // Adjust Camera to Fit Route Bounds
  void _adjustCameraBounds(List<LatLng> polylineCoordinates) {
    if (polylineCoordinates.isEmpty || mapController == null) return;

    double minLat = polylineCoordinates.first.latitude;
    double maxLat = polylineCoordinates.first.latitude;
    double minLng = polylineCoordinates.first.longitude;
    double maxLng = polylineCoordinates.first.longitude;

    for (var point in polylineCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

  late BitmapDescriptor driversIcon;

  Future<void> loadDriverCustomMarkers() async {
    driverIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(18, 18)),
      AppImages.icMapCar,
    );
  }

  LatLng? _lastDriverLatLng;

  bool _hasDriverMovedSignificantly(LatLng newLatLng) {
    if (_lastDriverLatLng == null) return true;

    final distance = Geolocator.distanceBetween(
      _lastDriverLatLng!.latitude,
      _lastDriverLatLng!.longitude,
      newLatLng.latitude,
      newLatLng.longitude,
    );

    return distance > 10;
  }

  void updateDriverMarker(double lat, double lng) {
    final newLatLng = LatLng(lat, lng);

    if (!_hasDriverMovedSignificantly(newLatLng)) {
      print("Driver moved insignificantly, skipping update.");
      return;
    }

    polyline.value = null;
    polyline.refresh();

    driverMarker.value = Marker(
      markerId: const MarkerId('driverLocation'),
      position: LatLng(lat, lng),
      icon: driverIcon,
      infoWindow: const InfoWindow(title: "Driver Location"),
    );

    update();
    driverMarker.refresh();
    if (_controller.pickLat.value != 0.0 && _controller.pickLng.value != 0.0) {
      final bounds = LatLngBounds(
        southwest: LatLng(
          min(lat, _controller.pickLat.value),
          min(lng, _controller.pickLng.value),
        ),
        northeast: LatLng(
          max(lat, _controller.pickLat.value),
          max(lng, _controller.pickLng.value),
        ),
      );
      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    } else {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16.0),
      );
    }
  }

  bool _isRecalculating = false;

  Future<void> hitCheckFareApi({
    required Function() callBack,
    bool showCouponMessage = false,
    String? couponCode,
  }) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast("No Internet Connection");
      return;
    }
    final bool isRoundTrip = !_controller.isOneWayTrip.value;

    final DateTime? pickupDT = _controller.onwardDateTime.value;
    final DateTime? returnDT =
        isRoundTrip ? _controller.returnDateTime.value : null;

    Map<String, dynamic> map = {
      "pickupLat": _controller.pickLat.value,
      "pickupLng": _controller.pickLng.value,
      "dropLat": _controller.dropLat.value,
      "dropLng": _controller.dropLng.value,
      "promo": 0,
      "surge": 1,
      "couponCode": couponCode ?? appliedCouponCode.value,
      "trip_sub_type": _controller.isOneWayTrip.value ? 1 : 2,
      "trip_type": selectedTripTypeIndex.value,
      "vehicle_type": selectedVehicleTypeIndex.value,
      "pickupDate": AppFunctions.convertDate(_controller.onwardDateTime.value),
      "pickupTime":
          AppFunctions.convertHHMMSS(_controller.onwardDateTime.value),
      // "returnPickupDate": AppFunctions.convertDate(_controller.returnDateTime.value),
      // "returnPickupTime": AppFunctions.convertHHMMSS(_controller.returnDateTime.value),
    };
    if (isRoundTrip && returnDT != null) {
      map.addAll({
        "returnPickupDate": AppFunctions.convertDate(returnDT),
        "returnPickupTime": AppFunctions.convertHHMMSS(returnDT),
      });
    }

    var response = await ApiHandler().post(
      data: map,
      endPoint: ApiConstants.apiCustomerCheckFare,
      addAuthorization: true,
    );
    bookingRideModel.value = BookingRideModel.fromJson(response);
    if (bookingRideModel.value.success == 1) {
      if (bookingRideModel.value.data != null) {
        // Only show coupon message if explicitly allowed
        if (showCouponMessage &&
            bookingRideModel.value.data?.couponData?.message != null &&
            bookingRideModel.value.data!.couponData!.message!.isNotEmpty) {
          AppCommonWidgets.showAppToast(
              bookingRideModel.value.data!.couponData!.message!);
        }

        double distance = bookingRideModel.value.data?.km ?? 0.0;

        if (!_isRecalculating) {
          bool needRecalculate = false;

          if (distance < 25 && selectedTripTypeIndex.value != 1) {
            selectedTripTypeIndex.value = 1;
            needRecalculate = true;
          } else if (distance >= 25 && selectedTripTypeIndex.value != 3) {
            selectedTripTypeIndex.value = 3;
            needRecalculate = true;
          }

          if (distance > 120 && selectedVehicleTypeIndex.value == 1) {
            selectedVehicleTypeIndex.value = 2;
            needRecalculate = true;
          }

          if (needRecalculate) {
            _isRecalculating = true;
            await hitCheckFareApi(callBack: callBack);
            _isRecalculating = false;
            return;
          }
        }
        await hitCustomerGetCouponsListApi(callBack: () {});
        callBack();
      }
    } else {
      AppFunctions.openDialog(CommonAlertDialog(
        description: bookingRideModel.value.message ?? '',
        okCallback: () {},
      ));
      AppCommonWidgets.showAppToast(bookingRideModel.value.message ?? '');
    }
  }

  /// Confirm booking ride api ////////////////

  Future<void> hitConfirmBookingApi({
    required Function(String tripId) callBack,
    /*required bool isSchedule,*/
  }) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast("No Internet Connection");
      return;
    }
    final fareData = bookingRideModel.value.data;

    if (fareData == null) {
      AppCommonWidgets.showAppToast("Fare data is not available.");
      return;
    }
    final bool isRoundTrip = !_controller.isOneWayTrip.value;

    final DateTime? pickupDT = _controller.onwardDateTime.value;
    final DateTime? returnDT =
        isRoundTrip ? _controller.returnDateTime.value : null;

    Map<String, dynamic> map = {
      "pickupLat": _controller.pickLat.value,
      "pickupLng": _controller.pickLng.value,
      "dropLat": _controller.dropLat.value,
      "dropLng": _controller.dropLng.value,
      "promo": 0,
      "surge": fareData.surge ?? 1,
      "couponCode": appliedCouponCode.value,
      "trip_sub_type": _controller.isOneWayTrip.value ? 1 : 2,
      "trip_type": selectedTripTypeIndex.value,
      // "vehicle_type": selectedVehicleTypeIndex.value,
      "vehicle_type": (selectedVehicleTypeIndex.value == 1 &&
              fareData.km != null &&
              fareData.km! > 120)
          ? 2
          : selectedVehicleTypeIndex.value,
      "driverAllowance": fareData.driverAllowance ?? 0.0,
      "additional_fare": fareData.additionalFare ?? 0.0,
      "base_fare": fareData.baseFare ?? 0.0,
      "discount": fareData.discount ?? 0.0,
      "fare": fareData.fare ?? 0.0,
      "km": fareData.km ?? 0.0,
      "outstationPackageId": fareData.outstationPackageId ?? 0,
      "price_per_km": fareData.pricePerKm ?? 10,
      "tax": fareData.gst?.amount ?? 0.0,
      "tollTax": fareData.tollTax ?? 0,
      "total_fare": fareData.totalFare ?? 0.0,
      "pickAddress": _controller.pickAddressController.value.text,
      "dropAddress": _controller.dropAddressController.value.text,
      "tripDate": isRoundTrip
          ? AppFunctions.convertDateToYYYYMMDDHHMMSS(DateTime(
              _controller.onwardDateTime.value!.year,
              _controller.onwardDateTime.value!.month,
              _controller.onwardDateTime.value!.day,
              _controller.onwardDateTime.value!.hour,
              _controller.onwardDateTime.value!.minute))
          : AppFunctions.convertDateToYYYYMMDDHHMMSS(isTripDateSelected.value
              ? selectedDateTime.value
              : DateTime.now()),
      "paymentType": paymentMethod.value,
      "pickupDate": AppFunctions.convertDate(_controller.onwardDateTime.value),
      "pickupTime":
          AppFunctions.convertHHMMSS(_controller.onwardDateTime.value),
      if (isRoundTrip) "extra_hour_charges": fareData.extraHourCharges
      // "returnPickupDate": AppFunctions.convertDate(_controller.returnDateTime.value),
      // "returnPickupTime": AppFunctions.convertHHMMSS(_controller.returnDateTime.value),
    };
    if (isRoundTrip && returnDT != null) {
      map.addAll({
        "returnPickupDate": AppFunctions.convertDate(returnDT),
        "returnPickupTime": AppFunctions.convertHHMMSS(returnDT),
        "actualReturnDateTime": AppFunctions.convertDateToYYYYMMDDHHMMSS(
            fareData.actualReturnDateTime),
        if (fareData.extraChargesBreakdown != null)
          "totalTravelingHours":
              fareData.extraChargesBreakdown!.totalTravelingHours,
      });
    }
    // print(
    //     "Final vehicle type: ${(selectedVehicleTypeIndex.value == 1 && fareData.km != null && fareData.km! > 120) ? 2 : selectedVehicleTypeIndex.value}");

    var response = await ApiHandler().post(
      data: map,
      endPoint: ApiConstants.apiCustomerConfirmBooking,
      addAuthorization: true,
    );
    bookingRideModel.value = BookingRideModel.fromJson(response);
    if (bookingRideModel.value.success == 1) {
      if (bookingRideModel.value.data != null) {
        isCouponAppliedAndLocked.value = true;
        callBack(bookingRideModel.value.data!.id.toString());
      }
    } else {
      if (bookingRideModel.value.message != null) {
        AppFunctions.openDialog(CommonAlertDialog(
          description: bookingRideModel.value.message ?? '',
          okCallback: () {
            Get.back();
          },
        ));
        // AppCommonWidgets.showAppToast(bookingRideModel.value.message ?? '');
      }
    }
  }

  Future<void> hitCustomerGetDashBoardApi({
    required Function() callBack,
  }) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }

    final LatLng? pickupLatLng = getEffectivePickupLatLng();

    if (pickupLatLng == null) {
      print("Pickup / Current location not ready");
      return;
    }

    final double latitude = pickupLatLng.latitude;
    final double longitude = pickupLatLng.longitude;

    print("Sending Pickup LatLng => $latitude , $longitude");

    print("Sending LatLng => $latitude , $longitude");

    try {
      final dio = Dio();

      String? token = await SessionManager.getAuthToken();
      final url = ApiConstants.apiCustomerGetDashBoard;
      print("REQUEST URL: $url");
      print("REQUEST BODY: { latitude: $latitude, longitude: $longitude }");

      final response = await dio.request(
        url,
        options: Options(
          method: 'GET',
          headers: {
            "my-deviceos": Platform.isIOS ? "ios" : "android",
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
        data: {
          "latitude": latitude,
          "longitude": longitude,
        },
      );

      print("Dashboard response => ${response.data}");

      DashboardModel model = DashboardModel.fromJson(response.data);

      if (model.success == 1 && model.data != null) {
        dashboardData.value = model.data!;

        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(latitude, longitude),
            ),
          );
        }

        _updateNearbyDriversOnMap(model.data!.nearbyDrivers ?? []);

        ///  Save helpline
        final helpline = model.data?.helplineNumber?.trim();
        if (helpline != null && helpline.isNotEmpty) {
          await SessionManager.setHelplineNumber(helpline);
        }

        /// App update check
        if (model.data?.appUpdate != null) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String currentVersion = packageInfo.version;

          List<int> parseVersion(String v) =>
              v.split('.').map(int.parse).toList();

          List<int> currentV = parseVersion(currentVersion);
          List<int> serverV = parseVersion(model.data!.appUpdate!.versionCode!);

          bool isUpdateAvailable = false;
          for (int i = 0; i < 3; i++) {
            if (serverV[i] > currentV[i]) {
              isUpdateAvailable = true;
              break;
            } else if (serverV[i] < currentV[i]) {
              break;
            }
          }

          if (isUpdateAvailable) {
            _showUpdateDialog(
              currentVersion,
              model.data!.appUpdate!.versionCode!,
            );
          }
        }

        ///  Active trip check
        final activeTrip = model.data?.activeTrip;
        if (activeTrip != null && activeTrip.id != null) {
          Navigator.pushAndRemoveUntil(
            Get.overlayContext!,
            MaterialPageRoute(
              builder: (_) =>
                  CurrentRideDetailScreen(tripId: activeTrip.id.toString()),
            ),
            (route) => false,
          );
        }

        if (model.data?.appUpdate != null) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String currentVersion = packageInfo.version;
          print('current version $currentVersion');

          appUpdateData.value = model.data!.appUpdate!;
          // if (model.data!.appUpdate!.versionCode!.compareTo(currentVersion) > 0) {

          if (AppFunctions().isNewVersionAvailable(
              currentVersion, model.data!.appUpdate!.versionCode ?? "0.0")) {
            _showUpdateDialog(
                currentVersion, model.data!.appUpdate!.versionCode!);
          }
        }

        callBack();
      } else {
        AppCommonWidgets.showAppToast("Failed to fetch dashboard");
      }
    } catch (e) {
      print(" Dashboard API error => $e");
      AppCommonWidgets.showAppToast("Something went wrong");
    }
  }

  /// force update api ////////////////
/*  Future<void> hitCustomerGetDashBoardApi({
    required Function() callBack,
  }) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }



    /// 🚨 BLOCK API if location null
    if (currentPosition.value == null) {
      print("❌ Location not ready, stopping dashboard API");
      return;
    }

    final position = currentPosition.value!;
    final double latitude = position.latitude;
    final double longitude = position.longitude;

    print("✅ Sending LatLng => $latitude , $longitude");

    var response = await ApiHandler().get(endPoint:"${ApiConstants.apiCustomerGetDashBoard}?latitude=$latitude&longitude=$longitude", addAuthorization: true);
    DashboardModel model = DashboardModel.fromJson(response);

    if (model.success == 1) {
      print("model.data--> ${model.data}");
      if (model.data != null) {
        dashboardData.value = model.data!;

        ///Save helpline number
        final helpline = model.data?.helplineNumber?.trim();
        if (helpline != null && helpline.isNotEmpty) {
          await SessionManager.setHelplineNumber(helpline);
          print("Helpline saved: $helpline");
        } else {
          print("Helpline number is null or empty, skipping save.");
        }

        if (model.data?.appUpdate != null) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String currentVersion = packageInfo.version;
          print('current version $currentVersion');

          appUpdateData.value = model.data!.appUpdate!;
          // if (model.data!.appUpdate!.versionCode!.compareTo(currentVersion) > 0) {

            if (AppFunctions(). isNewVersionAvailable(currentVersion, model.data!.appUpdate!.versionCode??"0.0")) {
              _showUpdateDialog(currentVersion, model.data!.appUpdate!.versionCode!);
          }
        }

        /// Active trip check
        final activeTrip = model.data?.activeTrip;
        if (activeTrip != null) {
          final status = activeTrip.status;
          final tripId = activeTrip.id?.toString();
          // if (tripId != null && (status == 1 || status == 3 || status == 7 || status == 8)) {
          print(" print-> under track 5 ");

          Navigator.pushAndRemoveUntil(Get.overlayContext!, MaterialPageRoute(builder: (BuildContext context) => CurrentRideDetailScreen(tripId: tripId!)), (route) => false);
            // Get.offAll(CurrentLocalRideDetailScreen(tripId: tripId));
          // }
        }
        callBack();
      }
    } else {
      AppCommonWidgets.showAppToast("Failed to fetch data");
    }
  }*/

  void checkVersionAfterUpdate(String requiredVersion) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int currentVersionCode = int.parse(packageInfo.buildNumber);
    int requiredVersionCode = int.parse(requiredVersion);
    if (currentVersionCode >= requiredVersionCode) {
      Get.back();
    } else {
      _showUpdateDialog(packageInfo.version, requiredVersion);
    }
  }

  _showUpdateDialog(String currentVersion, String requiredVersion) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: MemberShipDialog(
          title: 'Update Required',
          description:
              'You are using version $currentVersion. Version $requiredVersion is now available. Please update your app to continue.',
          okCallback: () {
            launchUrl(Uri.parse(AppConstants.urlBookFastAppSore));
            checkVersionAfterUpdate(requiredVersion);
          },
          okButtonText: 'Update Now',
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> hitCustomerGetCouponsListApi({
    required Function() callBack,
  }) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }

    var response = await ApiHandler().get(
        endPoint: ApiConstants.apiCustomerGetCouponsList,
        addAuthorization: true);
    CouponListModel model = CouponListModel.fromJson(response);

    if (model.success == true) {
      print("model.data--> ${model.data}");
      if (model.data != null) {
        couponList.value = model.data!;
      }
    } else {
      AppCommonWidgets.showAppToast("Failed to fetch data");
    }
  }

  /// Near by driver  function/////

  LatLng? getEffectivePickupLatLng() {
    final pickLat = _controller.pickLat.value;
    final pickLng = _controller.pickLng.value;

    if (pickLat != 0.0 && pickLng != 0.0) {
      return LatLng(pickLat, pickLng);
    }

    if (currentPosition.value != null) {
      return LatLng(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
      ); // fallback
    }

    return null;
  }

  void _updateNearbyDriversOnMap(List<NearbyDriver> drivers) {
    if (!isMapReady || !isDriverIconLoaded) {
      print("❌ Map or Icon not ready");
      return;
    }

    driverMarkers.clear();

    for (var driver in drivers) {
      if (driver.latitude == null || driver.longitude == null) continue;

      driverMarkers.add(
        Marker(
          markerId: MarkerId('driver_${driver.id}'),
          position: LatLng(driver.latitude!, driver.longitude!),
          icon: driverIcon, // ✅ always valid
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    driverMarkers.refresh();
  }
}

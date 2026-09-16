
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'booking_ride_screen_controller.dart';

class SearchDropLocationController extends GetxController{
  var pickAddressController = TextEditingController().obs;
  var dropAddressController = TextEditingController().obs;
  var selectedLocationData = Prediction().obs;
  final FocusNode googlePlaceFocusNode = FocusNode();
  final FocusNode noteFocusNode = FocusNode();
  var isFromBookingScreen = false.obs;
  RxBool isPickLocationSelected = false.obs;
  RxBool isDropLocationSelected = false.obs;
  RxBool isButtonEnabled = false.obs;
  final FocusNode pickLocationFocusNode = FocusNode();
  final FocusNode dropLocationFocusNode = FocusNode();

  var pickLat = 0.0.obs;
  var pickLng = 0.0.obs;
  var dropLat = 0.0.obs;
  var dropLng = 0.0.obs;

  RxBool isOneWayTrip = true.obs;

  Rx<DateTime?> onwardDateTime = Rx<DateTime?>(null);
  Rx<DateTime?> returnDateTime = Rx<DateTime?>(null);

  void selectOneWay() {
    isOneWayTrip.value = true;
    returnDateTime.value = null;
  }

  void selectRoundTrip() {
    isOneWayTrip.value = false;
  }

  GoogleMapController? mapController;

  void saveMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void moveCameraToCurrentLocation() {
    if (mapController != null && pickLat.value != 0.0 && pickLng.value != 0.0) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(pickLat.value, pickLng.value), 15),
      );
    }
  }

  Future<void> getCurrentLocation(Prediction? prediction,) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Location Error', 'Please enable location services.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission Denied', 'Location permission is required.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Permission Denied', 'Location permissions are permanently denied.');
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
   //   debugPrint("GPS Pick Location ---> lat: ${position.latitude}, lng: ${position.longitude}");

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";


        pickAddressController.value.text = address;
        pickAddressController.refresh();

        pickLat.value = position.latitude;
        pickLng.value = position.longitude;

        // Get.find<BookingRideScreenController>().updateMarkerPosition(
        //   pickLat.value,
        //   pickLng.value,
        // );
        if (prediction != null) {
          onPickLocationSearchClick(prediction);
        }
       // onPickLocationSearchClick(prediction);
       // onDropLocationSearchClick(prediction);
      }
    } catch (e) {
     // Get.snackbar('Error', 'Failed to fetch current location.');
    }
  }




  onPickLocationSearchClick(Prediction prediction) async {
    selectedLocationData.value = prediction;
    if (prediction.description != null) {
      pickAddressController.value.text = prediction.description!;

      List<Location> locations = await locationFromAddress(prediction.description!);
      if (locations.isNotEmpty) {

        pickLat.value = locations.first.latitude;
        pickLng.value = locations.first.longitude;
        Get.find<BookingRideScreenController>().updateMarkerPosition(pickLat.value, pickLng.value);
        // Get.find<BookingRideScreenController>().fetchRoute();
        // Get.find<BookingRideScreenController>().polyline.refresh();

      }
    }
  }


  onDropLocationSearchClick(Prediction prediction) async {
    selectedLocationData.value = prediction;
    if (prediction.description != null) {
      dropAddressController.value.text = prediction.description!;

      List<Location> locations = await locationFromAddress(prediction.description!);
      if (locations.isNotEmpty) {
        dropLat.value = locations.first.latitude;
        dropLng.value = locations.first.longitude;
        Get.find<BookingRideScreenController>().updateMarkerPosition(dropLat.value, dropLng.value);
        isDropLocationSelected.value = true;
      }
    }
  }
}
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:bookfast_customer/models/trip_detail_model.dart';
import 'package:bookfast_customer/ui/screens/banner_manager.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../handlers/app_socket_handler.dart';
import '../services/networking/api_constants.dart';
import '../services/networking/api_handler.dart';
import '../ui/screens/home_map_view_screen.dart';
import '../ui/screens/current_ride_detail.dart';
import '../ui/widgets/app_common_widgets.dart';
import '../utils/app_constants.dart';
import '../utils/app_functions.dart';
import '../utils/app_strings.dart';

class TripDetailController extends GetxController {
  final AppSocketHandler _appSocketHandler = AppSocketHandler();
  LatLng? _lastDriverLatLng;

  var tripDetail = TripDetailData().obs;
  String? tripId;

  var chatController = TextEditingController().obs;
  var enabled = true.obs;

  var polyline = Rx<Polyline?>(null);
  var markers = <MarkerId, Marker>{}.obs;

  var countdownTime = 300.obs;
  var isCountdownActive = false.obs;
  Timer? countdownTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  var isRingtonePlaying = false;

  BitmapDescriptor driverIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor pickupIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;

  Rx<Position?> currentPosition = Rx<Position?>(null);
  GoogleMapController? mapController;

  var driverDuration = '0 m'.obs;
  var hasPlayedAcceptSound = false.obs;


  Timer? _ringtoneTimer;
  bool isTripCancelled = false;


  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  initSocket() async {
    await _appSocketHandler.init(onConnect: () {
      /// listen for driver location update

      _appSocketHandler.socket.on('driverLocationUpdate', (data) async {
         print("Driver current location data: ${jsonEncode(data)}");

           final driverData = data['location'];
           if (driverData != null) {
             final lat = double.tryParse(driverData['latitude'].toString()) ?? 0.0;
             final lng = double.tryParse(driverData['longitude'].toString()) ?? 0.0;

             if (data['duration'] != null) {
               driverDuration.value = data['duration'].toString();
             }
             _lastDriverLatLng = LatLng(lat, lng);

             if (tripDetail.value.status == 3) {
               markers[MarkerId('movingCar')] = Marker(
                 markerId: MarkerId('movingCar'),
                 icon: driverIcon,
                 position: _lastDriverLatLng!,
               );
               markers.refresh();
             }

             else if (tripDetail.value.status == null || tripDetail.value.status! < 3) {
               await setCustomMarkersIcon();

               double pickupLat = double.tryParse(tripDetail.value.pickupLat ?? "") ?? 0.0;
               double pickupLng = double.tryParse(tripDetail.value.pickupLng ?? "") ?? 0.0;

               drawPolylineFromDriverToCustomer(
                 driverLat: lat,
                 driverLng: lng,
                 customerLat: pickupLat,
                 customerLng: pickupLng,
               );
             }


             /// this comment code is harjinder sir side
             //  final newLatLng = LatLng(lat, lng);
             // if (_hasDriverMovedSignificantly(newLatLng)) {
             //   _lastDriverLatLng = newLatLng;
             //
             //   double pickupLat = double.tryParse(tripDetail.value.pickupLat ?? "") ?? 0.0;
             //   double pickupLng = double.tryParse(tripDetail.value.pickupLng ?? "") ?? 0.0;
             //   await setCustomMarkersIcon();
             //   // updateDriverMarker(lat, lng);
             //   drawPolylineFromDriverToCustomer(
             //     driverLat: lat,
             //     driverLng: lng,
             //     customerLat: pickupLat,
             //     customerLng: pickupLng,
             //   );
             //   //  isRideStarted.value = true;
             // } else {
             //   print("Driver moved insignificantly, skipping polyline update.");
             // }

         }
      });

      /// listen for driver ride started
      _appSocketHandler.socket.on("rideAccepted", (data) async {
        print("Full ride acceptance data: ${jsonEncode(data)}");
        //   _appSocketHandler.socket.off('driverLocationUpdate');
        hitTripDetailApi(
          callBack: () {},
          tripId: tripDetail.value.id.toString(),
        );
        // final pickupLat = double.tryParse(tripDetail.value.pickupLat ?? "") ?? 0.0;
        // final pickupLng = double.tryParse(tripDetail.value.pickupLng ?? "") ?? 0.0;
        // final dropLat = double.tryParse(tripDetail.value.dropLat ?? "") ?? 0.0;
        // final dropLng = double.tryParse(tripDetail.value.dropLng ?? "") ?? 0.0;
        //
        // drawPolylineFromPickupToDrop(
        //   pickupLat: pickupLat,
        //   pickupLng: pickupLng,
        //   dropLat: dropLat,
        //   dropLng: dropLng,
        // );

        if (!hasPlayedAcceptSound.value) {
          await _playAcceptRideSound();
          hasPlayedAcceptSound.value = true;
        }

        tripDetail.value.status = 1;
        tripDetail.refresh();
      });


      _appSocketHandler.socket.on('showBanner', (data) async {
          print('socket banner data $data');
          BannerManagerController.showBannerDialog(data);
      });


      /// listen for driver ride cancelled
      _appSocketHandler.socket.on('rideStarted', (data) {
        print("Ride Started data: ${jsonEncode(data)}");
        final pickupLat = double.tryParse(tripDetail.value.pickupLat ?? "") ?? 0.0;
        final pickupLng = double.tryParse(tripDetail.value.pickupLng ?? "") ?? 0.0;
        final dropLat = double.tryParse(tripDetail.value.dropLat ?? "") ?? 0.0;
        final dropLng = double.tryParse(tripDetail.value.dropLng ?? "") ?? 0.0;

        drawPolylineFromPickupToDrop(
          pickupLat: pickupLat,
          pickupLng: pickupLng,
          dropLat: dropLat,
          dropLng: dropLng,
        );
        tripDetail.value.status = 3;
        tripDetail.refresh();
        if (isCountdownActive.value) {
          countdownTimer?.cancel();
          isCountdownActive.value = false;
          stopTickSound();
          print("Countdown stopped because ride has started (status 3).");
        }
      });
      /// listen for driver ride cancelled
      _appSocketHandler.socket.on('tripCancelled', (data) async {
        print("Ride cancelled data: ${jsonEncode(data)}");
        if (!isRingtonePlaying) {
          await _playRingtone();
          _startRingtoneTimer();
        }
        Navigator.pushAndRemoveUntil(
          Get.overlayContext!,
          MaterialPageRoute(
            builder: (context) => HomeMapViewScreen(),
          ),
              (route) => false,
        );

        if (isCountdownActive.value) {
          countdownTimer?.cancel();
          isCountdownActive.value = false;
          stopTickSound();
          print("Countdown stopped because ride has cancelled.");
        }
      });

      /// listen for driver ride completed
      _appSocketHandler.socket.on('rideCompleted', (data) {
        print("Ride Completed data: ${jsonEncode(data)}");
        Navigator.pushAndRemoveUntil(
          Get.overlayContext!,
          MaterialPageRoute(
            builder: (context) => HomeMapViewScreen(),
          ),
              (route) => false,
        );
      });


      /// listen for driver ride completed
      _appSocketHandler.socket.on('noDriver', (data) {
        print("Ride Completed data: ${jsonEncode(data)}");
        Navigator.pushAndRemoveUntil(
          Get.overlayContext!,
          MaterialPageRoute(
            builder: (context) => HomeMapViewScreen(),
          ),
              (route) => false,
        );

      });

      /// listen for driver ride completed
      _appSocketHandler.socket.on('driverOnTheWay', (data) {
        print("Driver on the way data: ${jsonEncode(data)}");
        tripDetail.value.status = 7;
        tripDetail.refresh();
        //  isRideStarted.value = true;
      });

      /// listen for driver ride completed
      _appSocketHandler.socket.on('driverArrived', (data) {
        print("Driver Arrived ${jsonEncode(data)}");
        tripDetail.value.status = 8;
        tripDetail.refresh();
        _startCountdownTimer();
      });
    });
  }

  onDisposeCall() {
    if (_appSocketHandler.isInitialized) {
      _appSocketHandler.socket.off('driverLocationUpdate');
      _appSocketHandler.socket.off('rideStarted');
      _appSocketHandler.socket.off('tripCancelled');
      _appSocketHandler.socket.off('rideCompleted');
      _appSocketHandler.socket.off('driverOnTheWay');
      _appSocketHandler.socket.off('driverArrived');
    }
    stopTickSound();
  }


  Future<void> _playRingtone() async {
    try {
      isRingtonePlaying = true;
      await _audioPlayer.stop();
      await _audioPlayer.play(
        AssetSource('mp3/alert.mp3'),
        volume: 1.0,
      );
      print("Ringtone played");
    } catch (e) {
      print("Failed to play ringtone: $e");
      isRingtonePlaying = false;
    }
  }
  void _startRingtoneTimer() {
    _ringtoneTimer?.cancel();
    _ringtoneTimer = Timer(const Duration(seconds: 8), () async {
      await _audioPlayer.stop();
      isRingtonePlaying = false;
      _ringtoneTimer = null;
    });
  }


  void _startCountdownTimer() {
    countdownTimer?.cancel();
    isCountdownActive.value = true;
    countdownTime.value = 300;

    _playTickSound();

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdownTime.value > 0) {
        countdownTime.value--;

        if (countdownTime.value > 0) {
          _playTickSound();
        }
      } else {
        timer.cancel();
        isCountdownActive.value = false;
      }
    });
  }

  Future<void> _playTickSound() async {
    try {
      await _audioPlayer.play(AssetSource('mp3/waiting_beep.wav'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
  Future<void> _playAcceptRideSound() async {
    try {
      await _audioPlayer.play(AssetSource('mp3/ride_accepted beep.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> stopTickSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  void onClose() {
    countdownTimer?.cancel();
    _audioPlayer.dispose();
    super.onClose();
  }

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

  Future<void> getCurrentLocation({bool zoomToCurrentLocation = false}) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    currentPosition.value = position;

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    double zoomLevel = zoomToCurrentLocation ? 18.0 : 14.0;

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: zoomLevel,
        ),
      ),
    );
  }

  hitTripDetailApi({
    required Function() callBack,
    required String tripId,
  }) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }
    var response = await ApiHandler().get(endPoint: ApiConstants.apiCustomerGetTripDetailWithLatLng(tripId,currentPosition.value?.latitude??0.0,currentPosition.value?.longitude??0.0), addAuthorization: true, showLoader: false);
    TripDetailModel model = TripDetailModel.fromJson(response);
    if ((model.success ?? 0) == 1) {
      if (model.data != null) {
        tripDetail.value = model.data!;
        if (tripDetail.value.status == 1) {
          hasPlayedAcceptSound.value = true;
        }

        await setCustomMarkersIcon();

        double pickupLat = double.tryParse(tripDetail.value.pickupLat ?? "") ?? 0.0;
        double pickupLng = double.tryParse(tripDetail.value.pickupLng ?? "") ?? 0.0;
        double dropLat = double.tryParse(tripDetail.value.dropLat ?? "") ?? 0.0;
        double dropLng = double.tryParse(tripDetail.value.dropLng ?? "") ?? 0.0;

        if (tripDetail.value.status == 3) {
          drawPolylineFromPickupToDrop(
            pickupLat: pickupLat,
            pickupLng: pickupLng,
            dropLat: dropLat,
            dropLng: dropLng,
          );
        } else if (_lastDriverLatLng != null) {
          drawPolylineFromDriverToCustomer(
            driverLat: _lastDriverLatLng!.latitude,
            driverLng: _lastDriverLatLng!.longitude,
            customerLat: pickupLat,
            customerLng: pickupLng,
          );
        }


      }
      callBack();
    } else {
      // AppCommonWidgets.showAppToast("Failed to fetch data");
    }
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> setCustomMarkersIcon() async {
    try {
      final Uint8List markerIcon = await _getBytesFromAsset(AppImages.icMapCar, 80);
      driverIcon = BitmapDescriptor.fromBytes(markerIcon);

      pickupIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      destinationIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      markers.clear();

      if (_lastDriverLatLng != null) {
        markers[MarkerId('driver')] = Marker(
          markerId: MarkerId('driver'),
          icon: driverIcon,
          position: _lastDriverLatLng!,
          rotation: 0,
        );
      }
      if (tripDetail.value.pickupLat != null &&
          tripDetail.value.pickupLng != null &&
          tripDetail.value.status != 3) {
        markers[MarkerId('pickup')] = Marker(
          markerId: MarkerId('pickup'),
          icon: pickupIcon,
          position: LatLng(
            double.parse(tripDetail.value.pickupLat!),
            double.parse(tripDetail.value.pickupLng!),
          ),
        );
      }

      if (tripDetail.value.dropLat != null && tripDetail.value.dropLng != null) {
        markers[MarkerId('destination')] = Marker(
          markerId: MarkerId('destination'),
          icon: destinationIcon,
          position: LatLng(
            double.parse(tripDetail.value.dropLat!),
            double.parse(tripDetail.value.dropLng!),
          ),
        );
      }

      if (tripDetail.value.driverId == null && tripDetail.value.nearbyDrivers != null) {
        for (var driver in tripDetail.value.nearbyDrivers!) {
          if (driver.latitude != null && driver.longitude != null) {
            markers[MarkerId('nearby_driver_${driver.id}')] = Marker(
              markerId: MarkerId('nearby_driver_${driver.id}'),
              icon: driverIcon,
              position: LatLng(driver.latitude!, driver.longitude!),
              rotation: 0,
            );
          }
        }
      }

      markers.refresh();
      update();
    } catch (e) {
      print("Error setting custom markers: $e");
    }
  }

/// old setCustomMarkersIcon code
  /*Future<void> setCustomMarkersIcon() async {
    driverIcon = await BitmapDescriptor.asset(ImageConfiguration(devicePixelRatio: 1), AppImages.icMapCarSmall,);
    // pickupIcon = await BitmapDescriptor.asset(ImageConfiguration(devicePixelRatio: 2.5), "assets/images/newScooterIcon.png");
     destinationIcon = await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

    if (_lastDriverLatLng != null) {
      Marker marker = Marker(
          // rotation: _direction ?? 0.0,
          rotation: 0,
          markerId: MarkerId('driver'),
          icon: driverIcon,
          position: LatLng(_lastDriverLatLng!.latitude, _lastDriverLatLng!.longitude));
      Marker? markerStore;
      Marker? markerDelivery;
      if (tripDetail.value.pickupLat != null && tripDetail.value.pickupLng != null) {
        markerStore =
            Marker(markerId: MarkerId('pickup'), icon: pickupIcon, position: LatLng(double.parse(tripDetail.value.pickupLat!), double.parse(tripDetail.value.pickupLng!)));
        // points.add(LatLng(30.7333, 76.7794)); //chandigarh lat long
      }
      // points.add(LatLng(currentPosition.latitude, currentPosition.longitude));
      // if (deliveryLatitude != null && widget.deliveryLongitude != null) {
      //   print("_direction --->  1 $_direction");
      //   markerDelivery = Marker(markerId: MarkerId('ID_Delivery'), icon: destinationIcon, position: LatLng(widget.deliveryLatitude!, widget.deliveryLongitude!));
      //   // points.add(LatLng(30.7046, 76.7179)); //mohali lat long
      // }

      // mounted returns true only if the widget is in the tree

      markers[MarkerId('driver')] = marker;
      if (markerStore != null) {
        markers[MarkerId('pickup')] = markerStore;
      }
      // if (markerDelivery != null) {
      //   markers[MarkerId('ID_Delivery')] = markerDelivery;
      // }
      drawPolylineFromDriverToCustomer(
          driverLat: _lastDriverLatLng!.latitude,
          driverLng: _lastDriverLatLng!.longitude,
          customerLat: double.parse((tripDetail.value.pickupLat ?? "0.0")),
          customerLng: double.parse((tripDetail.value.pickupLng ?? "0.0")));
      // _getPolyline();
      // setState(() {});}
    }
  }*/

  void drawPolylineFromDriverToCustomer({
    required double driverLat,
    required double driverLng,
    required double customerLat,
    required double customerLng,
  }) async {
    if (driverLat == 0.0 || driverLng == 0.0 || customerLat == 0.0 || customerLng == 0.0) {
      print("Invalid coordinates - Driver: ($driverLat, $driverLng), Customer: ($customerLat, $customerLng)");
      return;
    }
    print("Drawing polyline from driver ($driverLat, $driverLng) to customer ($customerLat, $customerLng)");
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$driverLat,$driverLng&destination=$customerLat,$customerLng&mode=driving&key=${AppConstants.keyAndroidGoogleMap}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print("Directions API status: ${data['status']}");
        if (data['error_message'] != null) {
          print("Error Message: ${data['error_message']}");
        }

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final polylinePoints = data['routes'][0]['overview_polyline']['points'];
          final decodedPoints = PolylinePoints().decodePolyline(polylinePoints);
          final polylineCoordinates = decodedPoints.map((p) => LatLng(p.latitude, p.longitude)).toList();

          polyline.value = Polyline(
            polylineId: const PolylineId('driverToCustomerRoute'),
            color: Colors.blue,
            width: 4,
            points: polylineCoordinates,
          );

          polyline.refresh();
          _adjustCameraBounds(polylineCoordinates);
          print("Polyline drawn successfully.");
        }
      } else {
        print("Failed to fetch directions: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching route: $e");
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
  void drawPolylineFromPickupToDrop({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) async {
    if (pickupLat == 0.0 || pickupLng == 0.0 || dropLat == 0.0 || dropLng == 0.0) {
      print("Invalid coordinates for pickup or drop");
      return;
    }

    print("Drawing polyline from pickup to drop");

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$pickupLat,$pickupLng&destination=$dropLat,$dropLng&mode=driving&key=${AppConstants.keyAndroidGoogleMap}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final polylinePoints = data['routes'][0]['overview_polyline']['points'];
          final decodedPoints = PolylinePoints().decodePolyline(polylinePoints);
          final polylineCoordinates = decodedPoints.map((p) => LatLng(p.latitude, p.longitude)).toList();

          polyline.value = Polyline(
            polylineId: const PolylineId('pickupToDropRoute'),
            color: Colors.blue,
            width: 4,
            points: polylineCoordinates,
          );

          polyline.refresh();

          // Update car position to start at pickup point if no current position
          if (_lastDriverLatLng == null) {
            _lastDriverLatLng = LatLng(pickupLat, pickupLng);
          }

          // Add moving car marker
          markers[MarkerId('movingCar')] = Marker(
            markerId: MarkerId('movingCar'),
            icon: driverIcon,
            position: _lastDriverLatLng!,
          );

          _adjustCameraBounds(polylineCoordinates);
          print("Pickup to Drop Polyline drawn successfully.");
        }
      }
    } catch (e) {
      print("Error drawing pickup to drop polyline: $e");
    }
  }

/// old drawPolylineFromPickupToDrop code
/*  void drawPolylineFromPickupToDrop({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) async {
    if (pickupLat == 0.0 || pickupLng == 0.0 || dropLat == 0.0 || dropLng == 0.0) {
      print("Invalid coordinates for pickup or drop");
      return;
    }

    print("Drawing polyline from pickup to drop");

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$pickupLat,$pickupLng&destination=$dropLat,$dropLng&mode=driving&key=${AppConstants.keyAndroidGoogleMap}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final polylinePoints = data['routes'][0]['overview_polyline']['points'];
          final decodedPoints = PolylinePoints().decodePolyline(polylinePoints);
          final polylineCoordinates = decodedPoints.map((p) => LatLng(p.latitude, p.longitude)).toList();

          polyline.value = Polyline(
            polylineId: const PolylineId('pickupToDropRoute'),
            color: Colors.blue,
            width: 4,
            points: polylineCoordinates,
          );

          polyline.refresh();
          _adjustCameraBounds(polylineCoordinates);
          print("Pickup to Drop Polyline drawn successfully.");
        } else {
          print("No route found in directions response.");
        }
      } else {
        print("Failed to fetch directions: ${response.statusCode}");
      }
    } catch (e) {
      print("Error drawing pickup to drop polyline: $e");
    }
  }*/
}

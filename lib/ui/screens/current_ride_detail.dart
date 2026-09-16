import 'package:bookfast_customer/controllers/trip_detail_screen_detail_controller.dart';
import 'package:bookfast_customer/ui/dialogs/cancel_ride_dialog.dart';
import 'package:bookfast_customer/ui/widgets/app_container_widget.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/utils/app_constants.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:bookfast_customer/utils/app_network_image.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../handlers/session_handler/session_manager.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_functions.dart';
import '../widgets/app_button_widget.dart';
import 'home_map_view_screen.dart';

class CurrentRideDetailScreen extends StatefulWidget {
  const CurrentRideDetailScreen({super.key, required this.tripId});
  final String tripId;
  @override
  CurrentRideDetailScreenState createState() => CurrentRideDetailScreenState();
}

class CurrentRideDetailScreenState extends State<CurrentRideDetailScreen> with WidgetsBindingObserver{
  final TripDetailController _controller = Get.put(TripDetailController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller.getCurrentLocation();
      _controller.hitTripDetailApi(callBack: () {}, tripId: widget.tripId);
      _controller.initSocket();
    });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("Ride Detail Screen resumed");

      _controller.hitTripDetailApi(
        tripId: widget.tripId,
        callBack: () {
          final status = _controller.tripDetail.value.status;
          if (status == 0 || status == 5) {
            Navigator.pushAndRemoveUntil(
              Get.overlayContext!,
              MaterialPageRoute(
                builder: (context) => HomeMapViewScreen(),
              ),
                  (route) => false,
            );
          }
        },
      );
    }
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.onDisposeCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bfPrimaryColor,
      child: SafeArea(
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.bfPrimaryColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Current Ride",
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Obx(() {
                          if (!_controller.isCountdownActive.value) return SizedBox();
                          return Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.timer, color: AppColors.bfPrimaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'Driver waiting: ${_controller.countdownTime.value ~/ 60}:${(_controller.countdownTime.value % 60).toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColor90,
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final position = _controller.currentPosition.value;
                      if (position == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Stack(
                        children: [
                          GoogleMap(
                            onMapCreated: _controller.onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(position.latitude, position.longitude),
                              zoom: 12.0,
                            ),
                            gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
                            markers: Set<Marker>.of(_controller.markers
                                .values),
                            polylines: _controller.polyline.value != null ? {_controller.polyline.value!} : {},
                            zoomControlsEnabled: false,
                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: FloatingActionButton(
                              backgroundColor: AppColors.bfPrimaryColor,
                              child: Image.asset(AppImages.icCustomerService),
                              onPressed: () async {
                                String? helpline = await SessionManager.getHelplineNumber();

                                final numberToCall = helpline?.isNotEmpty == true ? helpline : "8817430000";

                                final Uri callUri = Uri.parse("tel:$numberToCall");
                               // final Uri callUri = Uri.parse("tel:8817430000");

                                if (await canLaunchUrl(callUri)) {
                                  await launchUrl(callUri);
                                } else {
                                  print("Could not launch $callUri");
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ),

                  // Ride Detail part
                  Obx(() {
                    final tripDetail = _controller.tripDetail.value;
                    if (tripDetail.id == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Ride Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        AppTextWidget(
                                          _controller.tripDetail.value.tripType == 1
                                              ? "Local ride"
                                              : _controller.tripDetail.value.tripType == 3
                                                  ? 'Outstation ride'
                                                  : "",
                                          style: AppTextStyles.body2RegularTextStyle(
                                            fontSize: 18,
                                            textColor: AppColors.textColor90,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 4,),
                                        AppTextWidget(
                                          "(${_controller.tripDetail.value.tripSubType == 1 ? "One Way" : "Round Trip"})",
                                          style: AppTextStyles.body2RegularTextStyle(
                                            fontSize: 12,
                                            textColor: AppColors.textColor90,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    AppTextWidget(
                                      _controller.tripDetail.value.driverId == null ? "Driver Not assigned yet" : getStatusText(_controller.tripDetail.value.status ?? ''),
                                      style: AppTextStyles.body2RegularTextStyle(
                                        fontSize: 15,
                                        textColor: AppColors.textColor90,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),

                                /// OTP
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (_controller.tripDetail.value.status == AppConstants.statusAccepted ||
                                        _controller.tripDetail.value.status == AppConstants.statusOnTheWay ||
                                        _controller.tripDetail.value.status == AppConstants.statusArrivedToPick)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: AppColors.textColor40),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text("OTP : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                  for (int i = 0; i < 4; i++)
                                                    Container(
                                                      child: Center(
                                                        child: Text(
                                                          _controller.tripDetail.value.otp?.toString().length == 4 && i < _controller.tripDetail.value.otp!.toString().length
                                                              ? _controller.tripDetail.value.otp!.toString()[i]
                                                              : '',
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (_controller.tripDetail.value.status == AppConstants.statusAccepted || _controller.tripDetail.value.status == AppConstants.statusOnTheWay)
                                      Obx(() => Padding(
                                            padding: const EdgeInsets.only(top: 6.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Driver arriving in ',
                                                  style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                                                ),
                                                Text(
                                                  _controller.driverDuration.value,
                                                  style: TextStyle(fontSize: 14, color: AppColors.textColor90, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )),
                                  ],
                                )
                              ],
                            ),

                            const SizedBox(height: 15),

                            /// Driver info
                            Row(
                              children: [
                                AppContainer(
                                  height: 65,
                                  width: 65,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: _controller.tripDetail.value.driver != null
                                        ? AppNetworkImage(
                                            imageUrl: AppFunctions.getImagePath(
                                              '${_controller.tripDetail.value.driver?.driverProfile}',
                                            ),
                                            height: 90,
                                            width: 90,
                                            radius: 100,
                                          )
                                        : Image.asset(
                                            AppImages.icUser,
                                            height: 90,
                                            width: 90,
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _controller.tripDetail.value.driver?.driverName ?? '',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            _controller.tripDetail.value.vehicleType == 1
                                                ? 'Hatchback'
                                                : _controller.tripDetail.value.vehicleType == 2
                                                    ? 'Sedan'
                                                    : _controller.tripDetail.value.vehicleType == 3
                                                        ? 'SUV'
                                                        : _controller.tripDetail.value.vehicleType == 4
                                                            ? 'SUV Prime'
                                                            : '',
                                            style: TextStyle(fontSize: 16, color: Colors.grey[800], fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Icon(Icons.directions_car_filled),
                                        ],
                                      ),
                                      Text(
                                        _controller.tripDetail.value.driver?.vehicleRcNo ?? '',
                                        style: TextStyle(fontSize: 16, color: Colors.grey[800], fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),

                                if(_controller.tripDetail.value.driver != null)
                                IconButton(
                                  icon: const Icon(Icons.call, color: Colors.green),
                                  onPressed: () {
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (context) => CommonCallDialog(
                                    //     onRegularCall: () {
                                    //       _makePhoneCall(_controller.tripDetail.value.driver?.phoneNumber ?? '');
                                    //     },
                                    //     onFreeCall: () {
                                    //       final callController = Get.put(CustomerCallController());
                                    //       callController.startCall( ); // channel name & user ID
                                    //
                                    //       debugPrint("Free Call Clicked");

                                    //     },
                                    //   ),
                                    // );
                                   _makePhoneCall(_controller.tripDetail.value.driver?.phoneNumber ?? '');
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            /// Pickup location
                            AppContainer(
                                padding: EdgeInsets.all(6),
                                allBorderRadius: 10,
                                borderColor: AppColors.textColor40,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.location_pin, color: Colors.green, size: 20),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            _controller.tripDetail.value.pickupAddress ?? '',
                                            style:  TextStyle(fontSize: 14,color: Colors.black,),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 5),

                                    /// Drop location
                                    Row(
                                      children: [
                                        const Icon(Icons.location_pin, color: Colors.red, size: 20),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            _controller.tripDetail.value.dropAddress ?? '',
                                            style:  TextStyle(fontSize: 14,color: Colors.black,),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            if (_controller.tripDetail.value.tripSubType == 2 &&
                                _controller.tripDetail.value.returnDateTime != null)
                            const SizedBox(height: 10),
                            if (_controller.tripDetail.value.tripSubType == 2 &&
                                _controller.tripDetail.value.returnDateTime != null)
                            Row(
                              children: [
                                 Text(_controller.tripDetail.value.tripSubType == 1 ? "One Way": "Round Trip", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                               // const Text("(Cash Ride)", style: TextStyle(fontSize: 14)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Pick Date & Time: ${AppFunctions.convertDateToYYYYMMDDHHMM(_controller.tripDetail.value.pickupDate)}",
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Return Date & Time: ${AppFunctions.convertDateToYYYYMMDDHHMMAsItIs(_controller.tripDetail.value.returnDateTime)}",
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                const Text("Payment ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const Text("(Cash Ride)", style: TextStyle(fontSize: 14)),
                                Expanded(
                                  child: Text(
                                    "INR: ${_controller.tripDetail.value.total?.toStringAsFixed(2) ?? '0'}",
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// Cancel ride

                            if (_controller.tripDetail.value.driverId == null || (_controller.tripDetail.value.status == AppConstants.statusAccepted ||
                                _controller.tripDetail.value.status == AppConstants.statusOnTheWay ||
                                _controller.tripDetail.value.status == AppConstants.statusArrivedToPick))
                              AppButton(
                                bgColor: Colors.transparent,
                                borderColor: Colors.grey,
                                showBorder: true,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                title: 'Cancel Ride',
                                textColor: Colors.black,
                                onClick: () {
                                  final trip = _controller.tripDetail.value;
                                  if (trip.id != null) {
                                    int tripId = trip.id!;
                                    showCancelRideDialog(tripId);
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String getStatusText(dynamic status) {
    final statusStr = status?.toString() ?? '';

    switch (statusStr) {
      case '1':
        return 'Your ride Accepted';
      case '7':
        return 'Driver is on the way';
      case '8':
        return 'Driver Arrived Your Pick Point';
      case '3':
        return 'Your ride has started';
      default:
        return '';
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      print("Could not launch $callUri");
    }
  }

  void showCancelRideDialog(int tripId) {
    Get.dialog(CancelRideDialog(
        tripId: tripId.toString(),
        onCancelClick: (d) {
          if (_controller.isCountdownActive.value) {
            _controller.countdownTimer?.cancel();
            _controller. isCountdownActive.value = false;
            _controller.stopTickSound();
            print("Countdown stopped because ride has cancelled.");
          }
          Get.offAll(HomeMapViewScreen());
        }));
  }
}

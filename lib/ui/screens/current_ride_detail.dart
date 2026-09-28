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
import 'home_map_view_screen.dart';

class CurrentRideDetailScreen extends StatefulWidget {
  const CurrentRideDetailScreen({super.key, required this.tripId});
  final String tripId;
  @override
  CurrentRideDetailScreenState createState() => CurrentRideDetailScreenState();
}

class CurrentRideDetailScreenState extends State<CurrentRideDetailScreen> with WidgetsBindingObserver {
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
      debugPrint("Ride Detail Screen resumed");
      _controller.hitTripDetailApi(
        tripId: widget.tripId,
        callBack: () {
          final status = _controller.tripDetail.value.status;
          if (status == 0 || status == 5) {
            Navigator.pushAndRemoveUntil(
              Get.overlayContext!,
              MaterialPageRoute(
                builder: (context) => const HomeMapViewScreen(),
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
    return Scaffold(
      backgroundColor: AppColors.bfbackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Header Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back, color: Colors.black87),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "Trip Details",
                        style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Obx(() {
                    if (!_controller.isCountdownActive.value) return const SizedBox();
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer, color: Colors.red.shade700, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '${_controller.countdownTime.value ~/ 60}:${(_controller.countdownTime.value % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            
            // Map Section
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
                        zoom: 14.0,
                      ),
                      gestureRecognizers: {
                        Factory<PanGestureRecognizer>(() => PanGestureRecognizer())
                      },
                      markers: Set<Marker>.of(_controller.markers.values),
                      polylines: _controller.polyline.value != null ? {_controller.polyline.value!} : {},
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                    ),
                    
                    // Support FAB Over Map
                    Positioned(
                      bottom: 24,
                      right: 16,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Image.asset(AppImages.icCustomerService, height: 24, color: AppColors.bfprimarythemeColor2),
                        onPressed: () async {
                          String? helpline = await SessionManager.getHelplineNumber();
                          final numberToCall = helpline?.isNotEmpty == true ? helpline : "8817430000";
                          final Uri callUri = Uri.parse("tel:$numberToCall");
                          if (await canLaunchUrl(callUri)) {
                            await launchUrl(callUri);
                          }
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),

            // Bottom Ride Detail Panel
            Obx(() {
              final tripDetail = _controller.tripDetail.value;
              if (tripDetail.id == null) {
                return Container(
                  height: 200,
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag Handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        // Status & OTP Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.bfprimarythemeColor2.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _getTripTypeLabel(tripDetail.tripType, tripDetail.tripSubType),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.bfprimarythemeColor2,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    tripDetail.driverId == null ? "Searching for a driver..." : getStatusText(tripDetail.status ?? ''),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if ((tripDetail.status == AppConstants.statusAccepted || tripDetail.status == AppConstants.statusOnTheWay) && _controller.driverDuration.value.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        'Arriving in ${_controller.driverDuration.value}',
                                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // OTP Display
                            if (tripDetail.status == AppConstants.statusAccepted ||
                                tripDetail.status == AppConstants.statusOnTheWay ||
                                tripDetail.status == AppConstants.statusArrivedToPick)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  children: [
                                    Text("OTP", style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 2),
                                    Text(
                                      tripDetail.otp?.toString() ?? '----',
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 3),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(height: 1),
                        ),

                        // Driver Info Card
                        if (tripDetail.driver != null)
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey.shade200, width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: AppNetworkImage(
                                    imageUrl: AppFunctions.getImagePath('${tripDetail.driver?.driverProfile}'),
                                    height: 55,
                                    width: 55,
                                    radius: 100,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tripDetail.driver?.driverName ?? '',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          tripDetail.driver?.vehicleRcNo ?? '',
                                          style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
                                        const SizedBox(width: 8),
                                        Text(
                                          _getVehicleTypeName(tripDetail.vehicleType),
                                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => _makePhoneCall(tripDetail.driver?.phoneNumber ?? ''),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.call, color: Colors.green, size: 24),
                                ),
                              ),
                            ],
                          ),

                        if (tripDetail.driver != null)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Divider(height: 1),
                          ),

                        // Location Timeline
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              _buildLocationRow(
                                icon: Icons.circle,
                                color: AppColors.bfprimarythemeColor2,
                                title: "Pickup",
                                address: tripDetail.pickupAddress ?? '',
                                isLast: false,
                              ),
                              _buildLocationRow(
                                icon: Icons.square,
                                color: Colors.red.shade400,
                                title: "Drop-off",
                                address: tripDetail.dropAddress ?? '',
                                isLast: true,
                              ),
                            ],
                          ),
                        ),

                        // Schedule/Return Date Info (If Applicable)
                        if (tripDetail.tripSubType == 2 && tripDetail.returnDateTime != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 20, color: Colors.blue),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Pick: ${AppFunctions.convertDateToYYYYMMDDHHMM(tripDetail.pickupDate)}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 4),
                                      Text("Return: ${AppFunctions.convertDateToYYYYMMDDHHMMAsItIs(tripDetail.returnDateTime)}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Payment Details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.money, color: Colors.grey.shade700, size: 22),
                                const SizedBox(width: 8),
                                const Text("Payment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                                  child: const Text("CASH", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                            Text(
                              "₹${tripDetail.total?.toStringAsFixed(2) ?? '0'}",
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Cancel Ride Button
                        if (tripDetail.driverId == null || 
                           (tripDetail.status == AppConstants.statusAccepted ||
                            tripDetail.status == AppConstants.statusOnTheWay ||
                            tripDetail.status == AppConstants.statusArrivedToPick))
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.red.shade300, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () {
                                if (tripDetail.id != null) {
                                  showCancelRideDialog(tripDetail.id!);
                                }
                              },
                              child: const Text(
                                "Cancel Ride",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // --- UI Helper Methods ---

  Widget _buildLocationRow({required IconData icon, required Color color, required String title, required String address, required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, color: color, size: 14),
            if (!isLast)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                width: 2,
                height: 24,
                color: Colors.grey.shade300,
              )
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(
                address,
                style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isLast) const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  String _getTripTypeLabel(int? tripType, int? tripSubType) {
    String type = tripType == 1 ? "Local" : tripType == 3 ? "Outstation" : "Ride";
    String subType = tripSubType == 1 ? "One Way" : tripSubType == 2 ? "Round Trip" : "";
    return "$type ${subType.isNotEmpty ? '• $subType' : ''}".trim();
  }

  String _getVehicleTypeName(int? type) {
    switch (type) {
      case 1: return 'Hatchback';
      case 2: return 'Sedan';
      case 3: return 'SUV';
      case 4: return 'SUV Prime';
      default: return 'Car';
    }
  }

  String getStatusText(dynamic status) {
    final statusStr = status?.toString() ?? '';
    switch (statusStr) {
      case '1': return 'Driver Accepted Ride';
      case '7': return 'Driver is on the way';
      case '8': return 'Driver has arrived';
      case '3': return 'Ride in progress';
      default: return 'Processing...';
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      debugPrint("Could not launch $callUri");
    }
  }

  void showCancelRideDialog(int tripId) {
    Get.dialog(CancelRideDialog(
      tripId: tripId.toString(),
      onCancelClick: (d) {
        if (_controller.isCountdownActive.value) {
          _controller.countdownTimer?.cancel();
          _controller.isCountdownActive.value = false;
          _controller.stopTickSound();
          debugPrint("Countdown stopped because ride has cancelled.");
        }
        Get.offAll(() => const HomeMapViewScreen());
      },
    ));
  }
}
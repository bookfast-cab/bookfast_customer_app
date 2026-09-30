import 'package:bookfast_customer/controllers/trip_detail_screen_detail_controller.dart';
import 'package:bookfast_customer/ui/dialogs/cancel_ride_dialog.dart';
import 'package:bookfast_customer/utils/app_constants.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:bookfast_customer/utils/app_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../handlers/session_handler/session_manager.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_functions.dart';
import 'package:bookfast_customer/ui/screens/app_drawer.dart';
import 'package:share_plus/share_plus.dart';
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
      drawer: const AppDrawer(),
      backgroundColor: Colors.white, // Match map background loosely
      appBar: AppBar(
        backgroundColor: AppColors.bfprimarythemeColor2,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Obx(() {
          final tripDetail = _controller.tripDetail.value;
          return Text(
            tripDetail.driverId == null ? "Searching for a driver..." : getStatusText(tripDetail.status ?? ''),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          );
        }),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_in_talk, color: Colors.white),
            onPressed: () async {
              String? helpline = await SessionManager.getHelplineNumber();
              final numberToCall = helpline?.isNotEmpty == true ? helpline : "8817430000";
              final Uri callUri = Uri.parse("tel:$numberToCall");
              if (await canLaunchUrl(callUri)) {
                await launchUrl(callUri);
              }
            },
          )
        ],
      ),
      body: Obx(() {
        final position = _controller.currentPosition.value;
        final tripDetail = _controller.tripDetail.value;

        if (position == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // ── Map Layer ──
            Positioned.fill(
              child: GoogleMap(
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
            ),

            // ── Blue Header Extension (Makes AppBar look taller) ──
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 35,
                color: AppColors.bfprimarythemeColor2,
              ),
            ),

            // ── Top Driver Card (Only if driver exists) ──
            if (tripDetail.driver != null)
              Positioned(
                top: 5, // Moved UP to overlap the blue extension
                left: 0,
                right: 0,
                child: _buildTopDriverCard(tripDetail),
              ),

            // ── Bottom Panel ──
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: SafeArea(
                child: _buildBottomStatsCard(tripDetail),
              ),
            ),
          ],
        );
      }),
    );
  }

  // --- UI Components ---

  Widget _buildTopDriverCard(dynamic tripDetail) {
    return Container(
      // Margin removed to allow it to float higher up
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Driver Image
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
          const SizedBox(width: 12),
          
          // Driver Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tripDetail.driver?.driverName ?? 'Driver',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                // const SizedBox(height: 2),
                // Row(
                //   children: [
                //     const Icon(Icons.star, color: Colors.amber, size: 14),
                //     const SizedBox(width: 4),
                //     Text("4.8", style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                //   ],
                // ),
                const SizedBox(height: 4),
                Text(
                  "${_getVehicleTypeName(tripDetail.vehicleType)} • ${tripDetail.driver?.vehicleRcNo ?? ''}",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          
          // Action Buttons
            _buildCircularActionButton(Icons.call, AppColors.bfprimarythemeColor2, () => _makePhoneCall(tripDetail.driver?.phoneNumber ?? '')),
          // Row(
          //   children: [
          //     // const SizedBox(width: 12),
          //     // _buildCircularActionButton(Icons.message, AppColors.bfprimarythemeColor2, () { /* chat action */ }),
          //   ],
          // )
        ],
      ),
    );
  }

  Widget _buildCircularActionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildBottomStatsCard(dynamic tripDetail) {
    if (tripDetail.id == null || tripDetail.driver == null) {
       // Loading or searching state
       return Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(24),
           boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))
           ],
         ),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             const CircularProgressIndicator(),
             const SizedBox(height: 16),
             Text(tripDetail.id == null ? "Loading trip details..." : "Searching for a driver...", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
             const SizedBox(height: 16),
             if (tripDetail.id != null)
               OutlinedButton(
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
                  child: const Text("Cancel Ride", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
           ],
         )
       );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn("${_controller.driverDuration.value.isEmpty ? '3' : _controller.driverDuration.value.split(' ').first} min", "away"),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                _buildStatColumn("${tripDetail.distance ?? '2.4'} km", "distance"),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                _buildStatColumn("₹${tripDetail.total?.toStringAsFixed(0) ?? '0'}", "total fare"),
              ],
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          
          // Share Live Location
          InkWell(
            onTap: () {
              final position = _controller.currentPosition.value;
              if (position != null) {
                final message = "Track my live location: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
                Share.share(message, subject: "My Live Location");
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share, color: AppColors.bfprimarythemeColor2, size: 20),
                  SizedBox(width: 8),
                  Text("Share Live Location", style: TextStyle(color: AppColors.bfprimarythemeColor2, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          // Secondary Details (OTP & Cancel)
          if (tripDetail.status == AppConstants.statusAccepted ||
              tripDetail.status == AppConstants.statusOnTheWay ||
              tripDetail.status == AppConstants.statusArrivedToPick) ...[
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("OTP", style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                      Text(tripDetail.otp?.toString() ?? '----', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    ],
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red.shade300, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      if (tripDetail.id != null) {
                        showCancelRideDialog(tripDetail.id!);
                      }
                    },
                    child: const Text("Cancel Ride", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            )
          ],

          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Location Timeline
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
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
          ),

          ],
      ),
    );
  }

  Widget _buildStatColumn(String title, String subtitle) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87)),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // --- Helpers ---

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
      case '1': return 'Driver Accepted';
      case '7': return 'On the way';
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

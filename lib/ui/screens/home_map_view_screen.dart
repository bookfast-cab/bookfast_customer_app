import 'package:bookfast_customer/controllers/booking_ride_screen_controller.dart';
import 'package:bookfast_customer/controllers/my_rides_screen_controller.dart';
import 'package:bookfast_customer/controllers/search_drop_location_screen_controller.dart';
import 'package:bookfast_customer/ui/dialogs/cancel_ride_dialog.dart';
import 'package:bookfast_customer/ui/screens/app_drawer.dart';
import 'package:bookfast_customer/ui/screens/banner_manager.dart';
import 'package:bookfast_customer/ui/screens/search_drop_location_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_common_widgets.dart';
import 'package:bookfast_customer/utils/app_functions.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../handlers/session_handler/session_manager.dart';
import '../../models/booking_ride_model.dart';
import '../dialogs/booking_successfull_dialog.dart';
import '../dialogs/comman_searching_dialog.dart';
import '../dialogs/common_alert_dialog.dart';
import '../dialogs/payment_dialog.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import 'current_ride_detail.dart';

class HomeMapViewScreen extends StatefulWidget {
  const HomeMapViewScreen({
    super.key,
  });
  @override
  HomeMapViewScreenState createState() => HomeMapViewScreenState();
}

class HomeMapViewScreenState extends State<HomeMapViewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final BookingRideScreenController _controller = Get.put(BookingRideScreenController());
  final SearchDropLocationController _searchDropLocationController = Get.put(SearchDropLocationController());
  final MyRidesHistoryScreenController _myRidesHistoryScreenController = Get.put(MyRidesHistoryScreenController());
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _controller.loadDrCustomMarkers();
      _controller.getCurrentLocation(callback: () {
        _controller.hitCustomerGetDashBoardApi(callBack: () {});
      });
      if (_searchDropLocationController.pickAddressController.value.text.isEmpty) {
        _searchDropLocationController.getCurrentLocation(null);
      }
      final bannerController = Get.put(BannerManagerController());
      bannerController.initSocket();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark, // Black status bar icons
      child: Container(
        color: Colors.white,
        child: SafeArea(
          left: true,
          top: true,
          right: true,
          bottom: true,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            drawer: const AppDrawer(),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: GestureDetector(
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                child: const Icon(Icons.menu, color: Colors.black, size: 28),
              ),
              centerTitle: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppImages.icBookFastLogo1, height: 35),
                ],
              ),
              actions: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.notifications_none, color: Colors.black, size: 28),
                    Positioned(
                      right: 0,
                      top: 12,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
              ],
            ),
            body: Column(
              children: [
                // ── Promo Banner ──
                _topPromoBanner(),
                // ── Location Card ──
                _locationCard(),
                // ── Map (Flexible, fills middle) ──
                Expanded(
                  child: Stack(
                    children: [
                      // Google Map
                      Obx(() {
                        final position = _controller.currentPosition.value;
                        if (position == null) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return GoogleMap(
                          onMapCreated: _controller.onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(position.latitude, position.longitude),
                            zoom: 12.0,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('currentLocation'),
                              position: LatLng(position.latitude, position.longitude),
                            ),
                            if (_searchDropLocationController.pickLat.value != 0.0 &&
                                _searchDropLocationController.pickLng.value != 0.0)
                              Marker(
                                markerId: const MarkerId('pickLocation'),
                                position: LatLng(
                                  _searchDropLocationController.pickLat.value,
                                  _searchDropLocationController.pickLng.value,
                                ),
                                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                              ),
                            if (_controller.selectedMarker.value != null) _controller.selectedMarker.value!,
                            ..._controller.driverMarkers,
                          },
                          polylines: _controller.polyline.value != null ? {_controller.polyline.value!} : {},
                          zoomControlsEnabled: false,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          mapToolbarEnabled: false,
                        );
                      }),
                      
                      // ── Support Floating Action Button (From Old UI logic) ──
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Obx(() {
                          bool showFloatingButton = _myRidesHistoryScreenController.myRides
                              .any((ride) => (ride.status ?? 0) == 0);
                          if (!showFloatingButton) return const SizedBox();
                          return FloatingActionButton(
                            backgroundColor: AppColors.bfPrimaryColor,
                            onPressed: () async {
                              String? helpline = await SessionManager.getHelplineNumber();
                              final numberToCall = helpline?.isNotEmpty == true ? helpline : "8817430000";
                              final Uri callUri = Uri.parse("tel:$numberToCall");
                              if (await canLaunchUrl(callUri)) {
                                await launchUrl(callUri);
                              } else {
                                print("Could not launch $callUri");
                              }
                            },
                            child: Image.asset(AppImages.icCustomerService, width: 30, height: 30),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                // ── Bottom Panel ──
                _buildBottomPanel(),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _topPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      height: 110,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.blue.shade600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("FLAT",
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "20% OFF ",
                          style: TextStyle(color: Colors.yellow, fontSize: 26, fontWeight: FontWeight.bold, height: 1.1),
                        ),
                      ],
                    ),
                  ),
                  const Text("on your first 3 rides!",
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text("BOOKFAST20",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Image.asset(AppImages.icSedan, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }

  // Location card shown above the map
  // Location card shown above the map
  // Location card shown above the map
  Widget _locationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Dot-line-pin column
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 28,
                width: 1.5,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              const Icon(Icons.location_on, color: Colors.red, size: 18),
            ],
          ),
          const SizedBox(width: 14),
          // Text column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── PICKUP LOCATION CLICK AREA ───
                InkWell(
                  onTap: () {
                    _searchDropLocationController.isFromBookingScreen.value = true;
                    Get.to(() => const SearchDropLocationScreen())?.then((value) {
                      if (_searchDropLocationController.pickLat.value != 0.0 &&
                          _searchDropLocationController.pickLng.value != 0.0) {
                        _controller.hitCustomerGetDashBoardApi(callBack: () {});
                      }
                      if (_searchDropLocationController.dropAddressController.value.text.isNotEmpty) {
                        Future.delayed(const Duration(seconds: 1), () {
                          _controller.hitCheckFareApi(callBack: () {
                            openFareBottomSheet(Get.context!);
                          });
                        });
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent, 
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("PICKUP LOCATION",
                            style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        const SizedBox(height: 3),
                        // FIXED: Listen to text changes properly
                        Obx(() {
                          return ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _searchDropLocationController.pickAddressController.value,
                            builder: (context, value, child) {
                              String pickText = value.text;
                              if (pickText.isEmpty) pickText = "Fetching location...";
                              return Text(
                                pickText,
                                style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                
                const Divider(height: 12),
                
                // ─── DROP LOCATION CLICK AREA ───
                InkWell(
                  onTap: () {
                    _searchDropLocationController.isFromBookingScreen.value = false;
                    Get.to(() => const SearchDropLocationScreen())?.then((_) {
                      Future.delayed(const Duration(seconds: 1), () {
                        if (_searchDropLocationController.pickLat.value != 0.0 &&
                            _searchDropLocationController.pickLng.value != 0.0) {
                          _controller.hitCustomerGetDashBoardApi(callBack: () {});
                        }
                        if (_searchDropLocationController.dropAddressController.value.text.isNotEmpty) {
                          _controller.polyline.refresh();
                          _controller.hitCheckFareApi(callBack: () {
                            openFareBottomSheet(Get.context!);
                          });
                        }
                      });
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent, 
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("WHERE TO?",
                            style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        const SizedBox(height: 3),
                        // FIXED: Listen to text changes properly
                        Obx(() {
                          return ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _searchDropLocationController.dropAddressController.value,
                            builder: (context, value, child) {
                              String dropText = value.text;
                              if (dropText.isEmpty) dropText = "Enter drop location";
                              return Text(
                                dropText,
                                style: TextStyle(
                                  color: dropText == "Enter drop location" ? Colors.black45 : Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Target icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.my_location, color: Colors.black54, size: 18),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip types
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _tripOption(1, "Daily", "For local travel", AppImages.icDaily),
              _tripOption(2, "Rental", "By the hour/day", AppImages.icRental),
              _tripOption(3, "Outstation", "Intercity travel", AppImages.icOutStation),
            ],
          ),
          const SizedBox(height: 16),
          // Choose your ride header
          const Text("Choose your ride",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),
          // Vehicle list
          Obx(() {
            double distance = _controller.bookingRideModel.value.data?.km ?? 0.0;
            return SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (distance < 120)
                    _vehicleOption(AppStrings.strHatchback, 1, Image.asset(AppImages.icHatchback, height: 38), "4 Seats"),
                  if (distance < 120) const SizedBox(width: 10),
                  _vehicleOption(AppStrings.strSedan, 2, Image.asset(AppImages.icSedan, height: 38), "4 Seats"),
                  const SizedBox(width: 10),
                  _vehicleOption(AppStrings.strSUV, 3, Image.asset(AppImages.imgkia, height: 38), "6 Seats"),
                  const SizedBox(width: 10),
                  _vehicleOption(AppStrings.strSUVPrime, 4, Image.asset(AppImages.imginnova, height: 38), "6 Seats"),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _tripOption(int index, String title, String subtitle, String iconImage) {
    return Obx(() {
      bool isSelected = _controller.selectedTripTypeIndex.value == index;
      return GestureDetector(
        onTap: () {
          if (index == 2) {
            Get.dialog(
              AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: const Text("Coming Soon", style: TextStyle(fontWeight: FontWeight.bold)),
                content: const Text("BookFast Rental service will start soon!"),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("OK", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          } else {
            _controller.selectTripType(index);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconImage, height: 80, fit: BoxFit.contain),
            const SizedBox(height: 6),
            Text(title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue.shade700 : Colors.black87,
                )),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      );
    });
  }

  Widget _vehicleOption(String title, int index, Image image, String seats) {
    return Obx(() {
      bool isSelected = _controller.selectedVehicleTypeIndex.value == index;
      return GestureDetector(
        onTap: () {
          _controller.selectVehicleType(index);
          // Old UI behavior logic when selecting vehicle type
          if (_searchDropLocationController.dropAddressController.value.text.isNotEmpty) {
            _controller.hitCheckFareApi(callBack: () {
              if (Get.isBottomSheetOpen ?? false) {
                Get.back();
              }
              Future.delayed(const Duration(milliseconds: 300), () {
                openFareBottomSheet(Get.context!);
              });
            });
          }
        },
        child: Container(
          width: 110,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blue.shade700 : Colors.black87,
                  )),
              const SizedBox(height: 8),
              image,
              const SizedBox(height: 6),
              Text(seats, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
      );
    });
  }

  // ------ MODERN FARE BOTTOM SHEET (1st UI layout + 2nd UI Confetti and Confirm Logic) ------

  void openFareBottomSheet(BuildContext context) {
    final ConfettiController controllerCenter = ConfettiController(duration: const Duration(seconds: 2));
    BookingRideData? initialRideData = _controller.bookingRideModel.value.data;
    _controller.isDateTimeSelected.value = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Obx(() {
          final rideData = initialRideData;
          return Container(
            height: MediaQuery.of(context).size.height * 0.85, 
            decoration: const BoxDecoration(
              color: Color(0xFFF7F8FA), 
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    // Header (Drag handle + Title)
                    Container(
                      padding: const EdgeInsets.only(top: 12, bottom: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Review Journey",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    
                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main Fare Breakdown Card
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4)
                                  )
                                ]
                              ),
                              child: Column(
                                children: [
                                  if (rideData != null)
                                    _modernFareRow("Total Distance", "${(rideData.km ?? 0.0).toStringAsFixed(2)} km", Icons.route, iconColor: Colors.blue),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                                  ),
                                  if (rideData != null)
                                    _modernFareRow("Base Fare", "₹${rideData.baseFare ?? '0'}", Icons.monetization_on_outlined),
                                  if (rideData != null && (rideData.driverAllowance ?? 0) > 0)
                                    _modernFareRow("Driver Allowance", "₹${rideData.driverAllowance}", Icons.person_outline),
                                  if (rideData != null)
                                    _modernFareRow("Price per km", "₹${(rideData.pricePerKm ?? 0.0).toStringAsFixed(2)}", Icons.speed),
                                  if (rideData != null && (rideData.tollTax ?? 0.0) > 0)
                                    _modernFareRow("Toll Tax", "₹${rideData.tollTax}", Icons.add_road),
                                  if (rideData != null && (rideData.gst?.amount ?? 0.0) > 0)
                                    _modernFareRow(rideData.gst?.title ?? "Tax", "₹${rideData.gst?.amount}", Icons.receipt_long),
                                  if (rideData != null && (rideData.discount ?? 0.0) > 0)
                                    _modernFareRow("Coupon Discount", "-₹${rideData.discount}", Icons.local_offer, valueColor: Colors.green, iconColor: Colors.green),
                                  
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12.0),
                                    child: DottedBorderLine(),
                                  ),
                                  if (rideData != null)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Total Payable", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        Text("₹${(rideData.totalFare ?? 0.0).toStringAsFixed(2)}", 
                                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.bfprimarythemeColor2)),
                                      ],
                                    )
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Date Time Schedule (if active)
                            if (_controller.isDateTimeSelected.value)
                              InkWell(
                                onTap: () {
                                  _selectDateTime(context, (selected) {
                                    _controller.selectedDateTime.value = selected;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.bfprimarythemeColor2.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.bfprimarythemeColor2.withOpacity(0.3))
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_month, color: AppColors.bfprimarythemeColor2, size: 24),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Scheduled Departure", style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          Text(
                                            AppFunctions.convertDateToYYYYMMDDHHMM2(_controller.selectedDateTime.value),
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.edit, size: 18, color: Colors.black54)
                                    ],
                                  ),
                                ),
                              ),

                            _vehicleDetailSection(_controller.selectedVehicleTypeIndex.value),
                            const SizedBox(height: 16),

                            // Coupons Section
                            if (_controller.couponList.isNotEmpty) ...[
                              const Text("Available Offers", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: _controller.couponList.map((coupon) {
                                    final isApplied = _controller.appliedCouponCode.value == coupon.code;
                                    return Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isApplied ? AppColors.bfprimarythemeColor2.withOpacity(0.05) : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isApplied ? AppColors.bfprimarythemeColor2 : Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: isApplied ? AppColors.bfprimarythemeColor2 : Colors.grey.shade100,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.local_offer, size: 16, color: isApplied ? Colors.white : Colors.grey.shade600),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${coupon.discountValue ?? ''}${coupon.discountType == 'percentage' ? '% Off' : ' Flat Off'}',
                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                              ),
                                              Text(coupon.code ?? '', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                            ],
                                          ),
                                          const SizedBox(width: 20),
                                          GestureDetector(
                                            onTap: () async {
                                              final alreadyApplied = coupon.alreadyApplied == true;
                                              final isLocked = _controller.isCouponAppliedAndLocked.value;
                                              final isSameCode = (_controller.appliedCouponCode.value) == (coupon.code ?? '');
                                              
                                              if (alreadyApplied || isLocked || isSameCode) return;

                                              await _controller.hitCheckFareApi(
                                                couponCode: coupon.code,
                                                showCouponMessage: true,
                                                callBack: () {
                                                  final bookingData = _controller.bookingRideModel.value.data;
                                                  if (bookingData?.couponData == null || bookingData?.couponData?.isCouponApplicable == false) {
                                                    return;
                                                  }
                                                  _controller.appliedCouponCode.value = coupon.code ?? '';
                                                  controllerCenter.play();
                                                  Get.back();
                                                  openFareBottomSheet(Get.context!);
                                                },
                                              );
                                            },
                                            child: Text(
                                              isApplied ? 'APPLIED' : 'APPLY',
                                              style: TextStyle(
                                                color: (coupon.alreadyApplied == true || _controller.isCouponAppliedAndLocked.value)
                                                    ? Colors.grey
                                                    : AppColors.bfprimarythemeColor2, 
                                                fontSize: 13, 
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Payment Method Row
                            const Text("Payment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => CommonPaymentDialogWidget(controller: _controller),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                      child: Icon(
                                        _controller.paymentMethod.value == 0 ? Icons.money : Icons.credit_card,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _controller.paymentMethod.value == 0 ? 'Cash' : 'Online Payment', 
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                                      )
                                    ),
                                    const Text("Change", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 13)),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blue),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    
                    // Fixed Bottom Action Bar
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]
                      ),
                      child: SafeArea(
                        top: false,
                        child: Row(
                          children: [
                            if (rideData != null && (rideData.tripSubType == 1 || (rideData.tripType ?? 1) == 3))
                              Expanded(
                                flex: 1,
                                child: _actionButton("Schedule", () {
                                  _selectDateTime(context, (selectedDateTime) {
                                    _controller.selectedDateTime.value = selectedDateTime;
                                    _controller.isDateTimeSelected.value = true;
                                    if (_controller.dashboardData.value.activeTrip?.status == 0 ||
                                        _controller.dashboardData.value.activeTrip?.status == 1 ||
                                        _controller.dashboardData.value.activeTrip?.status == 3) {
                                      AppCommonWidgets.showAppToast('Already have a booking');
                                      return;
                                    }
                                    _controller.hitConfirmBookingApi(callBack: (tripId) {
                                      _controller.isDateTimeSelected.value = false;
                                      showSuccessBookingDialog();
                                    });
                                  });
                                }, outline: true),
                              ),
                            if (rideData != null && (rideData.tripSubType == 1 || (rideData.tripType ?? 1) == 3)) const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: _actionButton("Confirm Ride", () {
                                // Old UI exact confirmation logic ported to the new button style
                                if (_controller.dashboardData.value.activeTrip?.status == 1) {
                                  AppCommonWidgets.showAppToast('Already have a booking');
                                  return;
                                }

                                if ((rideData?.tripType ?? 1) == 1 || ((rideData?.tripType ?? 1) == 3 && _controller.isDateTimeSelected.value)) {
                                  _controller.isDateTimeSelected.value = false;
                                  _controller.hitConfirmBookingApi(callBack: (String tripId) {
                                    if (_controller.bookingRideModel.value.data != null) {
                                      if ((_controller.bookingRideModel.value.data!.isScheduled ?? 0) == 1) {
                                        Navigator.pushAndRemoveUntil(
                                            Get.overlayContext!,
                                            MaterialPageRoute(builder: (context) => CurrentRideDetailScreen(tripId: tripId)),
                                            (route) => false);
                                        return;
                                      }
                                    }
                                    Get.dialog(
                                      CommonSearchingDialog(
                                        title: 'Please wait...',
                                        description: 'We are searching the nearest driver for you.',
                                        barrierDismissible: false,
                                        onCancel: () {
                                          if (tripId.isNotEmpty) {
                                            Get.dialog(CancelRideDialog(
                                              tripId: tripId,
                                              onCancelClick: (_) {
                                                Get.offAll(const HomeMapViewScreen());
                                              },
                                            ));
                                          }
                                        },
                                        onRideAccepted: () {
                                          Navigator.pushAndRemoveUntil(
                                            Get.overlayContext!,
                                            MaterialPageRoute(builder: (context) => CurrentRideDetailScreen(tripId: tripId)),
                                            (route) => false,
                                          );
                                        },
                                      ),
                                      barrierDismissible: false,
                                    );
                                  });
                                } else if ((rideData?.tripType ?? 1) == 3) {
                                  _controller.hitConfirmBookingApi(callBack: (String id) {
                                    _controller.isDateTimeSelected.value = false;
                                    showSuccessBookingDialog();
                                  });
                                }
                              }),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                // Confetti overlay on top of the bottom sheet
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: controllerCenter,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  String getVehicleType(int? type) {
    return type == 1 ? "Hatchback" : type == 2 ? "Sedan" : type == 3 ? "SUV" : type == 4 ? "SUV Prime" : "";
  }

  Widget _modernFareRow(String label, String value, IconData icon, {Color? valueColor, Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor ?? Colors.grey.shade500),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w500))),
          Text(value, style: TextStyle(color: valueColor ?? Colors.black87, fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _vehicleDetailSection(int selectedIndex) {
    final vehicleData = _controller.vehicleDetailsMap[selectedIndex];
    if (vehicleData == null) return const SizedBox.shrink();
    final vehicles = vehicleData["vehicles"] as List;
    String bagInfo = "";
    String passengerInfo = "";

    switch (selectedIndex) {
      case 1: bagInfo = "2 Bags"; passengerInfo = "3 Seats"; break;
      case 2: bagInfo = "3 Bags"; passengerInfo = "4 Seats"; break;
      case 3: bagInfo = "6 Bags"; passengerInfo = "6 Seats"; break;
      case 4: bagInfo = "7 Bags"; passengerInfo = "7 Seats"; break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(getVehicleType(selectedIndex), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  _buildFeaturePill(Icons.work_outline, bagInfo),
                  const SizedBox(width: 8),
                  _buildFeaturePill(Icons.person_outline, passengerInfo),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: vehicles.map<Widget>((v) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        height: 45,
                        width: 80,
                        alignment: Alignment.center,
                        child: Image.asset(v["image"], fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 8),
                      Text(v["name"], style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
        ],
      ),
    );
  }

  Widget _actionButton(String title, VoidCallback onTap, {bool outline = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: outline ? Colors.white : AppColors.bfprimarythemeColor2,
          border: outline ? Border.all(color: Colors.grey.shade300, width: 1.5) : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          title, 
          style: TextStyle(
            color: outline ? Colors.black87 : Colors.white, 
            fontWeight: FontWeight.bold, 
            fontSize: 16
          )
        ),
      ),
    );
  }

  void _selectDateTime(BuildContext context, Function(DateTime) onDateTimeSelected) async {
    DateTime now = DateTime.now();
    DateTime minDateTime = now.add(const Duration(minutes: 30));

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: minDateTime,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.bfprimarythemeColor2,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      bool isToday = selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day;
      TimeOfDay initialTime = isToday ? TimeOfDay.fromDateTime(minDateTime) : const TimeOfDay(hour: 9, minute: 0);

      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.bfprimarythemeColor2,
              )
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child!,
            ),
          );
        },
      );

      if (selectedTime != null) {
        DateTime finalDateTime = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day,
          selectedTime.hour, selectedTime.minute,
        );

        if (isToday && finalDateTime.isBefore(minDateTime)) {
          Get.dialog(CommonAlertDialog(
            description: "Please select a time at least 30 minutes from now.",
            okCallback: () => Get.back(),
          ));
          return;
        }

        _controller.selectedDateTime.value = finalDateTime;
        _controller.isTripDateSelected.value = true;
        onDateTimeSelected(finalDateTime);
      }
    }
  }

  void showSuccessBookingDialog() {
    Get.dialog(
        BookingSuccessfullDialog(
          homeCallback: () {
            _controller.hitCustomerGetDashBoardApi(callBack: () {
              final activeTrip = _controller.dashboardData.value.activeTrip;
              if (activeTrip != null) {
                final tripId = activeTrip.id?.toString();
                Navigator.pushAndRemoveUntil(
                    Get.overlayContext!,
                    MaterialPageRoute(builder: (BuildContext context) => CurrentRideDetailScreen(tripId: tripId!)),
                    (route) => false);
              } else {
                AppCommonWidgets.showAppToast("Your ride is scheduled. Please wait");
              }
            });
          },
          trackOrderCallback: () {},
        ),
        barrierDismissible: false);
  }
}

// A helper widget for the dashed line in the fare summary card
class DottedBorderLine extends StatelessWidget {
  const DottedBorderLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(300 ~/ 5, (index) => Expanded(
        child: Container(
          color: index % 2 == 0 ? Colors.transparent : Colors.grey.shade300,
          height: 1.5,
        ),
      )),
    );
  }
}
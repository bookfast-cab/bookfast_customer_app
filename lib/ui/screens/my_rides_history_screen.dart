import 'package:bookfast_customer/controllers/my_rides_screen_controller.dart';
import 'package:bookfast_customer/models/trip_detail_model.dart';
import 'package:bookfast_customer/ui/screens/app_drawer.dart';
import 'package:bookfast_customer/ui/screens/banner_manager.dart';
import 'package:bookfast_customer/ui/screens/current_ride_detail.dart';
import 'package:bookfast_customer/ui/widgets/app_button_widget.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_functions.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../handlers/session_handler/session_manager.dart';
import '../../models/trip_histroy_model.dart';
import '../widgets/app_common_widgets.dart';
import '../widgets/app_container_widget.dart';
import 'home_map_view_screen.dart';

class MyRidesHistoryScreen extends StatefulWidget {
  const MyRidesHistoryScreen({super.key});

  @override
  State<MyRidesHistoryScreen> createState() => _MyRidesHistoryScreenState();
}

class _MyRidesHistoryScreenState extends State<MyRidesHistoryScreen> {
  final MyRidesHistoryScreenController _controller = Get.put(MyRidesHistoryScreenController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.scrollController = ScrollController();
      _controller.addScrollListener();
      _controller.hitTripHistory(callBack: () {});

      final bannerController = Get.put(BannerManagerController());
      bannerController.initSocket();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeScrollListener();
    super.dispose();
  }

  Future<void> onRefresh() async {
    _controller.myRides.clear();
    _controller.currentPage.value = 1;
    _controller.hasMore.value = true;
    _controller.hitTripHistory(callBack: () {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bfbackgroundColor, // Modern background
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          drawer: const AppDrawer(),
          body: Column(
            children: [
              CommonAppBar(
                titleText: AppStrings.strMyRides,
                isTitleCenter: false,
                titleTextColor: Colors.black87,
                backgroundColor: Colors.transparent,
                leadingWidget: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              
              // Status Tabs (Pill shaped)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _statusButton('All Trips', 0),
                      _statusButton('Accepted', 1),
                      _statusButton('Started', 3),
                      _statusButton('Completed', 4),
                      _statusButton('Cancelled', 5)
                    ],
                  ),
                ),
              ),

              // Rides List
              Expanded(
                child: Obx(() {
                  var rideList = _controller.selectedStatus.value == 0
                      ? _controller.myRides
                      : _controller.myRides
                          .where((ride) => (ride.status ?? -1) == _controller.selectedStatus.value)
                          .toList();

                  if (rideList.isEmpty && !_controller.hasMore.value && !_controller.isLoading.value) {
                    return AppCommonWidgets.noDataWidget(text: 'No rides found');
                  }

                  return RefreshIndicator(
                    onRefresh: onRefresh,
                    color: AppColors.bfprimarythemeColor2,
                    child: ListView.builder(
                      controller: _controller.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemCount: rideList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == rideList.length) {
                          return _controller.hasMore.value 
                            ? const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())) 
                            : const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildModernRideCard(rideList[index]),
                        );
                      },
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Modern Ride Card UI
  Widget _buildModernRideCard(ride) {
    bool showActionButtons = [0, 1, 6, 7, 8, 9].contains(ride.status);
    bool showTrackButton = (ride.status == 1 || ride.status == 3);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Ride ID & Status Pill
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long, color: AppColors.bfprimarythemeColor2, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Ride #${ride.id ?? ''}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                    ),
                  ],
                ),
                _buildStatusPill(ride.status ?? 0),
              ],
            ),
          ),
          
          Divider(height: 1, color: Colors.grey.shade100),

          // Address Section (Timeline UI)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 2),
                    const Icon(Icons.radio_button_checked, size: 16, color: AppColors.bfprimarythemeColor2),
                    Container(height: 35, width: 2, color: Colors.grey.shade300),
                    const Icon(Icons.location_on, size: 18, color: Colors.red),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.pickupAddress ?? 'N/A',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        ride.dropAddress ?? 'N/A',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade100),

          // Explicit Trip Details List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow("Distance", "${ride.distance ?? 0} km"),
                _buildDetailRow("Trip Type", getTripType(ride.tripType)),
                _buildDetailRow("Trip Sub Type", ride.tripSubType == 1 ? "One Way" : "Round Trip"),
                _buildDetailRow("Vehicle Type", getVehicleType(ride.vehicleType)),
                _buildDetailRow("Pickup Date", AppFunctions.convertDateToYYYYMMDDHHMM(ride.pickupDate) ?? 'N/A'),
                if (ride.tripSubType == 2 && ride.returnDateTime != null)
                  _buildDetailRow("Return Date", AppFunctions.convertDateToYYYYMMDDHHMM(ride.returnDateTime) ?? 'N/A'),
                _buildDetailRow("Created At", AppFunctions.convertDateToYYYYMMDDHHMM(ride.createdAt) ?? 'N/A', isLast: true),
              ],
            ),
          ),

          // Cancel Reason (If any)
          if (ride.status == 5 && ride.cancelledReason != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Reason: ${ride.cancelledReason}",
                      style: TextStyle(color: Colors.red.shade800, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          if (ride.status == 5 && ride.cancelledReason != null) const SizedBox(height: 12),

          // Pricing Summary Box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.bfCardLightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                if ((ride.driverAllowance ?? 0) > 0)
                  _pricingRow("Driver Allowance", "₹${ride.driverAllowance}"),
                if ((ride.discount ?? 0) > 0) ...[
                  _pricingRow("Subtotal", "₹${(ride.subTotal ?? 0).toStringAsFixed(2)}"),
                  _pricingRow("Discount", "-₹${(ride.discount ?? 0).toStringAsFixed(2)}", isDiscount: true),
                ],
                if ((ride.driverAllowance ?? 0) > 0 || (ride.discount ?? 0) > 0)
                  const Divider(color: Colors.white, thickness: 1.5, height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                    Text(
                      "₹${(ride.total ?? 0).toStringAsFixed(2)}", 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.bfprimarythemeColor2)
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action Buttons
          if (showActionButtons || showTrackButton)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (showActionButtons)
                    Expanded(
                      child: _actionButton("Cancel Ride", () {
                        _controller.hitTripCancelReasonsApi(callBack: () {
                          showCancelRideDialog(ride.id!);
                        });
                      }, isDanger: true),
                    ),
                  if (showActionButtons) const SizedBox(width: 10),
                  if (showActionButtons)
                    Expanded(
                      child: _actionButton("Support", () async {
                        String? helpline = await SessionManager.getHelplineNumber();
                        final numberToCall = helpline?.isNotEmpty == true ? helpline : "8817430000";
                        final Uri callUri = Uri.parse("tel:$numberToCall");
                        if (await canLaunchUrl(callUri)) await launchUrl(callUri);
                      }, outline: true),
                    ),
                  if (showActionButtons && showTrackButton) const SizedBox(width: 10),
                  if (showTrackButton)
                    Expanded(
                      child: _actionButton("Track Ride", () {
                        Get.to(CurrentRideDetailScreen(tripId: ride.id.toString()));
                      }),
                    ),
                ],
              ),
            ),
          
          if (!showActionButtons && !showTrackButton)
            const SizedBox(height: 8),
        ],
      ),
    );
  }

  // Sub-widgets for the Ride Card
  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pricingRow(String label, String value, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          Text(value, style: TextStyle(color: isDiscount ? Colors.green.shade600 : Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildStatusPill(int status) {
    String text;
    Color bgColor;
    Color textColor;

    switch (status) {
      case 0: text = "Pending"; bgColor = Colors.orange.shade50; textColor = Colors.orange.shade800; break;
      case 1: text = "Accepted"; bgColor = AppColors.bfCardLightBlue; textColor = AppColors.bfprimarythemeColor2; break;
      case 3: text = "Started"; bgColor = Colors.blue.shade50; textColor = Colors.blue.shade800; break;
      case 4: text = "Completed"; bgColor = Colors.green.shade50; textColor = Colors.green.shade800; break;
      case 5: text = "Cancelled"; bgColor = Colors.red.shade50; textColor = Colors.red.shade800; break;
      default: text = ""; bgColor = Colors.grey.shade100; textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _actionButton(String title, VoidCallback onTap, {bool outline = false, bool isDanger = false}) {
    Color primaryColor = isDanger ? Colors.red.shade500 : AppColors.bfprimarythemeColor2;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: outline ? Colors.transparent : primaryColor,
          border: outline ? Border.all(color: primaryColor, width: 1.2) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title, 
          style: TextStyle(
            color: outline ? primaryColor : Colors.white, 
            fontWeight: FontWeight.bold, 
            fontSize: 13
          )
        ),
      ),
    );
  }

  Widget _statusButton(String text, int status) {
    return Obx(() {
      bool isSelected = _controller.selectedStatus.value == status;
      return GestureDetector(
        onTap: () {
          _controller.selectedStatus.value = status;
          _controller.hitTripHistory(callBack: () {});
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.bfprimarythemeColor2 : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: isSelected ? AppColors.bfprimarythemeColor2 : Colors.grey.shade300, width: 1.2),
            boxShadow: isSelected 
              ? [BoxShadow(color: AppColors.bfprimarythemeColor2.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3))] 
              : [],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      );
    });
  }

  String getVehicleType(int? type) {
    switch(type) {
      case 1: return "Hatchback";
      case 2: return "Sedan";
      case 3: return "SUV";
      case 4: return "SUV Prime";
      default: return "N/A";
    }
  }

  String getTripType(int? type) {
    switch(type) {
      case 1: return "Local Ride";
      case 3: return "Outstation";
      default: return "Ride";
    }
  }

  void showCancelRideDialog(int tripId) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded, size: 36, color: Colors.red),
              ),
              const SizedBox(height: 16),
              const Text(
                "Cancel Ride",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                "Please select a reason for cancelling your ride.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              Obx(() {
                return SizedBox(
                  height: Get.height * 0.35,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _controller.cancelRideModel.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          _controller.selectedReason.value = _controller.cancelRideModel[index];
                          _controller.hitCustomerCancelTripApi(
                            tripId: tripId,
                            callBack: () {
                              Get.offAll(const HomeMapViewScreen());
                            }
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                            color: AppColors.bfbackgroundColor,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _controller.cancelRideModel[index].reason ?? '',
                                  style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20)
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                );
              }),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Keep Ride',
                    style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
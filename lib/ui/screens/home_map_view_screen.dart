import 'package:bookfast_customer/controllers/booking_ride_screen_controller.dart';
import 'package:bookfast_customer/controllers/my_rides_screen_controller.dart';
import 'package:bookfast_customer/controllers/search_drop_location_screen_controller.dart';
import 'package:bookfast_customer/ui/dialogs/cancel_ride_dialog.dart';
import 'package:bookfast_customer/ui/screens/app_drawer.dart';
import 'package:bookfast_customer/ui/screens/banner_manager.dart';
import 'package:bookfast_customer/ui/screens/search_drop_location_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_common_widgets.dart';
import 'package:bookfast_customer/ui/widgets/app_text_field_widget.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/utils/app_functions.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:confetti/confetti.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../handlers/session_handler/session_manager.dart';
import '../../models/booking_ride_model.dart';
import '../dialogs/booking_successfull_dialog.dart';
import '../dialogs/comman_searching_dialog.dart';
import '../dialogs/common_alert_dialog.dart';
import '../dialogs/payment_dialog.dart';
import '../dialogs/rental_dialog_dart.dart';
import '../widgets/app_container_widget.dart';
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
  final BookingRideScreenController _controller =
      Get.put(BookingRideScreenController());
  final SearchDropLocationController _searchDropLocationController =
      Get.put(SearchDropLocationController());
  final MyRidesHistoryScreenController _myRidesHistoryScreenController =
      Get.put(MyRidesHistoryScreenController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _controller.loadDrCustomMarkers();
      _controller.getCurrentLocation(callback: () {
        _controller.hitCustomerGetDashBoardApi(callBack: () {});
      });
      if (_searchDropLocationController
          .pickAddressController.value.text.isEmpty) {
        _searchDropLocationController.getCurrentLocation(null);
      }

      // _controller.hitCustomerGetDashBoardApi(callBack: () {});
      final bannerController = Get.put(BannerManagerController());
      bannerController.initSocket();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bfPrimaryColor,
      child: SafeArea(
        left: true,
        top: true,
        right: true,
        bottom: true,
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          drawer: const AppDrawer(),
          body: Obx(() {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      AppContainer(
                        width: double.infinity,
                        child: Obx(() {
                          final position = _controller.currentPosition.value;
                          if (position == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return GoogleMap(
                            onMapCreated: _controller.onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target:
                                  LatLng(position.latitude, position.longitude),
                              zoom: 12.0,
                            ),
                            // gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
                            markers: {
                              Marker(
                                markerId: const MarkerId('currentLocation'),
                                //icon: _controller.customerIcon,
                                position: LatLng(
                                    position.latitude, position.longitude),
                              ),
                              if (_searchDropLocationController.pickLat.value !=
                                      0.0 &&
                                  _searchDropLocationController.pickLng.value !=
                                      0.0)
                                Marker(
                                  markerId: const MarkerId('pickLocation'),
                                  position: LatLng(
                                    _searchDropLocationController.pickLat.value,
                                    _searchDropLocationController.pickLng.value,
                                  ),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueGreen),
                                ),
                              if (_controller.selectedMarker.value != null)
                                _controller.selectedMarker.value!,

                              //  All near by drivers
                              ..._controller.driverMarkers,
                            },
                            polylines: _controller.polyline.value != null
                                ? {_controller.polyline.value!}
                                : {},
                            zoomControlsEnabled: false,
                          );
                        }),
                      ),
                      Positioned(
                        top: 20,
                        left: 10,
                        right: 20,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Image.asset(
                                AppImages.icDrawer,
                                height: 35,
                                width: 35,
                              ),
                              onPressed: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Obx(() {
                                return AppContainer(
                                  color: AppColors.whiteColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  allBorderRadius: 12,
                                  borderColor: AppColors.bfPrimaryColor,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        AppImages.icCurrentLocation,
                                        height: 18,
                                        width: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: AppTextWidget(
                                          _searchDropLocationController
                                                  .pickAddressController
                                                  .value
                                                  .text
                                                  .isEmpty
                                              ? "Enter Pickup Location"
                                              : _searchDropLocationController
                                                  .pickAddressController
                                                  .value
                                                  .text,
                                          // _controller.currentAddress.value.isEmpty
                                          //     ? _controller.currentAddress.value
                                          //     : _controller.currentAddress.value,
                                          style: AppTextStyles
                                              .body2RegularTextStyle(
                                            textColor: AppColors.textColor90,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    print("------->>>> On click");
                                    _searchDropLocationController
                                        .isFromBookingScreen.value = true;
                                    Get.to(const SearchDropLocationScreen())!
                                        .then((value) {
                                      if (_searchDropLocationController
                                                  .pickLat.value !=
                                              0.0 &&
                                          _searchDropLocationController
                                                  .pickLng.value !=
                                              0.0) {
                                        _controller.hitCustomerGetDashBoardApi(
                                            callBack: () {});
                                      }
                                      if (_searchDropLocationController
                                          .dropAddressController
                                          .value
                                          .text
                                          .isNotEmpty) {
                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          _controller.hitCheckFareApi(
                                              callBack: () {
                                            print(
                                                'open Bottom sheet -------->');
                                            openFareBottomSheet(context);
                                          });
                                          //   }
                                        });
                                      }
                                    });
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Obx(() {
                            bool showFloatingButton =
                                _myRidesHistoryScreenController.myRides
                                    .any((ride) => (ride.status ?? 0) == 0);
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (showFloatingButton)
                                  FloatingActionButton(
                                    backgroundColor: AppColors.bfPrimaryColor,
                                    onPressed: () async {
                                      String? helpline = await SessionManager
                                          .getHelplineNumber();

                                      final numberToCall =
                                          helpline?.isNotEmpty == true
                                              ? helpline
                                              : "8817430000";

                                      final Uri callUri =
                                          Uri.parse("tel:$numberToCall");
                                      // final Uri callUri = Uri.parse("tel:8817430000");
                                      if (await canLaunchUrl(callUri)) {
                                        await launchUrl(callUri);
                                      } else {
                                        print("Could not launch $callUri");
                                      }
                                    },
                                    child: Image.asset(
                                        AppImages.icCustomerService),
                                  ).marginOnly(top: 15),
                              ],
                            ).paddingSymmetric(horizontal: 10, vertical: 15);
                          })),
                    ],
                  ),
                ),
                AppContainer(
                  topLeftRadius: 20,
                  topRightRadius: 20,
                  allBorderRadius: 20,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _tripOption(1, AppImages.icDaily),
                          _tripOption(2, AppImages.icRental),
                          _tripOption(3, AppImages.icOutStation),
                        ],
                      ),
                      const SizedBox(height: 14),
                      AppTextFieldWidget(
                          controller: _searchDropLocationController
                              .dropAddressController.value,
                          readOnly: true,
                          borderRadius: 12,
                          hintText: AppStrings.strWhereTo,
                          hintColor: AppColors.textColor50,
                          borderColor: AppColors.textColor60,
                          prefixIcon: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: const Icon(
                              Icons.location_on,
                              color: AppColors.dangerPrimaryColor,
                              size: 22,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                              top: 12, bottom: 12, right: 20),
                          onTap: () async {
                            _searchDropLocationController
                                .isFromBookingScreen.value = false;
                            Get.to(const SearchDropLocationScreen())!
                                .then((value) {
                              Future.delayed(const Duration(seconds: 1), () {
                                if (_searchDropLocationController
                                            .pickLat.value !=
                                        0.0 &&
                                    _searchDropLocationController
                                            .pickLng.value !=
                                        0.0) {
                                  _controller.hitCustomerGetDashBoardApi(
                                      callBack: () {});
                                }
                                if (_searchDropLocationController
                                    .dropAddressController
                                    .value
                                    .text
                                    .isNotEmpty) {
                                  _controller.polyline.refresh();

                                  print(
                                      "Drop location lat lng ---->>> lat${_searchDropLocationController.pickLat.value},lng${_searchDropLocationController.pickLng.value}");

                                  // _controller.fetchRoute();
                                  //  _controller.polyline.refresh();
                                  _controller.hitCheckFareApi(callBack: () {
                                    print('open Bottom sheet -------->');
                                    openFareBottomSheet(context);
                                  });
                                }
                              });
                            });
                          }),
                      const SizedBox(height: 14),
                      Obx(() {
                        double distance =
                            _controller.bookingRideModel.value.data?.km ?? 0.0;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (distance < 120)
                                _vehicleOption(
                                  AppStrings.strHatchback,
                                  1,
                                  Image.asset(AppImages.icHatchback,
                                      height: 60, width: 120),
                                ),
                              if (distance < 120) const SizedBox(width: 8),
                              _vehicleOption(
                                  AppStrings.strSedan,
                                  2, // index
                                  Image.asset(
                                    AppImages.icSedan,
                                    height: 60,
                                    width: 120,
                                  )),
                              const SizedBox(width: 8),
                              _vehicleOption(
                                  AppStrings.strSUV,
                                  3, // index
                                  Image.asset(
                                    AppImages.imgkia,
                                    height: 60,
                                    width: 120,
                                  )),
                              const SizedBox(width: 8),
                              _vehicleOption(
                                  AppStrings.strSUVPrime,
                                  4, // index
                                  Image.asset(
                                    AppImages.imginnova,
                                    height: 60,
                                    width: 120,
                                  )),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _tripOption(int index, String imagePath) {
    return Obx(() {
      bool isSelected = _controller.selectedTripTypeIndex.value == index;
      return InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          if (index == 2) {
            //  Get.dialog(RentalDialog(), barrierDismissible: false);

            Get.dialog(
              AlertDialog(
                title: Text("Coming Soon"),
                content: Text("BookFast Rental service will start soon!"),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text("OK"),
                  ),
                ],
              ),
            );
          } else {
            _controller.selectTripType(index);
            print("Trip Type $index selected");
          }
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  height: isSelected ? 110 : 90,
                )),
            if (_controller.selectedTripTypeIndex.value == index)
              const Icon(Icons.check_circle,
                  color: AppColors.bfPrimaryColor, size: 24),
          ],
        ),
      );
    });
  }

  Widget _vehicleOption(String title, int index, Image images) {
    return InkWell(
      onTap: () {
        _controller.selectVehicleType(index);

        if (_searchDropLocationController
            .dropAddressController.value.text.isNotEmpty) {
          _controller.hitCheckFareApi(callBack: () {
            print('open Bottom sheet -------->');
            // openFareBottomSheet(context);
            if (Get.isBottomSheetOpen ?? false) {
              Get.back();
            }
            Future.delayed(const Duration(milliseconds: 300), () {
              openFareBottomSheet(Get.context!);
            });
          });
        }
      },
      child: AppContainer(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 2),
        allBorderRadius: 7.0,
        borderColor: _controller.selectedVehicleTypeIndex.value == index
            ? AppColors.bfPrimaryColor
            : AppColors.textColor30,
        borderWidth:
            _controller.selectedVehicleTypeIndex.value == index ? 1.5 : 1,
        child: Column(
          children: [
            AppContainer(
              allBorderRadius: 10,
              color: AppColors.bfPrimaryColor,
              padding: const EdgeInsets.all(6),
              child: AppTextWidget(
                title,
                style: AppTextStyles.body2RegularTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            images,
          ],
        ),
      ),
    );
  }

  void _showApplyCouponDialog() {
    final ConfettiController controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
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
              AppTextWidget(
                'Available Coupons',
                style: AppTextStyles.body2RegularTextStyle(
                    textColor: AppColors.backColor20,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (_controller.couponList.isEmpty) {
                  return SizedBox(
                    height: Get.height / 2,
                    child: Center(
                      child: Text(
                        'No coupons available',
                        style: AppTextStyles.body2RegularTextStyle(
                          textColor: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: Get.height * 0.4,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _controller.couponList.length,
                    itemBuilder: (context, index) {
                      final coupon = _controller.couponList[index];
                      final isApplied =
                          (_controller.appliedCouponCode.value ?? '') ==
                              (coupon.code ?? '');
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isApplied ? Colors.grey.shade300 : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isApplied
                                ? Colors.grey.shade300
                                : AppColors.bfPrimaryColor,
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE0E0E0),
                                  ),
                                  child: const Icon(Icons.card_giftcard,
                                      color: Colors.purple),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${coupon.discountValue ?? ''}${coupon.discountType == 'percentage' ? '% Off' : ' Flat Off'}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'On your next booking',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(8),
                                  dashPattern: const [6, 3],
                                  color: Colors.grey,
                                  strokeWidth: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    child: Text(
                                      coupon.code ?? '',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () async {
                                      final alreadyApplied =
                                          coupon.alreadyApplied == true;
                                      final isLocked = _controller
                                          .isCouponAppliedAndLocked.value;
                                      final isSameCode = (_controller
                                                  .appliedCouponCode.value ??
                                              '') ==
                                          (coupon.code ?? '');

                                      if (alreadyApplied ||
                                          isLocked ||
                                          isSameCode) return;

                                      _controller.appliedCouponCode.value =
                                          coupon.code ?? '';

                                      await _controller.hitCheckFareApi(
                                          showCouponMessage: true,
                                          callBack: () async {
                                            final bookingData = _controller
                                                .bookingRideModel.value.data;
                                            if (bookingData?.couponData ==
                                                null) {
                                              AppCommonWidgets.showAppToast(
                                                  bookingData?.couponData
                                                          ?.message ??
                                                      '');
                                              _controller
                                                  .appliedCouponCode.value = '';
                                              return;
                                            }

                                            controllerCenter.play();
                                            // controllerCenter.play();
                                            // Get.back();
                                            Get.back();
                                            openFareBottomSheet(Get.context!);
                                          });
                                    },

                                    // onTap: () {
                                    //   final alreadyApplied = coupon.alreadyApplied == true;
                                    //   final isLocked = _controller.isCouponAppliedAndLocked.value;
                                    //   final isSameCode = (_controller.appliedCouponCode.value ?? '') == (coupon.code ?? '');
                                    //   if (!alreadyApplied && !isLocked && !isSameCode) {
                                    //     _controller.appliedCouponCode.value = coupon.code!;
                                    //     controllerCenter.play();
                                    //     Navigator.pop(context);
                                    //     Get.back();
                                    //     _controller.hitCheckFareApi(callBack: () {
                                    //       openFareBottomSheet(Get.context!);
                                    //     });
                                    //   }
                                    // },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: (coupon.alreadyApplied == true ||
                                                _controller
                                                    .isCouponAppliedAndLocked
                                                    .value)
                                            ? Colors.grey.shade400
                                            : AppColors.bfPrimaryColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.center,
                                        child: Text(
                                          coupon.alreadyApplied == true
                                              ? 'Already Applied'
                                              : isApplied
                                                  ? 'Applied: ${coupon.code ?? ''}'
                                                  : 'Apply',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
              AppContainer(
                height: 45,
                allBorderRadius: 10,
                borderColor: AppColors.bfPrimaryColor,
                child: AppTextWidget(
                  'Cancel',
                  style: AppTextStyles.body1RegularTextStyle(
                      textColor: AppColors.textColor90,
                      fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  Get.back();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Bottom sheet check fare api success and open bottom sheet for book and schedule ride
  void openFareBottomSheet(BuildContext context) {
    // double distance = _controller.bookingRideModel.value.data?.km ?? 0.0;
    final ConfettiController controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    BookingRideData? initialRideData = _controller.bookingRideModel.value.data;
    _controller.isDateTimeSelected.value = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black54,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Obx(() {
          final rideData = initialRideData;
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.center,
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
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Center(
                      child: Text("Fare Details",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 5),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (rideData != null)
                          _fareDetail("Distance:",
                              "${(rideData.km ?? 0.0).toStringAsFixed(2)} km"),
                        const SizedBox(height: 2),
                        if (rideData != null)
                          _fareDetail(
                              "Base Fare:", "₹${rideData.baseFare ?? ''}"),
                        if (rideData != null &&
                            rideData.driverAllowance != null &&
                            rideData.driverAllowance != 0)
                          const SizedBox(height: 5),
                        if (rideData != null &&
                            rideData.driverAllowance != null &&
                            rideData.driverAllowance != 0)
                          _fareDetail("Driver Allowance:",
                              "₹${rideData.driverAllowance ?? ''}"),
                        const SizedBox(height: 2),
                        if (rideData != null)
                          _fareDetail("Price per km:",
                              "₹${(rideData.pricePerKm ?? 0.0).toStringAsFixed(2) ?? ''}"),
                        const SizedBox(height: 2),
                        if (rideData != null && rideData.tripSubType == 2)
                          Column(
                            children: [
                              if (rideData.extraChargesBreakdown != null)
                                Column(
                                  children: [
                                    _fareDetail("Travelling hours:",
                                        "${(rideData.extraChargesBreakdown!.totalTravelingHours ?? 0.0) ?? ''}hrs"),
                                    const SizedBox(height: 5),
                                    _fareDetail("Total trip hours:",
                                        "${(rideData.extraChargesBreakdown!.totalTripHours ?? 0.0) ?? ''}hrs"),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              _fareDetail("Extra hours fare:",
                                  "₹${(rideData.extraHourCharges ?? 0.0).toStringAsFixed(2) ?? ''}"),
                            ],
                          ),
                        rideData != null && rideData.tripSubType == 2
                            ? const SizedBox(height: 5)
                            : SizedBox(),

                        /// Toll tax is 0 then not show on ui

                        // if (rideData != null) _fareDetail("Toll tax:", "₹${rideData.tollTax ?? 0.0 ?? ''}"),
                        if (rideData != null && (rideData.tollTax ?? 0.0) > 0)
                          _fareDetail(
                              "Toll Tax:", "₹${rideData.tollTax ?? '0'}"),
                        if (rideData != null && (rideData.tollTax ?? 0.0) > 0)
                          const SizedBox(height: 5),

                        /// Tax is 0 then not show on ui
                        if (rideData != null &&
                            (rideData.gst?.amount ?? 0.0) > 0)
                          _fareDetail("${rideData.gst?.title ?? ''}:",
                              "₹${rideData.gst?.amount ?? '0'}"),
                        if (rideData != null &&
                            (rideData.gst?.amount ?? 0.0) > 0)
                          const SizedBox(height: 5),

                        /// Coupon discount is 0 then not show on ui
                        if (rideData != null && (rideData.discount ?? 0.0) > 0)
                          Column(
                            children: [
                              _fareDetail("Sub Total Fare:",
                                  "₹${(rideData.fare).toStringAsFixed(0) ?? ''}"),
                              const SizedBox(height: 5),
                              _fareDetail("Coupon discount:",
                                  "₹${rideData.discount ?? '0'}"),
                            ],
                          ),
                        if (rideData != null && (rideData.discount ?? 0.0) > 0)
                          const SizedBox(height: 5),

                        if (rideData != null)
                          _fareDetail("Total Fare:",
                              "₹${(rideData.totalFare ?? 0.0).toStringAsFixed(2) ?? ''}"),
                        const SizedBox(height: 5),
                        if (rideData != null)
                          _fareDetail(
                            "Trip type:",
                            rideData.tripSubType == 1
                                ? "One Way"
                                : "Round Trip",
                          ),
                        const SizedBox(height: 5),
                        if (rideData != null)
                          _fareDetail(
                              "Vehicle type:",
                              getVehicleType(
                                  _controller.selectedVehicleTypeIndex.value)),
                        //   const SizedBox(height: 8),
                        /// PickUp + Return Date & Time
                        /// Only tripSubType == 2 (round trip)
                        if (rideData?.tripSubType == 2) ...[
                          /// PickUp Date & Time
                          if (rideData?.pickupDate != null ||
                              (rideData?.pickupTime?.isNotEmpty ?? false)) ...[
                            const SizedBox(height: 5),
                            _fareDetail(
                              "PickUp Date&Time:",
                              "${rideData?.pickupDate != null ? AppFunctions.convertDate(rideData!.pickupDate) : ""}"
                                  "${(rideData?.pickupDate != null && (rideData?.pickupTime?.isNotEmpty ?? false)) ? " / " : ""}"
                                  "${rideData?.pickupTime ?? ""}",
                            ),
                          ],

                          /// Return Date & Time
                          if (rideData?.returnPickupDate != null ||
                              (rideData?.returnPickupTime?.isNotEmpty ??
                                  false)) ...[
                            const SizedBox(height: 5),
                            _fareDetail(
                              "Return Date&Time:",
                              "${rideData?.returnPickupDate != null ? AppFunctions.convertDate(rideData!.returnPickupDate) : ""}"
                                  "${(rideData?.returnPickupDate != null && (rideData?.returnPickupTime?.isNotEmpty ?? false)) ? " / " : ""}"
                                  "${rideData?.returnPickupTime ?? ""}",
                            ),
                          ],
                        ],

                        /// Date time show only schedule ride /////
                        if (_controller.isDateTimeSelected.value)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: InkWell(
                                onTap: () {
                                  _selectDateTime(context, (selected) {
                                    _controller.selectedDateTime.value =
                                        selected;
                                  });
                                },
                                child: _fareDetail(
                                    "Scheduled Time:",
                                    AppFunctions.convertDateToYYYYMMDDHHMM2(
                                        _controller.selectedDateTime.value))),
                          ),
                        const SizedBox(height: 5),
                        _vehicleDetailSection(
                            _controller.selectedVehicleTypeIndex.value),
                        const SizedBox(height: 5),
                        _controller.couponList.isNotEmpty
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Available Coupons",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        const SizedBox(height: 8),
                        Obx(() {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _controller.couponList.map((coupon) {
                                final isApplied =
                                    _controller.appliedCouponCode.value ==
                                        coupon.code;
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isApplied
                                        ? Colors.grey.shade300
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isApplied
                                          ? Colors.grey
                                          : AppColors.bfPrimaryColor,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${coupon.discountValue ?? ''}'
                                            '${coupon.discountType == 'percentage' ? '% Off' : ' Flat Off'}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          const Text(
                                            'On your booking',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 18),
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () async {
                                          final alreadyApplied =
                                              coupon.alreadyApplied == true;
                                          final isLocked = _controller
                                              .isCouponAppliedAndLocked.value;
                                          final isSameCode = (_controller
                                                      .appliedCouponCode
                                                      .value ??
                                                  '') ==
                                              (coupon.code ?? '');

                                          if (alreadyApplied ||
                                              isLocked ||
                                              isSameCode) return;

                                          await _controller.hitCheckFareApi(
                                            couponCode: coupon.code,
                                            showCouponMessage: true,
                                            callBack: () {
                                              final bookingData = _controller
                                                  .bookingRideModel.value.data;

                                              if (bookingData?.couponData ==
                                                      null ||
                                                  bookingData?.couponData
                                                          ?.isCouponApplicable ==
                                                      false) {
                                                return;
                                              }
                                              _controller.appliedCouponCode
                                                  .value = coupon.code ?? '';

                                              controllerCenter.play();
                                              Get.back();
                                              openFareBottomSheet(Get.context!);
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isApplied
                                                ? Colors.grey
                                                : AppColors.bfPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            isApplied ? 'APPLIED' : 'APPLY',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }),
                        /* SizedBox(
                                height: 120,
                                child: Obx(() {
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _controller.couponList.length,
                                    itemBuilder: (context, index) {
                                      final coupon = _controller.couponList[index];
                                      final isApplied = _controller.appliedCouponCode.value == coupon.code;

                                      return Container(
                                        width: 240,
                                        margin: const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isApplied ? Colors.grey.shade300 : Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isApplied
                                                ? Colors.grey.shade300
                                                : AppColors.bfPrimaryColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '${coupon.discountValue ?? ''}'
                                                      '${coupon.discountType == 'percentage' ? '% Off' : ' Flat Off'}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                const Text(
                                                  'On your booking',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const Spacer(),

                                            /// APPLY BUTTON (NO EXPANDED)
                                            GestureDetector(
                                              onTap: () async {
                                                final alreadyApplied = coupon.alreadyApplied == true;
                                                final isLocked = _controller.isCouponAppliedAndLocked.value;
                                                final isSameCode =
                                                    _controller.appliedCouponCode.value ==
                                                        coupon.code;

                                                if (alreadyApplied || isLocked || isSameCode) return;

                                                final couponCode = coupon.code;
                                                if (couponCode == null || couponCode.isEmpty) return;

                                                await _controller.hitCheckFareApi(
                                                  showCouponMessage: true,
                                                  couponCode: couponCode,
                                                  callBack: () {
                                                    _controller.appliedCouponCode.value = couponCode;
                                                    controllerCenter.play();
                                                    Get.back();
                                                    openFareBottomSheet(Get.context!);
                                                  },
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: (coupon.alreadyApplied == true ||
                                                      _controller.isCouponAppliedAndLocked.value)
                                                      ? Colors.grey.shade400
                                                      : AppColors.bfPrimaryColor,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  isApplied ? 'APPLIED' : 'APPLY',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                    },
                                  );
                                }),
                              ),*/

                        const SizedBox(height: 10),
                        AppContainer(
                          padding: EdgeInsets.all(8),
                          allBorderRadius: 10,
                          color: AppColors.bfPrimaryColor10,
                          child: Row(
                            children: [
                              Expanded(child: Obx(() {
                                return InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => CommonPaymentDialogWidget(
                                        controller: _controller,
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        _controller.paymentMethod.value == 0
                                            ? AppImages.icPayment
                                            : AppImages.icMobilePayment,
                                        height: 30,
                                        width: 30,
                                        color: AppColors.primaryColor100,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Payment Mode',
                                          style: AppTextStyles
                                              .body2RegularTextStyle(
                                            textColor: AppColors.textColor80,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        _controller.paymentMethod.value == 0
                                            ? 'Cash'
                                            : 'Online',
                                        style:
                                            AppTextStyles.body2RegularTextStyle(
                                          textColor: AppColors.textColor80,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })),
                              // Container(
                              //   height: 20,
                              //   width: 1,
                              //   color: AppColors.textColor70,
                              // ),
                              // SizedBox(
                              //   width: 14,
                              // ),
                              // Expanded(
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       _controller.hitCustomerGetCouponsListApi(callBack: () {});
                              //       _showApplyCouponDialog();
                              //     },
                              //     child: Row(
                              //       children: [
                              //         Image.asset(
                              //           AppImages.icApplyCoupon,
                              //           height: 26,
                              //           width: 26,
                              //         ),
                              //         const SizedBox(
                              //           width: 8,
                              //         ),
                              //         Expanded(
                              //           child: Obx(() {
                              //             final code = _controller.appliedCouponCode.value;
                              //             final coupon = _controller.couponList.firstWhereOrNull((c) => c.code == code);
                              //             final isValid = (coupon?.discountValue != null) && (num.tryParse(coupon!.discountValue!) ?? 0) > 0;
                              //             return AppTextWidget(
                              //               isValid ? "Applied Coupon: ${coupon.code}" : AppStrings.strApplyCouponBf,
                              //               style: AppTextStyles.body2RegularTextStyle(
                              //                 textColor: AppColors.textColor80,
                              //                 fontWeight: FontWeight.w600,
                              //                 fontSize: 13,
                              //               ),
                              //               maxLines: 1,
                              //               // overflow: TextOverflow.ellipsis,
                              //             );
                              //           }),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _actionButton("Book Ride", () {
                                _controller.isDateTimeSelected.value = false;

                                _controller.hitConfirmBookingApi(
                                  callBack: (tripId) {
                                    print("under iff ");

                                    if (_controller
                                            .bookingRideModel.value.data !=
                                        null) {
                                      print("under iff 111");
                                      if ((_controller.bookingRideModel.value
                                                  .data!.isScheduled ??
                                              0) ==
                                          1) {
                                        print("under 2");
                                        Navigator.pushAndRemoveUntil(
                                            Get.overlayContext!,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        CurrentRideDetailScreen(
                                                            tripId: tripId)),
                                            (route) => false);
                                        return;
                                      }
                                    }

                                    Get.dialog(
                                      CommonSearchingDialog(
                                        title: 'Please wait...',
                                        description:
                                            'We are searching the nearest driver for you.',
                                        barrierDismissible: false,
                                        onCancel: () {
                                          if (tripId.isNotEmpty) {
                                            Get.dialog(
                                              CancelRideDialog(
                                                tripId: tripId,
                                                onCancelClick: (_) {
                                                  Get.offAll(
                                                      const HomeMapViewScreen());
                                                },
                                              ),
                                            );
                                          }
                                        },
                                        onRideAccepted: () {
                                          Navigator.pushAndRemoveUntil(
                                            Get.overlayContext!,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CurrentRideDetailScreen(
                                                      tripId: tripId),
                                            ),
                                            (route) => false,
                                          );
                                        },
                                      ),
                                      barrierDismissible: false,
                                    );
                                  },
                                );
                              }),
                            ),
                            if (rideData != null && rideData.tripSubType == 1)
                              const SizedBox(width: 12),
                            if (rideData != null && rideData.tripSubType == 1)
                              Expanded(
                                child: _actionButton("Schedule Ride", () {
                                  _selectDateTime(context, (selectedDateTime) {
                                    _controller.selectedDateTime.value =
                                        selectedDateTime;
                                    _controller.isDateTimeSelected.value = true;
                                    if (_controller.dashboardData.value.activeTrip?.status == 0 ||
                                        _controller.dashboardData.value
                                                .activeTrip?.status ==
                                            1 ||
                                        _controller.dashboardData.value
                                                .activeTrip?.status ==
                                            3) {
                                      AppCommonWidgets.showAppToast(
                                          'Already have a booking');
                                      return;
                                    }
                                    _controller.hitConfirmBookingApi(
                                      callBack: (tripId) {
                                        _controller.isDateTimeSelected.value =
                                            false;

                                        showSuccessBookingDialog();
                                      },
                                    );
                                  });
                                }),
                              ),
                          ],
                        )

                        /*if (rideData != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // if (!_controller.isDateTimeSelected.value && ((rideData.tripType ?? 1) == 3))
                                  if ((rideData.tripType ?? 1) == 3 && !_controller.isDateTimeSelected.value && (rideData.km ?? 0) > 25)
                                    Expanded(
                                      child: _actionButton(AppStrings.strScheduleRide, () {
                                        _selectDateTime(context, (selected) {
                                          _controller.isDateTimeSelected.value = true;

                                          _controller.selectedDateTime.value = selected;
                                        });
                                      }),
                                    ),
                                  if ((rideData.tripType ?? 1) == 1 || ((rideData.tripType ?? 1) == 3 && _controller.isDateTimeSelected.value))
                                    Expanded(
                                      child: _actionButton(AppStrings.strBookRide, () {
                                        if (_controller.dashboardData.value.activeTrip?.status == 1) {
                                          AppCommonWidgets.showAppToast('Already have a booking');
                                          return;
                                        }

                                        if ((rideData.tripType ?? 1) == 1) {
                                          _controller.hitConfirmBookingApi(callBack: (String tripId) {
                                            Get.dialog(
                                                CommonSearchingDialog(
                                                  title: 'Please wait...',
                                                  description: 'We are searching the nearest driver for you.',
                                                  barrierDismissible: false,
                                                  onCancel: () {
                                                    if (tripId != null) {
                                                      Get.dialog(CancelRideDialog(
                                                          tripId: tripId,
                                                          onCancelClick: (cancelData) {
                                                        Get.offAll(const HomeMapViewScreen());
                                                      }));
                                                    }
                                                  },
                                                  onRideAccepted: () {
                                                    Navigator.pushAndRemoveUntil(Get.overlayContext!,
                                                        MaterialPageRoute(builder: (BuildContext context) => CurrentRideDetailScreen(tripId: tripId)), (route) => false);

                                                    // Get.offAll(() => CurrentLocalRideDetailScreen(tripId: tripId));
                                                  },
                                                ),
                                                barrierDismissible: false);
                                          });
                                        } else if ((rideData.tripType ?? 1) == 3) {
                                          _controller.hitConfirmBookingApi(callBack: (String id) {
                                            _controller.isDateTimeSelected.value = false;
                                            showSuccessBookingDialog();
                                          });
                                        }
                                      }),
                                    ),

                                ],
                              ),*/
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
          // });
        });
      },
    );
  }

  Widget _vehicleDetailSection(int selectedIndex) {
    final vehicleData = _controller.vehicleDetailsMap[selectedIndex];
    if (vehicleData == null) return const SizedBox.shrink();

    final vehicles = vehicleData["vehicles"] as List;

    // Define info based on selected index
    String bagInfo = "";
    String passengerInfo = "";

    switch (selectedIndex) {
      case 1:
        bagInfo = "2 Bags";
        passengerInfo = "3 Passengers";
        break;
      case 2:
        bagInfo = "3 Large Bags";
        passengerInfo = "4 Passengers";
        break;
      case 3:
        bagInfo = "6 Large Bags";
        passengerInfo = "6 Passengers";
        break;
      case 4:
        bagInfo = "7 Large Bags";
        passengerInfo = "7 Passengers";
        break;
    }

    return AppContainer(
      padding: const EdgeInsets.all(8),
      allBorderRadius: 12,
      borderColor: AppColors.textColor20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget(
            "Fleet Overview",
            style: AppTextStyles.headingH3TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),

          // Vehicle image + name grid
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: vehicles.map<Widget>((v) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          //  border: Border.all(color: AppColors.bfPrimaryColor),
                          color: Colors.white,
                        ),
                        child: Image.asset(
                          v["image"],
                          fit: BoxFit.contain,
                        ),
                      ),
                      //  const SizedBox(height: 4),
                      AppTextWidget(
                        v["name"],
                        style: AppTextStyles.body2RegularTextStyle(
                          fontSize: 12,
                          textColor: AppColors.textColor70,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 3),

          // Info Row (bags + passengers)
          Row(
            children: [
              AppContainer(
                  padding: EdgeInsets.all(6),
                  allBorderRadius: 10,
                  color: AppColors.bfPrimaryColor10,
                  child: Row(
                    children: [
                      const Icon(Icons.work_outline,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      AppTextWidget(
                        bagInfo,
                        style: AppTextStyles.body2RegularTextStyle(
                          fontSize: 13,
                          textColor: AppColors.textColor80,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(width: 8),
              AppContainer(
                height: 15,
                width: 1,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              AppContainer(
                padding: EdgeInsets.all(6),
                allBorderRadius: 10,
                color: AppColors.bfPrimaryColor10,
                child: Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    AppTextWidget(
                      passengerInfo,
                      style: AppTextStyles.body2RegularTextStyle(
                        fontSize: 13,
                        textColor: AppColors.textColor80,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _fareDetail(String text, String value) {
    return AppContainer(
      //  padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Left text (Label)
          Expanded(
            flex: 3,
            child: AppTextWidget(
              text,
              style: AppTextStyles.body2RegularTextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                textColor: AppColors.textColor70,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          /// Right text (Value)
          Expanded(
            flex: 5,
            child: AppTextWidget(
              value,
              textAlign: TextAlign.right,
              maxLines: 5,
              overflow: TextOverflow.visible,
              style: AppTextStyles.headingH3TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                textColor: AppColors.backColor30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String title, VoidCallback onTap) {
    return AppContainer(
      height: 40,
      allBorderRadius: 10,
      color: AppColors.bfPrimaryColor,
      onTap: onTap,
      child: AppTextWidget(
        title,
        style: AppTextStyles.headingH2TextStyle(
            textColor: AppColors.whiteColor,
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  void _selectDateTime(
    BuildContext context,
    Function(DateTime) onDateTimeSelected,
  ) async {
    DateTime now = DateTime.now();
    DateTime minDateTime = now.add(const Duration(minutes: 30));

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: minDateTime,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );

    if (selectedDate != null) {
      TimeOfDay initialTime;
      // Agar selectedDate aaj hai, to 30 min aage ka time default do
      bool isToday = selectedDate.year == now.year &&
          selectedDate.month == now.month &&
          selectedDate.day == now.day;

      if (isToday) {
        initialTime = TimeOfDay.fromDateTime(minDateTime);
      } else {
        // Future date ke liye subah ka time default do
        initialTime = const TimeOfDay(hour: 9, minute: 0);
      }

      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );

      if (selectedTime != null) {
        DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        if (isToday && finalDateTime.isBefore(minDateTime)) {
          Get.dialog(
            CommonAlertDialog(
              description: "Please select a time at least 30 minutes from now.",
              okCallback: () => Get.back(),
            ),
          );
          return;
        }

        _controller.selectedDateTime.value = finalDateTime;
        _controller.isTripDateSelected.value = true;
        onDateTimeSelected(finalDateTime);
      }
    }
  }

  String getVehicleType(int? type) {
    return type == 1
        ? "Hatchback"
        : type == 2
            ? "Sedan"
            : type == 3
                ? "SUV"
                : type == 4
                    ? "SUV Prime"
                    : "";
  }

  /// Outstation ride confirm show this dialog
  void showSuccessBookingDialog() {
    Get.dialog(
        BookingSuccessfullDialog(
          homeCallback: () {
            //  Get.back();
            // Get.back();
            _controller.hitCustomerGetDashBoardApi(callBack: () {
              final activeTrip = _controller.dashboardData.value.activeTrip;
              if (activeTrip != null) {
                final status = activeTrip.status;
                final tripId = activeTrip.id?.toString();
                print(" print-> under track 2 ");

                Navigator.pushAndRemoveUntil(
                    Get.overlayContext!,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CurrentRideDetailScreen(tripId: tripId!)),
                    (route) => false);
              } else {
                AppCommonWidgets.showAppToast(
                    "Your ride is scheduled. Please wait");
              }
            });
          },
          trackOrderCallback: () {},
        ),
        barrierDismissible: false);
  }

  /// Local ride confirm and show this bottom sheet
  void showRideSearchingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // isDismissible: false,
      // enableDrag: false,
      isScrollControlled: true,
      builder: (context) {
        Future.delayed(const Duration(seconds: 20), () {
          Navigator.of(context).pop();
          // _controller.hitConfirmBookingApi(callBack: (String tripId) {
          //   Get.to(() => CurrentRideDetailScreen(tripId: tripId));
          // });
        });
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Searching for a driver...",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 20),
              // AppDriverFindLoader(),
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                "Please wait",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              AppTextWidget(
                "Cancel ride",
                style: AppTextStyles.body2RegularTextStyle(
                    textColor: AppColors.dangerDarkColor),
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

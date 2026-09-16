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
      color: AppColors.bfPrimaryColor,
      child: SafeArea(
        left: true,
        top: true,
        right: true,
        bottom: true,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const AppDrawer(),
          body: RefreshIndicator(
            onRefresh: onRefresh,
            child: Column(
              children: [
                CommonAppBar(
                  titleText: AppStrings.strMyRides,
                  isTitleCenter: false,
                  titleTextColor: AppColors.textColor100,
                  leadingWidget: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Get.back();
                      // _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
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

                Obx(() {
                  var rideStatus = _controller.selectedStatus.value == 0
                      ? _controller.myRides
                      : _controller.myRides
                      .where((ride) => (ride.status ?? -1) == _controller.selectedStatus.value)
                      .toList();

                  if (rideStatus.isEmpty) {
                    return SizedBox(
                      height: Get.height / 2,
                      child: AppCommonWidgets.noDataWidget(text: 'Empty Rides'),
                    );
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: ListView.builder(
                          controller: _controller.scrollController,
                          itemCount: _controller.myRides.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _controller.myRides.length) {
                              return _controller.hasMore.value ? const Center(child: CircularProgressIndicator()) : const SizedBox();
                            }
                            final ride = _controller.myRides[index];
                            bool showButtons = false;


                            if ((_controller.myRides[index].status ?? 0) == 5) {
                              showButtons = false;
                            } else {
                              if (_controller.myRides[index].pickupDate != null) {
                                DateTime now = DateTime.now();

                                if (_controller.myRides[index].pickupDate!.isAfter(now)) {
                                  showButtons = true;
                                } else {
                                  showButtons = false;
                                }
                              }
                            }

                            return
                                Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: AppContainer(
                                padding: const EdgeInsets.all(8),
                                allBorderRadius: 12,
                                borderColor: AppColors.textColor30,
                                child: Column(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.bfPrimaryColor.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Column(children: [
                                          _rideDetail('Pick point', titleTextColor: AppColors.primaryColor100, _controller.myRides[index].pickupAddress ?? ''),
                                          const SizedBox(height: 8),
                                          const Divider(height: 1, color: AppColors.textColor40),
                                          const SizedBox(height: 8),
                                          _rideDetail('Drop point', titleTextColor: AppColors.dangerPrimaryColor, _controller.myRides[index].dropAddress ?? ''),

                                        ])),
                                    // _rideDetail('Pick point', titleTextColor: AppColors.primaryColor100, _controller.myRides[index].pickupAddress ?? ''),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    // _rideDetail('Drop point', titleTextColor: AppColors.dangerPrimaryColor, _controller.myRides[index].dropAddress ?? ''),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _rideDetail('Distance', "${_controller.myRides[index].distance ?? ''} km"),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if(_controller.myRides[index].driverAllowance != null && _controller.myRides[index].driverAllowance != 0) ...[
                                    _rideDetail('Driver Allowance', "₹${_controller.myRides[index].driverAllowance?.toString() ?? '0'}"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ],

                                    /// Show this only when discount is greater than 0

                                    if (_controller.myRides[index].discount != null && _controller.myRides[index].discount! > 0) ...[
                                      _rideDetail('Subtotal', "₹ ${_controller.myRides[index].subTotal!.toStringAsFixed(2)}"),
                                      const SizedBox(height: 10),
                                      _rideDetail('Discount', "₹ ${_controller.myRides[index].discount!.toStringAsFixed(2)}"),
                                      const SizedBox(height: 10),
                                    ],

                                    _rideDetail('Trip type', getTripType(_controller.myRides[index].tripType)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _rideDetail('Trip sub type', _controller.myRides[index].tripSubType == 1 ? "One Way" : "Round Trip"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (_controller.myRides[index].tripSubType == 2)
                                    Column(
                                      children: [
                                        _rideDetail(
                                            'Pickup date',
                                            AppFunctions.convertDateToYYYYMMDDHHMM(
                                              _controller.myRides[index].pickupDate != null ? _controller.myRides[index].pickupDate! : null,
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        _rideDetail(
                                            'Return date',
                                            AppFunctions.convertDateToYYYYMMDDHHMM(
                                              _controller.myRides[index].pickupDate != null ? _controller.myRides[index].returnDateTime! : null,
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    _rideDetail('Vehicle type', getVehicleType(_controller.myRides[index].vehicleType)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _rideDetail(
                                        'Created at',
                                        AppFunctions.convertDateToYYYYMMDDHHMM(
                                          _controller.myRides[index].pickupDate != null ? _controller.myRides[index].createdAt! : null,
                                        )),
                                    if (_controller.myRides[index].tripSubType == 1)
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (_controller.myRides[index].tripSubType == 1)
                                    _rideDetail(
                                        'Pickup date',
                                        AppFunctions.convertDateToYYYYMMDDHHMM(
                                          _controller.myRides[index].pickupDate != null ? _controller.myRides[index].pickupDate! : null,
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _rideDetail('Total amount', "₹ ${_controller.myRides[index].total?.toStringAsFixed(2) }"),


                                    /// Show status ride start ///
                                    if ((_controller.myRides[index].status ?? 0) == 3)
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    if (_controller.myRides[index].status == 3)
                                      _rideDetail('Ride status', _controller.myRides[index].status == 3 ? 'Your ride has start' : '',
                                        subtitleTextColor: AppColors.primaryColor100,
                                      ),
                                    /// Show status completed ride ///
                                    if ((_controller.myRides[index].status ?? 0) == 4)
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    if (_controller.myRides[index].status == 4)
                                      _rideDetail('Ride status', _controller.myRides[index].status == 4 ? 'Ride Completed' : '',
                                        subtitleTextColor: AppColors.primaryColor100,
                                      ),
                                    /// Show cancelled ride ///
                                    if ((_controller.myRides[index].status ?? 0) == 5)
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    if (_controller.myRides[index].status == 5)
                                      _rideDetail(
                                        'Ride status',
                                        _controller.myRides[index].status == 5 ? 'Cancelled' : '',
                                        subtitleTextColor: AppColors.dangerPrimaryColor,
                                      ),
                                    if (_controller.myRides[index].status == 5)
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (_controller.myRides[index].status == 5)
                                      _rideDetail(
                                        'Cancelled reason',
                                        _controller.myRides[index].cancelledReason ?? '',
                                        subtitleTextColor: AppColors.dangerPrimaryColor,
                                      ),
                                    //   if (_controller.selectedStatus.value == 0)
                                    const SizedBox(
                                      height: 10,
                                    ),

                                  ///    Cancelled button
                                    if ([0, 1, 6, 7, 8, 9].contains(_controller.myRides[index].status))
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AppButton(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              title: AppStrings.strCancelRide,
                                              onClick: () {
                                                _controller.hitTripCancelReasonsApi(callBack: () {
                                                  showCancelRideDialog(_controller.myRides[index].id!);
                                                });
                                              },
                                              bgColor: AppColors.bfPrimaryColor,
                                            ),
                                          ),
                                          /// Call button
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: AppButton(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              title: "Admin call",
                                              onClick: () async {
                                               // _makePhoneCall("8817430000");

                                                String? helpline = await SessionManager.getHelplineNumber();
                                                final numberToCall = helpline?.isNotEmpty == true ? helpline : "8817430000";

                                                final Uri callUri = Uri.parse("tel:$numberToCall");

                                                if (await canLaunchUrl(callUri)) {
                                                await launchUrl(callUri);
                                                } else {
                                                print("Could not launch $callUri");
                                                }
                                              },
                                              bgColor: AppColors.primaryColor100,
                                            ),
                                          )
                                        ],
                                      ),
                                    SizedBox(height: 15,),
                                    if((_controller.myRides[index].status == 1) || _controller.myRides[index].status == 3)
                                    AppButton(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      bgColor: AppColors.bfPrimaryColor,
                                      title: 'Track',
                                      onClick: (){
                                        print(" print-> under track 1 ");
                                        String? id = _controller.myRides[index].id.toString();
                                        Get.to(CurrentRideDetailScreen(tripId: id.toString()));
                                      },
                                    )
                                  ],
                                ),
                                onTap: () {
                                  // int? id = _controller.myRides[index].id;
                                  // Get.to(TripDetailScreen(id: id));
                                },
                              ),
                            );
                            // : const SizedBox();
                          }),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _makePhoneCall(String phoneNumber) async {
  //
  //   final Uri callUri = Uri.parse("tel:$phoneNumber");
  //
  //   if (await canLaunchUrl(callUri)) {
  //     await launchUrl(callUri);
  //   } else {
  //     print("Could not launch $callUri");
  //   }
  // }

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

  String getTripType(int? type) {
    return type == 1
        ? "Local ride"
        : type == 3
        ? "Outstation"
        : "";
  }

  Widget _statusButton(String text, int status) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: AppContainer(
          padding: const EdgeInsets.all(5),
          allBorderRadius: 10,
          borderWidth: _controller.selectedStatus.value == status ? 1.5 : 1,
          borderColor: _controller.selectedStatus.value == status ? AppColors.bfPrimaryColor : AppColors.textColor30,
          child: AppTextWidget(
            text,
            style: AppTextStyles.body2RegularTextStyle(
                fontWeight: FontWeight.w600, fontSize: 14, textColor: _controller.selectedStatus.value == status ? AppColors.bfPrimaryColor : AppColors.textColor40),
          ),
          onTap: () {
            _controller.selectedStatus.value = status;
            _controller.hitTripHistory(callBack: () {});
          },
        ),
      );
    });
  }

  _rideDetail(String text, String data, {Color? titleTextColor, Color? subtitleTextColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextWidget(
          text,
          style: AppTextStyles.body2RegularTextStyle(fontWeight: FontWeight.w500, fontSize: 14, textColor: titleTextColor ?? AppColors.textColor90),
        ),
        const SizedBox(width: 30),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: AppTextWidget(
              data,
              style: AppTextStyles.body2RegularTextStyle(fontWeight: FontWeight.w600, fontSize: 15, textColor: subtitleTextColor ?? AppColors.backColor30),
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }

  /// this dialog for cancel he ride by customer
  void showCancelRideDialog(int tripId) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextWidget(
                "Please give the reason for cancel ride !",
                style: AppTextStyles.body2RegularTextStyle(textColor: AppColors.backColor20, fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return SizedBox(
                  height: Get.height * 0.4,
                  child: ListView.builder(
                      itemCount: _controller.cancelRideModel.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AppContainer(
                            padding: const EdgeInsets.all(5),
                            allBorderRadius: 10,
                            borderColor: AppColors.textColor30,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AppTextWidget(
                                _controller.cancelRideModel[index].reason ?? '',
                                style: AppTextStyles.body2RegularTextStyle(
                                  textColor: AppColors.backColor30,
                                  fontSize: 14,
                                ),
                                onTap: () {
                                  _controller.selectedReason.value = _controller.cancelRideModel[index];
                                  _controller.hitCustomerCancelTripApi(
                                      tripId: tripId,
                                      callBack: () {
                                        Get.offAll(const HomeMapViewScreen());
                                      });
                                },
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }),
              AppContainer(
                height: 45,
                allBorderRadius: 10,
                color: AppColors.primaryColor10,
                child: AppTextWidget(
                  'Cancel',
                  style: AppTextStyles.body1RegularTextStyle(textColor: AppColors.dangerPrimaryColor, fontWeight: FontWeight.w400),
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
}

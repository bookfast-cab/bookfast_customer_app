import 'dart:io';
import 'package:bookfast_customer/controllers/search_drop_location_screen_controller.dart';
import 'package:bookfast_customer/ui/dialogs/common_alert_dialog.dart';
import 'package:bookfast_customer/ui/widgets/app_base_screen.dart';
import 'package:bookfast_customer/ui/widgets/app_button_widget.dart';
import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/ui/widgets/common_app_bar.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../../services/networking/api_constants.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_date_time_picker.dart';
import '../../utils/app_functions.dart';
import '../../utils/app_images.dart';
import '../widgets/app_common_widgets.dart';
import '../widgets/app_container_widget.dart';

class SearchDropLocationScreen extends StatefulWidget {
  const SearchDropLocationScreen({super.key});

  @override
  State<SearchDropLocationScreen> createState() => _SearchDropLocationScreenState();
}

class _SearchDropLocationScreenState extends State<SearchDropLocationScreen> {
  final SearchDropLocationController _controller = Get.find<SearchDropLocationController>();

  @override
  void initState() {
    if (_controller.pickAddressController.value.text.isEmpty) {
      _controller.getCurrentLocation(null);
    }
    /// Preselect Pickup DateTime (+25 min)
    if (_controller.onwardDateTime.value == null) {
      _controller.onwardDateTime.value =
          DateTime.now().add(const Duration(minutes: 25));
    }

    super.initState();
  }

  @override
  void dispose() {
    if (Get.isRegistered<SearchDropLocationController>()) {
      if (_controller.pickLocationFocusNode.hasFocus) {
        _controller.pickLocationFocusNode.unfocus();
      }
      if (_controller.dropLocationFocusNode.hasFocus) {
        _controller.dropLocationFocusNode.unfocus();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBaseScreen(
        child: Stack(
          children: [
            Column(
                  children: [
            CommonAppBar(
              titleText: AppStrings.strSearchYourLocation,
              isTitleCenter: false,
              titleTextColor: AppColors.textColor100,
              onBackPress: () {
                Get.back();
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Obx(() {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!_controller.isFromBookingScreen.value)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 8),
                                  const CircleAvatar(
                                    radius: 5,
                                    backgroundColor: Colors.green,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 2,
                                    color: Colors.grey,
                                  ),
                                  const CircleAvatar(
                                    radius: 5,
                                    backgroundColor: Colors.red,
                                  ),
                                ],
                              ),
                            if (!_controller.isFromBookingScreen.value) const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          // height: 42,
                                          child: GooglePlaceAutoCompleteTextField(
                                            containerHorizontalPadding: 10,
                                            containerVerticalPadding: 0,
                                            focusNode: _controller.pickLocationFocusNode,
                                            textEditingController: _controller.pickAddressController.value,
                                            boxDecoration: BoxDecoration(border: Border.all(color: AppColors.textColor30), borderRadius: BorderRadius.circular(10)),
                                            googleAPIKey: Platform.isIOS ? ApiConstants.mapIosKey : ApiConstants.mapAndroidKey,
                                            textStyle: const TextStyle(fontSize: 14),
                                            inputDecoration: const InputDecoration(
                                              hintText: "Enter Pick Address",
                                              hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: AppColors.textColor30,
                                                fontFamily: AppConstants.fontLexendRegular,
                                                textBaseline: TextBaseline.alphabetic,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            debounceTime: 800, // default 600 ms,
                                            // countries: ["in", "fr"], // optional by default null is set
                                            isLatLngRequired: true, // if you required coordinates from place detail
                                            getPlaceDetailWithLatLng: (Prediction prediction) {
                                              // this method will return latlng with place detail
                                              // print("placeDetails" + prediction.lng.toString());
                                            }, // this callback is called when isLatLngRequired is true
                                            itemClick: (Prediction prediction) async {
                                              /// Make user to add types=country|locality in google map places api in the plugin code. Line No. 111
                                              /// String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=${widget.googleAPIKey}&types=country|locality";
                                              // _controller.getCurrentLocation(prediction);
                                              // _controller.pickLocationFocusNode.unfocus();

                                              await _controller.onPickLocationSearchClick(prediction);
                                              await _controller.getCurrentLocation(prediction);
                                              _controller.pickLocationFocusNode.unfocus();
                                            },
                                            // if we want to make custom list item builder
                                            itemBuilder: (context, index, Prediction prediction) {
                                              return AppContainer(
                                                padding: const EdgeInsets.all(10),
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.location_on),
                                                    const SizedBox(
                                                      width: 7,
                                                    ),
                                                    Expanded(child: Text(prediction.description ?? ""))
                                                  ],
                                                ),
                                              );
                                            },
                                            // if you want to add seperator between list items
                                            // seperatedBuilder: Divider(),
                                            // want to show close icon
                                            isCrossBtnShown: true,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            _controller.getCurrentLocation(null);
                                          },
                                          child: const Icon(Icons.gps_fixed))
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (!_controller.isFromBookingScreen.value)
                                    SizedBox(
                                      // height: 42,
                                      child: GooglePlaceAutoCompleteTextField(
                                        containerHorizontalPadding: 10,
                                        containerVerticalPadding: 0,

                                        focusNode: _controller.dropLocationFocusNode,
                                        textEditingController: _controller.dropAddressController.value,
                                        boxDecoration: BoxDecoration(border: Border.all(color: AppColors.textColor30), borderRadius: BorderRadius.circular(10)),
                                        googleAPIKey: Platform.isIOS ? ApiConstants.mapIosKey : ApiConstants.mapAndroidKey,
                                        textStyle: const TextStyle(fontSize: 14),
                                        inputDecoration: const InputDecoration(
                                          hintText: "Enter Drop Address",
                                          hintStyle: TextStyle(
                                            fontSize: 14.0,
                                            color: AppColors.textColor30,
                                            fontFamily: AppConstants.fontLexendRegular,
                                            textBaseline: TextBaseline.alphabetic,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        debounceTime: 800, // default 600 ms,
                                        // countries: ["in", "fr"], // optional by default null is set
                                        isLatLngRequired: true, // if you required coordinates from place detail
                                        getPlaceDetailWithLatLng: (Prediction prediction) {
                                          // this method will return latlng with place detail
                                          // print("placeDetails" + prediction.lng.toString());
                                        }, // this callback is called when isLatLngRequired is true
                                        itemClick: (Prediction prediction) {
                                          /// Make user to add types=country|locality in google map places api in the plugin code. Line No. 111
                                          /// String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=${widget.googleAPIKey}&types=country|locality";
                                          _controller.onDropLocationSearchClick(prediction);
                                          _controller.dropLocationFocusNode.unfocus();
                                        },
                                        // if we want to make custom list item builder
                                        itemBuilder: (context, index, Prediction prediction) {
                                          return AppContainer(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.location_on),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Expanded(child: Text(prediction.description ?? ""))
                                              ],
                                            ),
                                          );
                                        },
                                        isCrossBtnShown: true,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AppTextWidget(
                                    "How do you want to travel?",
                                    style: AppTextStyles.body2RegularTextStyle(textColor: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(width: 6,),
                                  Image.asset(AppImages.icRoadTrip,height: 30,width: 30,color: AppColors.bfPrimaryColor,)
                                ],
                              ),
                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  _tripTypeCard(
                                    title: "One Way",
                                    icon: Icons.arrow_forward,
                                    isSelected: _controller.isOneWayTrip.value,
                                    onTap: _controller.selectOneWay,
                                  ),
                                  const SizedBox(width: 12),
                                  _tripTypeCard(
                                    title: "Round Trip",
                                    icon: Icons.swap_horiz,
                                    isSelected: !_controller.isOneWayTrip.value,
                                    onTap: _controller.selectRoundTrip,
                                  ),
                                ],
                              ),

                              /// Date time  round trip
                              if (!_controller.isOneWayTrip.value) ...[
                                const SizedBox(height: 10),
                                _dateTimeTile(
                                  title: "PickUp Date & Time",
                                  dateTime: _controller.onwardDateTime.value,
                                  onTap: () => _pickCustomDateTime(isReturn: false),
                                ),
                                const SizedBox(height: 6),
                                _dateTimeTile(
                                  title: "Return Date & Time",
                                  dateTime: _controller.returnDateTime.value,
                                  onTap: () => _pickCustomDateTime(isReturn: true),
                                ),
                              ],
                            ],
                          );
                        }),
                       /// Search button ////
                         const SizedBox(height: 20),
                        AppButton(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          onClick: (_controller.isFromBookingScreen.value || _controller.isDropLocationSelected.value)
                              ? () {
                                  if (!_controller.isFromBookingScreen.value) {
                                    /// ROUND TRIP VALIDATION
                                    if (!_controller.isOneWayTrip.value) {
                                      if (_controller.onwardDateTime.value == null ||
                                          _controller.returnDateTime.value == null) {
                                        AppCommonWidgets.showAppToast(
                                          "Please select pick up date & time and return date & time",
                                        );
                                        return;
                                      }
                                    }

                                    ///  normal flow
                                    validateLocations();
                                  } else {
                                    Get.back(result: true);
                                  }
                                }
                              : null,
                          title: _controller.isFromBookingScreen.value ? 'Done' : AppStrings.strSearch,
                          bgColor: (_controller.isFromBookingScreen.value || _controller.isDropLocationSelected.value) ? AppColors.bfPrimaryColor : AppColors.textColor30,
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
                  ],
                ),
          ],
        ));
  }

  void validateLocations() {
    if (_controller.pickAddressController.value.text.isEmpty && _controller.dropAddressController.value.text.isEmpty) {
      AppCommonWidgets.showAppToast("Pickup and Drop locations are required!");
    } else if (_controller.pickAddressController.value.text.isEmpty) {
      AppCommonWidgets.showAppToast("Pickup location is required!");
    } else if (_controller.dropAddressController.value.text.isEmpty) {
      AppCommonWidgets.showAppToast("Drop location is required!");
    } else {
      Get.back(result: true);
    }
  }
  Widget _tripTypeCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.bfPrimaryColor
                  : AppColors.textColor30,
              width: 1.4,
            ),
            color: isSelected
                ? AppColors.bfPrimaryColor.withOpacity(0.08)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextWidget(
                 title,
                style: AppTextStyles.body1RegularTextStyle(textColor: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 6),
              Icon(icon,
                  color: isSelected
                      ? AppColors.bfPrimaryColor
                      : Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateTimeTile({
    required String title,
    required DateTime? dateTime,
    required VoidCallback onTap,
  }) {
    final String ShowDateTimeText = dateTime != null
        ? "${title.contains("Return") ? "Return" : "PickUp"}: "
        "${AppFunctions.convertDateToYYYYMMDDHHMM(dateTime)}"
        : title ;


    final Color borderColor = dateTime == null
        ? Colors.grey.shade300
        : AppColors.bfPrimaryColor.withOpacity(0.5);

    final Color textColor = dateTime == null
        ? Colors.black
        : Colors.black;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: AppColors.bfPrimaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.calendar_month,
                size: 18,
                color: AppColors.bfPrimaryColor,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: AppTextWidget(
                ShowDateTimeText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body2RegularTextStyle(
                  textColor: textColor,
                 // fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }


  _pickCustomDateTime({required bool isReturn}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => CustomDateTimePicker(
        isReturn: isReturn,
        onwardDateTime: _controller.onwardDateTime.value,
        onConfirm: (selectedDateTime) {
          if (isReturn) {
            _controller.returnDateTime.value = selectedDateTime;
          } else {
            _controller.onwardDateTime.value = selectedDateTime;
            _controller.returnDateTime.value = null;
          }
        },
      ),
    );
  }



}

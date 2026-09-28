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
      _controller.onwardDateTime.value = DateTime.now().add(const Duration(minutes: 25));
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
      child: Container(
        color: AppColors.bfbackgroundColor, 
        child: Column(
          children: [
            CommonAppBar(
              titleText: AppStrings.strSearchYourLocation,
              isTitleCenter: false,
              titleTextColor: Colors.black87,
              onBackPress: () {
                Get.back();
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Obx(() {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location Input Card
                        Container(
                          padding: const EdgeInsets.all(16),
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!_controller.isFromBookingScreen.value)
                                Padding(
                                  padding: const EdgeInsets.only(top: 14),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.radio_button_checked, color: AppColors.bfprimarythemeColor2, size: 20),
                                      Container(
                                        height: 45,
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                      const Icon(Icons.location_on, color: Colors.red, size: 22),
                                    ],
                                  ),
                                ),
                              if (!_controller.isFromBookingScreen.value) const SizedBox(width: 12),
                              
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Pick Up Field
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GooglePlaceAutoCompleteTextField(
                                            containerHorizontalPadding: 0,
                                            containerVerticalPadding: 0,
                                            focusNode: _controller.pickLocationFocusNode,
                                            textEditingController: _controller.pickAddressController.value,
                                            boxDecoration: BoxDecoration(
                                              color: AppColors.bfbackgroundColor, // Subtle contrast inside the card
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: Colors.transparent),
                                            ),
                                            googleAPIKey: Platform.isIOS ? ApiConstants.mapIosKey : ApiConstants.mapAndroidKey,
                                            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                            inputDecoration: InputDecoration(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                              hintText: "Enter Pick Address",
                                              hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey.shade500,
                                                fontFamily: AppConstants.fontLexendRegular,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            debounceTime: 800,
                                            isLatLngRequired: true,
                                            getPlaceDetailWithLatLng: (Prediction prediction) {},
                                            itemClick: (Prediction prediction) async {
                                              await _controller.onPickLocationSearchClick(prediction);
                                              await _controller.getCurrentLocation(prediction);
                                              _controller.pickLocationFocusNode.unfocus();
                                            },
                                            itemBuilder: (context, index, Prediction prediction) {
                                              return Container(
                                                padding: const EdgeInsets.all(12),
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.location_on, color: Colors.grey, size: 20),
                                                    const SizedBox(width: 10),
                                                    Expanded(child: Text(prediction.description ?? "", style: const TextStyle(fontSize: 13))),
                                                  ],
                                                ),
                                              );
                                            },
                                            isCrossBtnShown: true,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            _controller.getCurrentLocation(null);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: AppColors.bfCardLightBlue,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Icon(Icons.my_location, color: AppColors.bfprimarythemeColor2, size: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    if (!_controller.isFromBookingScreen.value) const SizedBox(height: 12),
                                    
                                    // Drop Off Field
                                    if (!_controller.isFromBookingScreen.value)
                                      GooglePlaceAutoCompleteTextField(
                                        containerHorizontalPadding: 0,
                                        containerVerticalPadding: 0,
                                        focusNode: _controller.dropLocationFocusNode,
                                        textEditingController: _controller.dropAddressController.value,
                                        boxDecoration: BoxDecoration(
                                          color: AppColors.bfbackgroundColor,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.transparent),
                                        ),
                                        googleAPIKey: Platform.isIOS ? ApiConstants.mapIosKey : ApiConstants.mapAndroidKey,
                                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                        inputDecoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                          hintText: "Enter Drop Address",
                                          hintStyle: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey.shade500,
                                            fontFamily: AppConstants.fontLexendRegular,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        debounceTime: 800,
                                        isLatLngRequired: true,
                                        getPlaceDetailWithLatLng: (Prediction prediction) {},
                                        itemClick: (Prediction prediction) {
                                          _controller.onDropLocationSearchClick(prediction);
                                          _controller.dropLocationFocusNode.unfocus();
                                        },
                                        itemBuilder: (context, index, Prediction prediction) {
                                          return Container(
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.location_on, color: Colors.grey, size: 20),
                                                const SizedBox(width: 10),
                                                Expanded(child: Text(prediction.description ?? "", style: const TextStyle(fontSize: 13))),
                                              ],
                                            ),
                                          );
                                        },
                                        isCrossBtnShown: true,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),

                        // Travel Preferences Section
                        Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AppTextWidget(
                                    "How do you want to travel?",
                                    style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Image.asset(AppImages.icRoadTrip, height: 24, width: 24, color: AppColors.bfprimarythemeColor2),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // One Way vs Round Trip Toggle
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

                              // Date & Time Selectors for Round Trip
                              if (!_controller.isOneWayTrip.value) ...[
                                const SizedBox(height: 16),
                                _dateTimeTile(
                                  title: "PickUp Date & Time",
                                  dateTime: _controller.onwardDateTime.value,
                                  onTap: () => _pickCustomDateTime(isReturn: false),
                                ),
                                const SizedBox(height: 10),
                                _dateTimeTile(
                                  title: "Return Date & Time",
                                  dateTime: _controller.returnDateTime.value,
                                  onTap: () => _pickCustomDateTime(isReturn: true),
                                ),
                              ],
                            ],
                          );
                        }),
                        
                        const SizedBox(height: 32),

                        // Search Action Button
                        InkWell(
                          onTap: (_controller.isFromBookingScreen.value || _controller.isDropLocationSelected.value)
                              ? () {
                                  if (!_controller.isFromBookingScreen.value) {
                                    if (!_controller.isOneWayTrip.value) {
                                      if (_controller.onwardDateTime.value == null || _controller.returnDateTime.value == null) {
                                        AppCommonWidgets.showAppToast("Please select pick up date & time and return date & time");
                                        return;
                                      }
                                    }
                                    validateLocations();
                                  } else {
                                    Get.back(result: true);
                                  }
                                }
                              : null,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: (_controller.isFromBookingScreen.value || _controller.isDropLocationSelected.value) 
                                ? AppColors.bfprimarythemeColor2 
                                : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: (_controller.isFromBookingScreen.value || _controller.isDropLocationSelected.value) 
                                ? [BoxShadow(color: AppColors.bfprimarythemeColor2.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 5))]
                                : [],
                            ),
                            child: Text(
                              _controller.isFromBookingScreen.value ? 'Done' : AppStrings.strSearch,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
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
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.bfprimarythemeColor2 : Colors.grey.shade300,
              width: 1.5,
            ),
            color: isSelected ? AppColors.bfCardLightBlue : Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.bfprimarythemeColor2 : Colors.grey.shade700,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppColors.bfprimarythemeColor2 : Colors.grey.shade600,
              ),
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
    final String showDateTimeText = dateTime != null
        ? "${title.contains("Return") ? "Return" : "PickUp"}: "
        "${AppFunctions.convertDateToYYYYMMDDHHMM(dateTime)}"
        : title;

    final Color borderColor = dateTime == null ? Colors.grey.shade300 : AppColors.bfprimarythemeColor2.withOpacity(0.5);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.bfCardLightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_month,
                size: 20,
                color: AppColors.bfprimarythemeColor2,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                showDateTimeText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade400,
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
      backgroundColor: Colors.transparent, // In case custom picker has a wrapper
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cancel_ride_controller.dart';
import '../../models/cancell_ride_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../widgets/app_container_widget.dart';
import '../widgets/app_text_widget.dart';

class CancelRideDialog extends StatelessWidget {
  CancelRideDialog({super.key,
    required this.onCancelClick,
    required dynamic tripId
  }) : tripId = int.tryParse(tripId.toString()) ?? 0;
  Function(CancelRideData) onCancelClick;

  final int tripId;
  final controller = Get.put(CancelRideController());

  @override
  Widget build(BuildContext context) {
    controller.hitTripCancelReasonsApi(callBack: () {  });
    return Dialog(
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
                      itemCount: controller.cancelRideModel.length,
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
                                controller.cancelRideModel[index].reason ?? '',
                                style: AppTextStyles.body2RegularTextStyle(
                                  textColor: AppColors.backColor30,
                                  fontSize: 14,
                                ),
                                onTap: () {
                                  controller.selectedReason = controller.cancelRideModel[index];
                                  controller.hitCustomerCancelTripApi(callBack: () {
                                    onCancelClick(controller.cancelRideModel[index]);
                                  }, tripId: int.tryParse(tripId.toString()) ?? 0,);
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
        ));
  }
}

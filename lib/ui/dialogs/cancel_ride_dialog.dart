import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cancel_ride_controller.dart';
import '../../models/cancell_ride_model.dart';
import '../../utils/app_colors.dart';

class CancelRideDialog extends StatefulWidget {
  final Function(CancelRideData) onCancelClick;
  final int tripId;

  CancelRideDialog({
    super.key,
    required this.onCancelClick,
    required dynamic tripId,
  }) : tripId = int.tryParse(tripId.toString()) ?? 0;

  @override
  State<CancelRideDialog> createState() => _CancelRideDialogState();
}

class _CancelRideDialogState extends State<CancelRideDialog> {
  final CancelRideController controller = Get.put(CancelRideController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.hitTripCancelReasonsApi(callBack: () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Border radius कम किया
      backgroundColor: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding कम की
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              "Cancel Ride?",
              style: TextStyle(
                fontSize: 18, // Font size कम किया
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Select a reason to cancel", // Text को छोटा किया
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),

            // Dynamic List of Reasons
            Flexible(
              child: Obx(() {
                if (controller.cancelRideModel.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  );
                }
                
                return ListView.separated(
                  shrinkWrap: true, 
                  itemCount: controller.cancelRideModel.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8), // Gap कम किया
                  itemBuilder: (context, index) {
                    final reasonData = controller.cancelRideModel[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          controller.selectedReason = reasonData;
                          controller.hitCustomerCancelTripApi(
                            tripId: widget.tripId,
                            callBack: () {
                              widget.onCancelClick(reasonData);
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // List item padding कम की
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            reasonData.reason ?? '',
                            style: const TextStyle(
                              fontSize: 13, // List font size कम किया
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 16),

            // Dismiss Button (Keep Ride)
            SizedBox(
              width: double.infinity,
              height: 42, // Button height कम की
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.bfprimarythemeColor2.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'Keep Ride', // Button text छोटा किया
                  style: TextStyle(
                    color: AppColors.bfprimarythemeColor2,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
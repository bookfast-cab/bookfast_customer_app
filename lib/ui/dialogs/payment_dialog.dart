import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/booking_ride_screen_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';

class CommonPaymentDialogWidget extends StatelessWidget {
  final BookingRideScreenController controller;

  const CommonPaymentDialogWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "How would you like to pay?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 14),

            /// Cash Option
            GestureDetector(
              onTap: () {
                controller.paymentMethod.value = 0;
                Navigator.pop(context); // Optional if you want to clos
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: controller.paymentMethod.value == 0 ? AppColors.bfprimarythemeColor2 : Colors.grey.shade300,
                    width: 1.4,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.money, color: Colors.green),
                      const SizedBox(width: 12),
                      const Expanded(child: Text("Cash", style: TextStyle(fontSize: 13))),
                      Radio(
                        value: 0,
                        groupValue: controller.paymentMethod.value,
                        onChanged: (value) => controller.paymentMethod.value = value!,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {
                controller.paymentMethod.value = 1;
                Navigator.pop(context);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: controller.paymentMethod.value == 1 ? AppColors.bfprimarythemeColor2 : Colors.grey.shade300,
                    width: 1.4,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Image.asset(AppImages.icMobilePayment,color: Colors.green, height: 24, width: 22),
                      const SizedBox(width: 12),
                      const Expanded(child: Text("Online", style: TextStyle(fontSize: 13))),
                      Radio(
                        value: 1,
                        groupValue: controller.paymentMethod.value,
                        onChanged: (value) => controller.paymentMethod.value = value!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RentalDialog extends StatelessWidget {
  final RxInt selectedPackageIndex = 0.obs;
  final List<Map<String, dynamic>> packages = [
    {"title": "1 Hr / 10 Km", "price": 249},
    {"title": "2 Hr / 20 Km", "price": 399},
    {"title": "4 Hr / 40 Km", "price": 699},
    {"title": "8 Hr / 80 Km", "price": 999},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                "🚖 Rent a Cab",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Subtitle
            Text(
              "Select Package",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),

            // Packages List (No Wrap, clean vertical layout)
            Obx(() => Column(
              children: List.generate(packages.length, (index) {
                final isSelected = selectedPackageIndex.value == index;
                return GestureDetector(
                  onTap: () => selectedPackageIndex.value = index,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.shade50
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue
                            : Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          packages[index]['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.blue
                                : Colors.black87,
                          ),
                        ),
                        Text(
                          "₹${packages[index]['price']}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.blue
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            )),

            const SizedBox(height: 20),

            // Book Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Get.back(); // Close dialog
                  Get.snackbar(
                    "Success",
                    "Your rental booking started!",
                    backgroundColor: Colors.green.shade100,
                  );
                },
                child: const Text(
                  "Book Now",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

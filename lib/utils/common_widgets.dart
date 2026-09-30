import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_dimens.dart';

class CommonWidgets {
  static void snackBar(String message, {bool isError = true, bool removeAllPrevious = false}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (Get.overlayContext != null) {
          Get.snackbar(isError ? "Error" : "Message", message,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: isError ? Colors.red : AppColors.dangerPrimaryColor,
              colorText: Colors.white,
              margin: const EdgeInsets.only(bottom: AppDimensions.dmTen, left: AppDimensions.dmTen, right: AppDimensions.dmTen),
              icon: const Icon(Icons.error, color: Colors.white));
        } else {
          debugPrint("Snackbar skipped because overlayContext is null. Message: $message");
        }
      } catch (e) {
        debugPrint("Error showing snackbar: $e");
      }
    });
  }

  static void showSuccessToast(String title, String message) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (Get.overlayContext != null) {
          Get.snackbar(
            title,
            message,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.only(bottom: AppDimensions.dmTen, left: AppDimensions.dmTen, right: AppDimensions.dmTen),
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: const Icon(Icons.check_circle, color: Colors.white),
          );
        } else {
          debugPrint("Snackbar skipped because overlayContext is null. Message: $message");
        }
      } catch (e) {
        debugPrint("Error showing success toast: $e");
      }
    });
  }
}

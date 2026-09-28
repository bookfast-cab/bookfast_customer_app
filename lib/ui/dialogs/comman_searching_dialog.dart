import 'dart:convert';

import 'package:bookfast_customer/ui/widgets/app_text_widget.dart';
import 'package:bookfast_customer/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/ride_searching_controller.dart';
import '../../handlers/app_socket_handler.dart';
import '../../utils/app_colors.dart';
import '../screens/current_ride_detail.dart';
import '../widgets/app_button_widget.dart';

class CommonSearchingDialog extends StatefulWidget {
  final String? title;
  final String description;
  final Function onCancel;
  final bool barrierDismissible;
  final TextStyle? titleStyle;
  final TextStyle? descStyle;
  final TextStyle? cancelButtonTextStyle;
  final String cancelButtonText;
   Function() onRideAccepted;

   CommonSearchingDialog({
    super.key,
    this.title,
    required this.description,
    required this.onCancel,
    this.barrierDismissible = false,
    this.titleStyle,
    this.descStyle,
    this.cancelButtonTextStyle,
    this.cancelButtonText = "Cancel",
  required  this.onRideAccepted
  });

  @override
  State<CommonSearchingDialog> createState() => _CommonSearchingDialogState();
}

class _CommonSearchingDialogState extends State<CommonSearchingDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  final controller = Get.put(DriverFindScreenController());
  final AppSocketHandler _appSocketHandler = Get.put(AppSocketHandler());


  @override
  void initState() {
    super.initState();
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 1),
    // )..repeat(reverse: true);
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((d){

      _initSocket();

    });

  }


  void _initSocket() {
    print("Initializing customer socket...");
    _appSocketHandler.init(onConnect: () {
      print("Customer socket connected!");
      print("Socket ID: ${_appSocketHandler.socket.id}");

      _appSocketHandler.socket.onAny((event, data) {
        print('Received event: $event with data: $data');
      });

      _appSocketHandler.socket.on('rideAccepted', (data) {
        print("Full ride acceptance data: ${jsonEncode(data)}");
        if (mounted) {
          widget.onRideAccepted();
        }
      // widget. onRideAccepted();
      });

      _appSocketHandler.socket.on('noDriver', (data) {
        print("no driver found: ${jsonEncode(data)}");
        if (mounted) {
          Get.back();
          Get.back();
        }
        // Get.back();
        // Get.back();
      });
    });
  }
  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.barrierDismissible,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotationTransition(
                turns: Tween(begin: -0.01, end: 0.01).chain(CurveTween(curve: Curves.easeInOut)).animate(_rotationController),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Loader border
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),

                    // Blue circular background
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.2),
                      ),
                    ),

                    // Search Icon
                    const Icon(Icons.search, size: 56, color: Colors.blue),
                  ],
                ),
              ),

              // RotationTransition(
              //   turns: Tween(begin: -0.01, end: 0.01).chain(CurveTween(curve: Curves.easeInOut)).animate(_rotationController),
              //   child: Container(
              //     padding: const EdgeInsets.all(20),
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.blue.withOpacity(0.2),
              //     ),
              //     child: const Icon(Icons.search, size: 60, color: Colors.blue),
              //   ),
              // ),
              const SizedBox(height: 20),
              if (widget.title != null)
                Text(
                  widget.title!.tr,
                  style: widget.titleStyle ?? const TextStyle(fontSize: 18, color: AppColors.bfprimarythemeColor2),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 8),
              AppTextWidget(
                widget.description.tr,
                style: widget.descStyle ??  AppTextStyles.body2RegularTextStyle(fontSize: 16,textColor: AppColors.textColor90),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AppButton(
                title: 'Cancel',
                bgColor: AppColors.bfprimarythemeColor2,
                onClick: () {
                  widget.onCancel();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

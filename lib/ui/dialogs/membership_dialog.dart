import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class MemberShipDialog extends StatelessWidget {
  final String? title;
  final String description;
  final Function okCallback;
  final Function? cancelCallback;
  final String okButtonText;
  final String cancelButtonText;
  final bool showCancelButton;
  final TextStyle? titleStyle;
  final TextStyle? descStyle;
  final TextStyle? okButtonTextStyle;

  MemberShipDialog({
    Key? key,
    this.title,
    required this.description,
    required this.okCallback,
    this.cancelCallback,
    this.okButtonText = "OK",
    this.cancelButtonText = "Cancel",
    this.showCancelButton = false,
    this.titleStyle,
    this.descStyle,
    this.okButtonTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                if (title != null)
                  Text(
                    title!.tr,
                    style: titleStyle ??
                        const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 10),
                Text(
                  description.tr,
                  style: descStyle ?? const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (showCancelButton)
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (cancelCallback != null) cancelCallback!();
                          },
                          child: Text(
                            cancelButtonText.tr,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          okCallback();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bfprimarythemeColor2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          okButtonText.tr,
                          style: okButtonTextStyle ??
                              const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

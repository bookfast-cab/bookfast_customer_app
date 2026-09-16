import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookfast_customer/utils/app_dimens.dart';

class MediaChooseDialog extends StatefulWidget {
  MediaChooseDialog(
      {Key? key,/* required this.cameraCallBack, required this.galleryCallBack, required this.onCancelCallback*/})
      : super(key: key);
  //
  // Function() cameraCallBack;
  // Function() galleryCallBack;
  // Function() onCancelCallback;

  @override
  State<MediaChooseDialog> createState() => _MediaChooseDialogState();
}

class _MediaChooseDialogState extends State<MediaChooseDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.transparent),
      margin: EdgeInsets.only(
          right: Get.width * 0.050,
          left: Get.width * 0.050,
          bottom: Get.height * 0.020),
      height: Get.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white),
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    // widget.cameraCallBack();
                    Get.back(result: "camera");
                    print("under Camera");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Camera".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          // fontFamily: StringConstants.poppinsRegular,
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height * 0.018,
                          color: Colors.black),
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () async {
                    // widget.galleryCallBack();
                    Get.back(result: "gallery");

                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Gallery".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          // fontFamily: StringConstants.poppinsRegular,
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height * 0.018,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.transparent,
            width: Get.width,
            height: Get.height * 0.016,
          ),
          InkWell(
            onTap: () {
              // widget.onCancelCallback();
              Get.back();

            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(AppDimensions.dmFifteen)),
                  color: Colors.white),
              width: Get.width,
              height: Get.height * 0.070,
              child: Center(
                  child: Text(
                "Cancel".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    // fontFamily: StringConstants.poppinsRegular,
                    fontWeight: FontWeight.w600,
                    fontSize: Get.height * 0.018,
                    color: Colors.black),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

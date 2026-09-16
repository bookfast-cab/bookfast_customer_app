import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../ui/dialogs/common_alert_dialog.dart';

class AppPermissionsController extends GetxController {
  ImagePicker imagePicker = ImagePicker();

  init() {}

  void askAppPermission(context, {required Function(bool) callBack, required String type, required String description}) async {
    late PermissionStatus? status;
    if (type == "Camera") {
      status = await Permission.camera.request();
    } else if (type == "Gallery") {
      if (Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var release = androidInfo.version.release;
        // Android 9 (SDK 28), Xiaomi Redmi Note 7

        int id;
        if (release.contains(".")) {
          int idx = release.indexOf(".");
          release.substring(0, idx).trim();
          id = release.indexOf(".");
        } else {
          id = int.parse(release);
        }
        print("id---> $id");
        if (id < 13) {
          status = await Permission.storage.request();
        } else {
          callBack(true);
          return;
          // status = await Permission.photos.request();
          // status = await Permission.photos.request();
        }
      } else {
        // status = await Permission.storage.request();
        status = await Permission.photos.request();
      }
    } else if (type == "Location") {
      status = await Permission.location.request();
    }

    if (status != null) {
      if (status.isDenied) {
        print("status --> isDenied");
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
        //    print("Permission is denied.");
        if (type == "Camera") {
          status = await Permission.camera.request();
        } else if (type == "Gallery") {
          if (Platform.isAndroid) {
            var androidInfo = await DeviceInfoPlugin().androidInfo;
            var release = androidInfo.version.release;
            // Android 9 (SDK 28), Xiaomi Redmi Note 7

            int id;
            if (release.contains(".")) {
              int idx = release.indexOf(".");
              release.substring(0, idx).trim();
              id = release.indexOf(".");
            } else {
              id = int.parse(release);
            }
            if (id < 13) {
              status = await Permission.storage.request();
            } else {
              callBack(true);
              return;

              // status = await Permission. photos.request();
            }
          } else {
            // status = await Permission.storage.request();
            status = await Permission.photos.request();
          }
        } else if (type == "Location") {
          status = await Permission.location.request();
        }
      } else if (status.isGranted) {
        print("status --> isGranted");
        //permission is already granted.
        callBack(true);
        //  scrollController = widget.scrollController;
      } else if (status.isPermanentlyDenied) {
        print("status --> isPermanentlyDenied");

        //permission is permanently denied.
        // callBack(true);
        openAppSettingBox(context, description: description);
        //   print("Permission is permanently denied");
      } else if (status.isRestricted) {
        print("status --> isRestricted");
        //permission is OS restricted.
        // callBack(true);
        openAppSettingBox(context, description: description);
      } else {
        openAppSettingBox(context, description: description);

        print("status --> under else");
      }
    }
  }

  bool isShowing = false;
  bool isDialogShowing = false;

  void openAppSettingBox(context, {required String description}) {
    print("under --> openAppBox ${isDialogShowing}");
    if (isDialogShowing) {
      return;
    }
    isDialogShowing = true;
    showDialog(
        context: Get.overlayContext ?? context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CommonAlertDialog(
            description: description,
            title: "No access",
            okButtonText: 'Open Settings',
            showCancelButton: true,
            okCancelCallback: () {
              isDialogShowing = false;
            },
            okCallback: () {
              isDialogShowing = false;
              // Navigator.pop(context);
              openAppSettings();
            },
          );
        });
  }

  Future getStoragePermission(Function callBack) async {
    if (Platform.isIOS) {
      // PermissionStatus status = await Permission.storage.request();
      PermissionStatus status = await Permission.photos.request();
      if (status.isGranted) {
        return true;
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else if (status.isDenied) {
        print('Permission Denied');
      }
      callBack();
    } else {
      // final deviceInfo = DeviceInfoPlugin();
      //
      // final info = await deviceInfo.androidInfo;
      // print("version --> ${info.version.release ?? 'Unknown'}");
      //
      // print(" Platform.operatingSystemVersion --> ${Platform.operatingSystemVersion}");
      // PermissionStatus storageAccessPermission = await Permission.manageExternalStorage.status;
      PermissionStatus storagePermission = await Permission.storage.status;
      // PermissionStatus storagePermission = await Permission.photos.status;
      if (/*!storageAccessPermission.isGranted ||*/ !storagePermission.isGranted) {
        print("Platform.operatingSystemVersion --> ${Platform.operatingSystemVersion}");

        showDialog(
            context: Get.overlayContext!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CommonAlertDialog(
                description: "Storage permission is required for this app.",
                okCallback: () {
                  isDialogShowing = false;
                  // Navigator.pop(context);
                  openAppSettings();
                },
              );
            });
      }
    }
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled. Please enable the services
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are denied
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, we cannot request permissions.
      return false;
    }
    return true;
  }
}

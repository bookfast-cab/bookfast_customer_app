import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../ui/dialogs/media_choose_dialog.dart';
import '../utils/app_colors.dart';
import 'app_permission_controller.dart';

class MediaChooseController extends GetxController{
  ImagePicker imagePicker = ImagePicker();

  AppPermissionsController permissionsController = Get.put(AppPermissionsController());
  init() {}

  openChooseMediaSheet({
    required Function(String?) callBack,
    required String cameraDescription,
    required String galleryDescription,
  }) async {
    var result = await Get.bottomSheet(MediaChooseDialog(
      /*
      cameraCallBack: () {
        Get.back();

        openCamera(callBack: (file) {
          callBack(file);
        });
      },
      galleryCallBack: () {
        Get.back();
        openGallery(callBack: (file) {
          // Get.back();

          callBack(file);
        });
      },
      onCancelCallback: () {
        callBack(null);
        Get.back();
      },*/
    ));

    if (result == null) {
      callBack(null);
    } else if (result == "camera") {
      openCamera(
          description: cameraDescription,
          callBack: (file) {
            callBack(file);
          });
    } else if (result == "gallery") {
      openGallery(
          description: galleryDescription,
          callBack: (file) {
            // Get.back();

            callBack(file);
          });
    }
  }

  // cameraDescription: "To fully experience our app's features, we need access to your camera. Don't worry, we respect your privacy and will only use it to add image for profile and My Journal",
  // galleryDescription: "To fully experience our app's features, we need access to your gallery. Don't worry, we respect your privacy and will only use it to add image for profile and My Journal",

  openCamera({required Function(String?) callBack, required String description, bool isCropImage = false}) {
    permissionsController.askAppPermission(Get.overlayContext!, type: 'Camera', description: description, callBack: (v) async {
      handleCameraImage((path) {
        if (path != null) {
          if (isCropImage) {
            imageCropper(
                imagePath: path,
                croppedImage: (croppedImage) {
                  callBack(croppedImage);
                });
          } else {
            callBack(path);
          }
        } else {
          callBack(null);
        }
      });
      // Get.back();
    });
  }

  openGallery({required Function(String?) callBack, required String description}) {
    permissionsController.askAppPermission(Get.overlayContext!, type: 'Gallery', description: description, callBack: (v) async {
      handleGalleryImage((path) {
        if (path != null) {
          callBack(path);
        } else {
          callBack(null);
        }
      });
    });
  }

  openGalleryMultipleImages({required Function(List<String>?) callBack}) {
    permissionsController.askAppPermission(Get.overlayContext!, type: 'Gallery', description: 'Please allow storage access to add at least one image.'.tr, callBack: (v) async {
      handleGalleryMultpleImages((paths) {
        callBack(paths);
      });
    });
  }

  handleCameraImage(
      Function(String?) callBack,
      ) async {
    XFile? res = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 80);

    if (res != null) {
      // Get.to(AppCropImage(path: res.path))!.then((value) {
      //   if (res != null) {
      callBack(res.path);
      // }
      // });
    } else {
      // Get.back();
      callBack(null);
    }
  }

  handleGalleryImage(Function(String?) callBack) async {
    XFile? res = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (res != null) {
      // Get.to(AppCropImage(path: res.path))!.then((value) {
      // if (res != null) {
      callBack(res.path);
      // }
      // });
    } else {
      // Get.back();
      callBack(null);
    }
  }

  handleGalleryMultpleImages(Function(List<String>?) callBack) async {
    List<XFile>? res = await imagePicker.pickMultiImage(imageQuality: 80);

    if (res != null) {
      // Get.to(AppCropImage(path: res.path))!.then((value) {
      // if (res != null) {
      if (res.isNotEmpty) {
        List<String> resList = [];
        res.forEach((element) {
          resList.add(element.path);
        });
        callBack(resList);
      }

      // }
      // });
    } else {
      callBack(null);

      // Get.back();
    }
  }

  imageCropper({required String imagePath, required Function(String) croppedImage}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors.primaryColor100,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      croppedImage(croppedFile.path);
    } else {
      croppedImage(imagePath);
    }
  }


  /*imageCropper({required String imagePath, required Function(String) croppedImage}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors.primaryColor100,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        // WebUiSettings(
        //   context: context,
        // ),
      ],
    );

    croppedImage(croppedFile!.path);
  }*/
}
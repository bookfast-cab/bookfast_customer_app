import 'dart:convert';
import 'dart:io';
import 'package:bookfast_customer/controllers/media_choose_controller.dart';
import 'package:bookfast_customer/handlers/session_handler/session_manager.dart';
import 'package:bookfast_customer/models/get_profile_model.dart';
import 'package:bookfast_customer/models/login_model.dart';
import 'package:bookfast_customer/services/networking/api_constants.dart';
import 'package:bookfast_customer/services/networking/api_handler.dart';
import 'package:bookfast_customer/ui/dialogs/common_alert_dialog.dart';
import 'package:bookfast_customer/ui/widgets/app_common_widgets.dart';
import 'package:bookfast_customer/utils/app_functions.dart';
import 'package:bookfast_customer/utils/app_strings.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';

class ProfileScreenController extends GetxController{

  final MediaChooseController _mediaChooseController = Get.put(MediaChooseController());

  var loginModel = LoginModel().obs;
  var userData = UserModelData().obs;
  var profileData = ProfileData().obs;
  var isImageUpload = false.obs;
  var profilePicUrl = ''.obs;

  /// Update Profile
  var firstNameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var phoneNumberController = TextEditingController().obs;
  var genderController = TextEditingController().obs;
  var fileName = "".obs;

  Future<void> pickFile() async {
    _mediaChooseController.openChooseMediaSheet(
      callBack: (result) async {
        if (result != null) {
          profilePicUrl.value = result;
          fileName.value = result;
          final selectedFile = File(result);
          await hitUploadProfilePic(selectedFile);
          isImageUpload.value = true;
        }
      },
      cameraDescription: AppStrings.strCameraProfilePermissionMessage,
      galleryDescription: AppStrings.strGalleryProfilePermissionMessage,
    );
  }

  hitGetProfile({required Function() callBack}) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }

    var response = await ApiHandler().get(endPoint: ApiConstants.apiCustomerGetProfile);

    ProfileModel model = ProfileModel.fromJson(response);
    if (model.success == true) {
      if (model.data != null) {

        firstNameController.value.text = model.data?.firstName ?? '';
        lastNameController.value.text = model.data?.lastName ?? '';
        phoneNumberController.value.text = model.data?.phoneNumber ?? '';
        emailController.value.text = model.data?.email ?? '';
        genderController.value.text = model.data?.gender ?? '';
       // profilePicUrl.value = model.data?.profilePicture ?? '';
        profilePicUrl.value = AppFunctions.getImagePath(model.data?.profilePicture ?? '');


        callBack();
      }
    } else {
      if (loginModel.value.message != null) {
        AppFunctions.openDialog(CommonAlertDialog(description: loginModel.value.message!, okCallback: () {}));
        // AppCommonWidgets.showAppToast(loginModel.value.message!);
      }
    }
  }
  /// upload profile picture ///////////////////
  Future<void> hitUploadProfilePic(File file) async {
    if (!await AppFunctions.hasNetwork()) {
      AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
      return;
    }

    var formData = dio.FormData.fromMap({
      'image': await dio.MultipartFile.fromFile(file.path),
    });

    var response = await ApiHandler().multipartPost(
      endPoint: ApiConstants.apiCustomerUploadProfilePicture,
      formData: formData,
    );
    print('=======>$response');
    loginModel.value = LoginModel.fromJson(response);
    if (loginModel.value.success == true) {
      update();
      AppCommonWidgets.showAppToast(loginModel.value.message ?? "",);
    }
    else {
      AppCommonWidgets.showAppToast(loginModel.value.message ?? "",);
    }
  }
}
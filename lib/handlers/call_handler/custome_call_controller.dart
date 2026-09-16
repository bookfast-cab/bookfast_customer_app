// import 'package:bookfast_customer/models/app_base_model.dart';
// import 'package:bookfast_customer/utils/app_constants.dart';
// import 'package:bookfast_customer/utils/app_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:convert';
//
// import '../../models/calling_model.dart';
// import '../../models/coupon_list_model.dart';
// import '../../models/login_model.dart';
// import '../../services/networking/api_constants.dart';
// import '../../services/networking/api_handler.dart';
// import '../../ui/widgets/app_common_widgets.dart';
// import '../../utils/app_strings.dart';
// import 'custom_call_screen.dart';
//
// class CustomerCallController extends GetxController {
//   late RtcEngine _engine;
//   RxBool isInCall = false.obs;
//   // String token = "006abCDefghijkLmNoPqRstUvWxYz";
//
//   Future<void> startCall(
//   ) async {
//     // Step 1: Fetch token from backend
//     // final response = await http.get(Uri.parse(
//     //     "https://your-backend.com/generate_token?channel=$channelName&uid=$userId"));
//
//     // if (response.statusCode == 200) {
//     //   final data = jsonDecode(response.body);
//     //   token = data['token'];
//     // debugPrint("Token received: $token");
//     LoginModel? loginModel = await AppFunctions.getUserData();
//
//     await _getPermission();
//
//     // Step 2: Initialize Agora engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(appId: AppConstants.agoraAppId));
//     await _engine.enableAudio();
//
//     // Step 3: Set up event handlers
//     _engine.registerEventHandler(RtcEngineEventHandler(
//       onJoinChannelSuccess: (connection, elapsed) {
//         // debugPrint("Joined channel: $channelName");
//         isInCall.value = true;
//       },
//       onUserJoined: (connection, remoteUid, elapsed) {
//         debugPrint("User joined: $remoteUid");
//       },
//       onUserOffline: (connection, remoteUid, reason) {
//         debugPrint("User left: $remoteUid");
//       },
//     ));
//     hitCallToDriver(
//         callback: () async {
//           // // Step 4: Join the channel
//           // await _engine.joinChannel(
//           //   token: token,
//           //   channelId: channelName,
//           //   uid: 1000047,// loginModel!.data!.id!,
//           //   options: const ChannelMediaOptions(),
//           // );
//         });
//     // } else {
//     //   debugPrint("Failed to fetch token from backend");
//     // }
//   }
//
//   hitCallToDriver({ Function()? callback}) async {
//     if (!await AppFunctions.hasNetwork()) {
//       AppCommonWidgets.showAppToast(AppStrings.strNoInternet);
//       return;
//     }
//
//     var map = {"driver_id": 11275};
//     var response = await ApiHandler().post(endPoint: ApiConstants.apiCallToDriver, data: map, addAuthorization: true);
//     CallingModel model = CallingModel.fromJson(response);
//
//     if (model.success == true) {
//       // Step 4: Join the channel
//       await _engine.joinChannel(
//         token: model.data!.token!,
//         channelId: model.data!.channelName!,
//         uid: 1000047, // loginModel!.data!.id!,
//         options: const ChannelMediaOptions(),
//       );
//       Get.to(() => CustomerCallScreen(channelName: model.data!.channelName!));
//
//       if (callback != null) {
//         callback();
//       }
//     } else {
//       AppCommonWidgets.showAppToast("Failed to fetch data");
//     }
//   }
//
//   Future<void> endCall() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//     isInCall.value = false;
//   }
//
//   // Future<String?> _askingPermission() async {
//   //   final PermissionStatus permissionStatus =
//   //   await _getPhonePermission();
//   //   if (permissionStatus == PermissionStatus.granted){
//   //     //permission is granted
//   //   } else{
//   //     //permission denied or undermined
//   //   }
//   // }
//
//   Future<PermissionStatus> _getPermission() async {
//     final PermissionStatus permission = await Permission.microphone.status;
//     if (permission != PermissionStatus.granted) {
//       final Map<Permission, PermissionStatus> permissionStatus = await [Permission.microphone].request();
//       return permissionStatus[Permission.microphone] ?? PermissionStatus.denied;
//     } else {
//       return permission;
//     }
//   }
// }

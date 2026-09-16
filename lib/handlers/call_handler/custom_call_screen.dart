// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'custome_call_controller.dart';
//
// class CustomerCallScreen extends StatelessWidget {
//   final String channelName;
//   final CustomerCallController callController = Get.put(CustomerCallController());
//
//   CustomerCallScreen({super.key, required this.channelName});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Obx(() {
//         return SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(
//                     "https://cdn-icons-png.flaticon.com/512/1946/1946429.png"), // Driver avatar
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 "Calling Driver...",
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 callController.isInCall.value ? "In Call" : "Connecting...",
//                 style: const TextStyle(color: Colors.white70, fontSize: 16),
//               ),
//               const SizedBox(height: 40),
//
//               // Controls
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   FloatingActionButton(
//                     heroTag: "mute",
//                     backgroundColor: Colors.grey[800],
//                     onPressed: () {
//                       // TODO: callController.toggleMute()
//                     },
//                     child: const Icon(Icons.mic_off, color: Colors.white),
//                   ),
//                   const SizedBox(width: 40),
//                   FloatingActionButton(
//                     heroTag: "end",
//                     backgroundColor: Colors.red,
//                     onPressed: () async {
//                       await callController.endCall();
//                       Get.back(); // Close call screen
//                     },
//                     child: const Icon(Icons.call_end, color: Colors.white),
//                   ),
//                   const SizedBox(width: 40),
//                   FloatingActionButton(
//                     heroTag: "speaker",
//                     backgroundColor: Colors.grey[800],
//                     onPressed: () {
//                       // TODO: callController.toggleSpeaker()
//                     },
//                     child: const Icon(Icons.volume_up, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

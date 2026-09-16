// import 'dart:async';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class AppStreamController {
//   AppStreamController._internal();
//
//   static final AppStreamController _instance = AppStreamController._internal();
//
//   static AppStreamController get instance => _instance;
//
//   StreamController<bool> handleRefreshHomeScreen = StreamController.broadcast();
//
//   Stream get handleRefreshHomeAction => handleRefreshHomeScreen.stream;
//
//   void disposeHandleRefreshHomeScreenStream() => handleRefreshHomeScreen.close();
//
//   void rebuildHandleRefreshHomeScreenStream() {
//     if (handleRefreshHomeScreen.isClosed) {
//       handleRefreshHomeScreen = StreamController.broadcast();
//     }
//   }
//
//   StreamController<RemoteMessage> handleHomeScreenNotification = StreamController.broadcast();
//   Stream<RemoteMessage> get handleHomeScreenNotificationAction => handleHomeScreenNotification.stream;
//
//   void disposeHomeScreenNotificationStream() => handleHomeScreenNotification.close();
//
//   void rebuildHomeScreenNotificationStream() {
//     if (handleHomeScreenNotification.isClosed) {
//       handleHomeScreenNotification = StreamController.broadcast();
//     }
//   }
//
//   StreamController<Map> handleCountriesColors = StreamController.broadcast();
//   Stream<Map> get handleCountriesColorsAction => handleCountriesColors.stream;
//
//   void disposeHandleCountriesColorsAction() => handleCountriesColors.close();
//
//   void rebuildHandleCountriesColorsAction() {
//     if (handleCountriesColors.isClosed) {
//       handleCountriesColors = StreamController.broadcast();
//     }
//   }
// }

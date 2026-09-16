import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';


class FCMNotificationHandler {
  static late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static late AndroidNotificationChannel channel;

  static bool isFlutterLocalNotificationsInitialized = false;

  String? previousTitle;
  String? previousBody;
  Map<String, int> notificationCountMap = {}; // to maintain notification count for each user

  static init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (!kIsWeb) {
      await setupFlutterNotifications();
    }
    String? token;
    //debugPrint("Getting FCM Token ===> ");
    if (Platform.isAndroid) {
      token = await FirebaseMessaging.instance.getToken();
      // log("fcm token --> $token");
    } else {
      await Future<void>.delayed(
        const Duration(
          seconds: 3,
        ),
      );
      token = await FirebaseMessaging.instance.getToken();
      // log("apns token --> $token");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      //debugPrint("under notification --> main ${message.data}");

      // if (message.data['type'] == 'chat_message') {
        showFlutterNotification(message);

        // try {
        //   Get.put(HomeController()).hitEmployeeDashBoardData(callBack: (){});
        // }catch(e){
        //   print("e---> $e");
        // }


      // } else {
      //   debugPrint(" enter else");
        //
        // showFlutterNotification(message);
      // }

      //debugPrint('Handling a foreground message ${message.messageId}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // print("CheckData   ${message.data}");
      // print("CheckData 2  ${message}");
      // print("Check messageType 2 :::>  ${message.messageType}");
      // print("Check messageType 2 :::::>  ${message.notification}");
      // print("Check messageType 2 ::::::>  ${message.senderId}");

      return;
    });
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(/*options: DefaultFirebaseOptions.currentPlatform*/);

    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: false,
    //   badge: false,
    //   sound: false,
    // );
    // await setupFlutterNotifications();
    // showFlutterNotification(message);
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    //debugPrint('Handling a background message ${message.messageId}');
  }

  static Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission : true,
      requestSoundPermission : true,
      requestBadgePermission : true,
      // requestAlertPermission: false,
      // requestSoundPermission: false,
      // requestBadgePermission: false,
    );

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: null);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications',
        description: 'This channel is used for important notifications.', // description
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true);

    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
          .createNotificationChannel(channel);
    }

    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()!
          .initialize(initializationSettings.iOS!);
    }

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      // alert: Platform.isIOS ? false : true,
      // badge: Platform.isIOS ? false : true,
      // sound: Platform.isIOS ? false : true,
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  static void showFlutterNotification(RemoteMessage message) async {
    //debugPrint("notification title ${message.data}");
    //debugPrint("notification title ${message.notification!.title} ${message.notification!.body}");
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification == null) {
    if (notification!.title == null) {
      return;
    }
    }
    // if (notification.title == previousTitle && notification.body == previousBody) {
    //   // This notification is the same as the previous one, so don't show it again
    //   return;
    // }
    // previousTitle = notification.title;
    // previousBody = notification.body;
    //
    // String senderId = message.data['sender_id'];
    //
    // // Check if there is already a notification for this sender
    // if (notification.toString().isNotEmpty &&
    //     android.toString().isNotEmpty &&
    //     !kIsWeb) {
    //   // Check if notification count for this sender exists in notificationCountMap
    //   int count = notificationCountMap[message.data['sender_id']] ?? 0;
    //
    //   // Create the notification details
    //   NotificationDetails notificationDetails = NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       channel.id,
    //       channel.name,
    //       channel.description,
    //       icon: 'drawable/ic_notification',
    //       importance: Importance.max,
    //     ),
    //   );
    //
    //   // Show the notification only if the count is 0
    //   if (count == 0) {
    //     _flutterLocalNotificationsPlugin.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       notificationDetails,
    //     );
    //   }
    //
    //   // Increment the count for this sender in notificationCountMap
    //   notificationCountMap[message.data['sender_id']] = count + 1;
    // }

    if (notification.toString().isNotEmpty && android.toString().isNotEmpty && !kIsWeb) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'mipmap/ic_launcher',
              importance: Importance.max,
            ),
            iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true, presentBadge: true)),
      );
    }
    // else if(apple!=null){
    //   flutterLocalNotificationsPlugin.show(
    //     notification.hashCode,
    //     notification.title,
    //     notification.body,
    //     NotificationDetails(
    //    iOS: DarwinNotificationDetails()
    //     ),
    //
    //
    //   );
    // }
  }
}

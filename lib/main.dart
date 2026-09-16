import 'package:bookfast_customer/handlers/push_notification_handler.dart';
import 'package:bookfast_customer/ui/screens/auth_screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


bool isGlobalPaidUser = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if(Platform.isAndroid) {
    await Firebase.initializeApp();
    FCMNotificationHandler.init();
  // }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Bookfast',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: false,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
          ),
          // scaffoldBackgroundColor: Color(0xFF1B1B1B)
        ),
        debugShowCheckedModeBanner: false,
        home: MaterialApp(
          title: 'Bookfast',
          theme: ThemeData(
            useMaterial3: false,
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
            ),
          ),
          debugShowCheckedModeBanner: false,
         home:  const SplashScreen(),
        )
    );
  }
}


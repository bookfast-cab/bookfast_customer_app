
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'auth_screens/splash_screen.dart';

class BackgroundLocationPermissionScreen extends StatelessWidget {
  const BackgroundLocationPermissionScreen({super.key});

  Future<void> _requestPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();

    print("permission --> ${permission.toString()}");
    if (permission == LocationPermission.always || permission ==  LocationPermission.whileInUse) {
      Get.offAll(const SplashScreen());
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please allow background location to continue")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              "Enable Background Location",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Bookfast needs background location access so you can receive nearby ride requests even if the app is running in the background.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: (){
                _requestPermission(context);
                // Get.offAll(BottomNavScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                "Allow",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}

import 'package:bookfast_customer/controllers/splash_screen_controller.dart';
import 'package:bookfast_customer/ui/widgets/app_base_screen.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenController _controller = Get.put(SplashScreenController());
  @override
  void initState() {
    super.initState();

    _controller.inIt();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bfprimarythemeColor2,
      child: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: Scaffold(
            body: AppBaseScreen(
              child: Image.asset(AppImages.imgSplash,fit: BoxFit.cover,height: double.infinity,width: double.infinity,)),
        ),
      ),
    );
  }
}

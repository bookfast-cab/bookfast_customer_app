import 'dart:async';
import 'package:bookfast_customer/services/networking/api_constants.dart';
import 'package:bookfast_customer/services/networking/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../handlers/app_socket_handler.dart';

class BannerManagerController extends GetxController {
  static bool isalreadyShow = false;
  final AppSocketHandler appSocketHandler = Get.put(AppSocketHandler());
  

  Future<void> initSocket() async {
    await appSocketHandler.init(onConnect: () {
        print('socket connect for banner');

      appSocketHandler.socket.on('showBanner', (data) async {
        print('socket banner data $data');
        showBannerDialog(data); 
      });
    });
  }


  static Future<void> showBannerDialog(dynamic banner) async {
    if (isalreadyShow) {
      return;
    }
    isalreadyShow = true;

    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(  
            width: Get.width * 0.8,
            child: Stack(
              clipBehavior: Clip.none, 
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    banner['image_url'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                
                Positioned(
                  right: -10, 
                  top: -10, 
                  child: GestureDetector(
                    onTap: () async {
                      isalreadyShow = false;
                      logBannerView(banner['id']);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.close, color: Colors.black, size: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void logBannerView(dynamic bannerId) async {
    Map<String, dynamic> map = {"banner_id": bannerId};
    await ApiHandler().post(
      data: map,
      endPoint: ApiConstants.apiLogBannerView,
      addAuthorization: true,
      showLoader: false
    );
  }
}

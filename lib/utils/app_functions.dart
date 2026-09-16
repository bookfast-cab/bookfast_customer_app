import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:bookfast_customer/models/login_model.dart';
import 'package:bookfast_customer/services/networking/api_constants.dart';
import 'package:bookfast_customer/ui/screens/home_map_view_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' show get;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../handlers/session_handler/session_manager.dart';
import 'dart:io' as io;
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppFunctions {
  static String localStorageBasePath = "/storage/emulated/0/Android/media";

  static String? tempPath;
  static Random random = Random();

  static bool isValid(String? text) => text != null && text.isNotEmpty;

  static Future launchURL(String url, {bool externalApplication = true}) async {
    // await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
    // print(await canLaunchUrl(Uri.parse(url)));
    await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url), mode: externalApplication ? LaunchMode.externalApplication : LaunchMode.platformDefault)
        : throw 'Could not launch $url';
  }

  static Future<bool> checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<bool> hasNetwork() async {
    try {
      bool isConnected = true;
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        // I am connected to a mobile network.
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
      } else if (connectivityResult == ConnectivityResult.ethernet) {
        // I am connected to a ethernet network.
      } else if (connectivityResult == ConnectivityResult.vpn) {
        // I am connected to a vpn network.
        // Note for iOS and macOS:
        // There is no separate network interface type for [vpn].
        // It returns [other] on any device (also simulator)
      } else if (connectivityResult == ConnectivityResult.bluetooth) {
        // I am connected to a bluetooth.
      } else if (connectivityResult == ConnectivityResult.other) {
        // I am connected to a network which is not in the above mentioned networks.
      } else if (connectivityResult == ConnectivityResult.none) {
        // I am not connected to any network.
        isConnected = false;
      }

      return isConnected;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<bool> hasNetworkWifi() async {
    try {
      bool isConnected = false;
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        isConnected = false;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        isConnected = true;
      } else if (connectivityResult == ConnectivityResult.none) {
        isConnected = false;
      }

      return isConnected;
    } on SocketException catch (_) {
      return false;
    }
  }

  static int getDatesDifference({required DateTime? startDate, required DateTime? endDate}) {
    var difference = 0;

    if (startDate != null && endDate != null) {
      // final difference = endDate.difference(startDate).inDays + 1;
      if (endDate.isAfter(DateTime.now()) && startDate.isAfter(DateTime.now())) {
        difference = 0;
      } else if (endDate.isAfter(DateTime.now()) && startDate.isBefore(DateTime.now())) {
        difference = DateTime.now().difference(startDate).inDays + 1;
      } else {
        difference = endDate.difference(startDate).inDays + 1;
      }
      return difference;
    }
    if (startDate != null && endDate == null) {
      if (startDate.isAfter(DateTime.now())) {
        difference = 0;
      } else {
        difference = DateTime.now().difference(startDate).inDays + 1;
      }
      return difference;
    } else {
      return 0;
    }
  }

  static String getMMSSFromSecs(int secs) {
    int sec = secs % 60;
    int min = (secs / 60).floor();
    int hour = (secs / 3600).floor();
    String hours = hour.toString().length <= 1 ? "0$hour" : "$hour";
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return " $hours h :  $minute m ";
  }

  static String convertDateToYYYYMMDD(DateTime? date) {
    return date == null ? "" : DateFormat('yyyy-MM-dd').format(date.toLocal());
  }

  static String convertDateToDDMMMYYY(DateTime? date) {
    return date == null ? "" : DateFormat('dd MMM yyyy').format(date.toLocal());
  }

  static String convertDateToDD_MM_YYY(DateTime? date) {
    return date == null ? "" : DateFormat('dd - MM - yyyy').format(date.toLocal());
  }

  static String convertDateToDDMMMMYYY(DateTime? date) {
    return date == null ? "" : DateFormat('dd MMMM yyyy').format(date.toLocal());
  }

  static String getTripMonths({DateTime? startDate, DateTime? endDate}) {
    if (startDate != null && endDate != null) {
      String year = DateFormat('yyyy').format(startDate!.toLocal());
      String month1 = DateFormat('MMM').format(startDate.toLocal());
      String month2 = DateFormat('MMM').format(endDate!.toLocal());

      String monthValue = "";
      if (month1 == month2) {
        monthValue = month1;
      } else {
        monthValue = "${month1}-${month2}";
      }
      monthValue = "$monthValue $year";

      return monthValue;
    } else {
      if (startDate != null) {
        String year = DateFormat('yyyy').format(startDate.toLocal());
        String month1 = DateFormat('MMM').format(startDate.toLocal());

        return "$month1 $year";
      } else if (endDate != null) {
        String year = DateFormat('yyyy').format(endDate.toLocal());
        String month2 = DateFormat('MMM').format(endDate.toLocal());

        return "$month2 $year";
      } else {
        return "";
      }
    }
  }

  // static convertDateToYYYYMMDDHHMMSS(DateTime? date) {
  //   print("date   --> ${date.toString()}");
  //   return date == null ? "" : DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  // }
  static convertDateToYYYYMMDDHHMMSS(DateTime? date, {bool isLocal = false}) {
    print("date   --> ${date.toString()}");
    return date == null ? "" : DateFormat('yyyy-MM-dd HH:mm:ss').format(isLocal ? date.toLocal():date);
  }

  static String convertDateToYYYYMMDDHHMM(DateTime? date) {
    return date == null ? "" : DateFormat('MM/dd/yyyy hh:mm a').format(date.toLocal());
  }

  static String convertDateToYYYYMMDDHHMMAsItIs(DateTime? date) {
    if (date == null) return "";

    return DateFormat('MM/dd/yyyy hh:mm a').format(date);
  }


  static String convertDateToYYYYMMDDHHMM2(DateTime? date) {
    return date == null ? "" : DateFormat('MM/dd/yyyy hh:mm a').format(date);
  }

  static convertDateToHHMMSS(DateTime? date) {
    return date == null ? "" : DateFormat('hh:mm a').format(date.toLocal());
  }

  static String convertDate(DateTime? date) {
    return date == null ? "" : DateFormat('yyyy-MM-dd').format(date.toLocal());
  }

  static String convertHHMMSS(DateTime? date) {
    return date == null ? "" : DateFormat('HH:mm').format(date.toLocal());
  }


  static Future<dynamic> openDialog(Widget child, {bool barrierDismissible = false}) async {
    var data = await Get.dialog(child, barrierColor: Colors.black.withOpacity(0.3), barrierDismissible: barrierDismissible);
    return data;
  }

  static double getStatusBarPadding(context, {var extraPadding = 0}) {
    var height = MediaQuery.of(context).viewPadding.top;

    var topPadding = height;
    if (Platform.isAndroid) {
      topPadding = topPadding + extraPadding;
    }

    return topPadding;
  }

  static bool isEmailValid(String email) {
    print("email --> $email");
    String patttern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(patttern);
    if (!regExp.hasMatch(email)) {
      return false;
    }
    return true;
  }

  static bool validatePassword(String value) {
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  static String getEntryTitle(DateTime? tripDate, DateTime? entryDate) {
    String text = AppFunctions.convertDateToDDMMMMYYY(entryDate);
    if (tripDate != null && entryDate != null) {
      final difference = entryDate.difference(tripDate).inDays + 1;
      difference;
      // if(difference.isNegative){}

      text = "$text | Day ${difference.abs()}";
    }
    return text;
  }

  static Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  static Future<String?> getDeviceFCMToken() async {
    String? token;

    try {
      if (Platform.isAndroid) {
        token = await FirebaseMessaging.instance.getToken();
      } else {
        // token ="test_notification_token";
        token = await FirebaseMessaging.instance.getToken();
      }
    } catch (e) {
      // Handle the error
      print(e.toString());
    }


    return token;
  }

  static String getMonthName(int index) {
    if (index == 1) {
      return "January";
    } else if (index == 2) {
      return "February";
    } else if (index == 3) {
      return "March";
    } else if (index == 4) {
      return "April";
    } else if (index == 5) {
      return "May";
    } else if (index == 6) {
      return "June";
    } else if (index == 7) {
      return "July";
    } else if (index == 8) {
      return "August";
    } else if (index == 9) {
      return "September";
    } else if (index == 10) {
      return "October";
    } else if (index == 11) {
      return "November";
    } else {
      return "December";
    }
  }

  static String getImagePath(String? url) {
    if (url == null) {
      return "";
    } else {
      if (url.startsWith("http")) {
        return url;
      } else {
        return ApiConstants.imageBaseUrl + url;
      }
    }
  }

  static Future<LoginModel?> getUserData() async {
    String? strResponse = await SessionManager.getUserData();

    print("strResponse ----> $strResponse");

    if (strResponse != null && strResponse.isNotEmpty) {
      try {
        Map<String, dynamic> jsonMap = json.decode(strResponse);
        return LoginModel.fromJson(jsonMap);
      } catch (e) {
        print("JSON decode error: $e");
        return null;
      }
    } else {
      return null;
    }
  }



  static Future<String> getDeviceType() async {
    if (Platform.isIOS) {
      return "ios";
    } else if (Platform.isAndroid) {
      return "android";
    } else {
      return "ios";
    }
  }

  static Future<String> getOsVersion() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return info.version.release ?? 'Unknown';
    }
    if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return info.systemVersion ?? 'Unknown';
    }
    if (Platform.isMacOS) {
      final info = await deviceInfo.macOsInfo;
      return info.osRelease;
    }
    if (Platform.isLinux) {
      final info = await deviceInfo.linuxInfo;
      return info.version ?? 'Unknown';
    }
    return 'Unknown Version';
  }

  static String getTownName(String address) {
    if (address.isEmpty) {
      return "";
    } else {
      if (address.contains(",")) {
        var parts = address.split(',');
        var prefix = parts[0].trim(); // prefix: "date"
        // var date = parts.sublist(1).join(':').trim();
        return prefix;
      } else {
        return address;
      }
    }
  }

  static Future<String?> getUserId() async {
    try {
      String? strResponse = await SessionManager.getUserData();

      // print("strResponse ----> $strResponse");
      if (strResponse != null) {
        UserModelData? userDataModel = UserModelData.fromJson(json.decode(await SessionManager.getUserData() ?? ""));
        return userDataModel.phoneNumber;
        // return 1;
      }
    } catch (e) {
      return null;
    }
  }

  static convertImageToBase64(String path) {
    final bytes = io.File(path).readAsBytesSync();

    // //dev.log("image base 64 ${base64Encode(bytes)}");

    return base64Encode(bytes);
  }

  static Future<io.File> convertBase64ToImage(String base64File) async {
    Uint8List bytes = base64.decode(base64File);

    String dir = (await getApplicationDocumentsDirectory()).path;

    File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.png");
    await file.writeAsBytes(bytes);
/*
    img.Image? image = img.decodeImage(io.File(base64).readAsBytesSync());

    // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
    img.Image thumbnail = img.copyResize(image!, width: 300);

    tempPath ??= (await getTemporaryDirectory()).path;

    // Save the thumbnail as a PNG.
    io.File file = io.File('$tempPath/test${random.nextInt(100)}.png')..writeAsBytesSync(img.encodePng(thumbnail));
*/

    return file;
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String code = packageInfo.buildNumber;
    return version;
  }

  static Future<String> getDeviceInfoForEmail() async {
    String text = '';
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      text = "\n\nApp diagnostic"
          "\nDevice: Android";
      final info = await deviceInfo.androidInfo;
      text = "$text\nDevice version : ${info.version.release}";
    } else {
      text = "\n\nApp diagnostic"
          "\nDevice: IOS";
      final info = await deviceInfo.iosInfo;

      text = "$text\nDevice version : ${info.systemVersion ?? 'Unknown'}";
    }

    text = "$text\nApp Version: ${await getAppVersion()}";
    text = "$text\nUser Id: ${await getUserId()}";
    return text;
  }

  static Future<void> sendEmail({required String email, String subject = "", String body = ""}) async {
    String url = "mailto:$email?subject=$subject&body=${"$body${await getDeviceInfoForEmail()}"}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void shareFeedbackEmail({required String subject, required String body, File? file}) async {
    Uint8List? data;
    ByteBuffer? buffer;
    if (file != null) {
      // final box = context.findRenderObject() as RenderBox?;
      Uint8List data = file.readAsBytesSync();

      buffer = data.buffer;
    }
    await Share.shareXFiles(
      [
        if (file != null && data != null && buffer != null)
          XFile.fromData(
            buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
            name: '${file.path}',
            mimeType: 'image/png',
          ),
      ],
      text: body,
      subject: subject,
      // sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  static shareMyApp(String message) {
    Share.share(message);
  }

  static checkIfImageIsBase64(String imagePath) {
    List imageExtensions = ['.png', '.jpg', '.jpeg', '.HEIF', '.HEIC', '.heif', '.heic'];
    String imageExtension = imagePath.split('.').last;
    if (imageExtension.length == imagePath.length) {
      return true;
    } else
      return imageExtensions.contains(imageExtension);
  }

  Future<void> saveFile(String fileName) async {
    var file = File('');

    // Platform.isIOS comes from dart:io
    if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      file = File('${dir.path}/$fileName');
    } else if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        const downloadsFolderPath = '/storage/emulated/0/Download/';
        Directory dir = Directory(downloadsFolderPath);
        file = File('${dir.path}/$fileName');
      }
    }
  }

  static double getWidgetHeight(GlobalKey key) {
    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  static double stringToDouble(String? value) {
    if (value == null) {
      return 0.0;
    } else {
      if (value.isNotEmpty) {
        if (value != "null") {
          if (value.contains('.')) {
            return double.parse(value);
          } else {
            return double.parse((int.parse(value).toDouble()).toString());
          }
        } else {
          return 0.0;
        }
      } else {
        return 0.0;
      }
    }
  }

  static Future<File?> createLocalImage(String imagePath) async {
    File newFile = File(imagePath);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fileName = "$fileName.png";

    String? dirPath = await createDirectory();
    File storedFile = await newFile.copy('$dirPath/$fileName');
    return storedFile;
  }

  static Future<String?> createDirectory() async {
    if (Platform.isIOS) {
      Directory pathd = await getApplicationDocumentsDirectory();
      // Directory pathd = await getApplicationSupportDirectory();
      print("pathd --> $pathd");

      return pathd.path;
    } else {
      String folderName = "co.approach";
      io.Directory finalpath;

      String rootDir = "$localStorageBasePath/$folderName";

// Root directory
      finalpath = io.Directory(rootDir);
      if ((await finalpath.exists())) {
        print("exist");
      } else {
        print("not exist");
        var bool = await finalpath.create();
      }
      await createNomediaFile(finalpath.path);

      return finalpath.path;
    }
    // }
  }

  static Future<String?> downloadAndSaveImage(String url) async {
    try {
      String rawUrl;
      if (url.contains("https:/app")) {
        rawUrl = url.replaceAll("https:/app", "https://app");
      } else {
        rawUrl = url;
      }
      var response = await get(Uri.parse(rawUrl));

      String? dirPath = await createDirectory();

      File file2 = File("${dirPath}/${DateTime.now().millisecondsSinceEpoch}.png");
      file2.writeAsBytesSync(response.bodyBytes);

      print("under downloadAndSaveImage file2.path -->  ${file2.path}");
      return file2.path;
    } catch (e) {
      print("Under downloadAndSaveImage error $e");
      return null;
    }
  }

  static Future<void> createNomediaFile(String path) async {
    try {
      File nomediaFile = File('$path/.nomedia');

      if (await nomediaFile.exists()) {
        print('.nomedia file already exists.');
      } else {
        await nomediaFile.create();
        print('.nomedia file created successfully.');
      }
    } catch (e) {
      print('Failed to create .nomedia file: $e');
    }
  }

  static Widget checkLoginSignupNavigation(UserModelData userModelData) {
    Widget returnWidget;

    /*if (userModelData.phoneNumber == null) {
      returnWidget = SignUpNumberScreen();
    } else if (userModelData.email == null || userModelData.name == null) {
      returnWidget = SignupDetailsScreen();
    } else  */
    if (userModelData.phoneNumber == null) {
      // returnWidget = GenderSelectionScreen();
      returnWidget = HomeMapViewScreen();
      // returnWidget = WelcomeScreen();
    } else if (userModelData.email == null) {
      returnWidget = SizedBox();
      // returnWidget = BirthdaySelectionScreen();
    } else if (userModelData.id == null) {
      returnWidget = SizedBox();
      // returnWidget = AddProfilePhoto();
    } else if (userModelData.countryCode == null) {
      returnWidget = SizedBox();
      // returnWidget = SelectRadiusScreen();
    } else {
      returnWidget = SizedBox();

      // returnWidget = MainScreen();
    }

    return returnWidget;
  }

  bool isNewVersionAvailable(String current, String server) {
    List<int> currentParts =
    current.split('.').map((e) => int.parse(e)).toList();
    List<int> serverParts =
    server.split('.').map((e) => int.parse(e)).toList();

    int maxLength =
    currentParts.length > serverParts.length
        ? currentParts.length
        : serverParts.length;

    for (int i = 0; i < maxLength; i++) {
      int currentPart = i < currentParts.length ? currentParts[i] : 0;
      int serverPart = i < serverParts.length ? serverParts[i] : 0;

      if (serverPart > currentPart) return true;
      if (serverPart < currentPart) return false;
    }
    return false;
  }

}

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
     List<ConnectivityResult> result = await connectivity.checkConnectivity();
  //  ConnectivityResult result = await connectivity.checkConnectivity();
     _checkStatus(result.first);
   // _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
       _checkStatus(result.first);
     //   _checkStatus(result);
    });
  }

  // void _checkStatus(List<ConnectivityResult> result) async {
  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}

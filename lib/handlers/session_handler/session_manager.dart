import 'dart:convert';
import 'dart:developer';

import 'package:bookfast_customer/handlers/session_handler/session_constants.dart';
import 'package:bookfast_customer/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _sessionManager = SessionManager._internal();

  static String? currentTripsData;
  static String? currentCalendarTripsData;
  static String? currentUserData;
  static String? activeDoctorData;
  static int userVersionType = 0;

  factory SessionManager() {
    return _sessionManager;
  }

  SessionManager._internal();

  static final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  //  USER_DATA
  static Future<void> setUserData(String userData) async {
    setBool(SessionConstants.isLogin, true);
    currentUserData = userData;
    log("Under setUserData useData ${userData}");
    return _pref.then((value) => value.setString(SessionConstants.userData, userData));
  }

  static Future<String?> getUserData() async {
    if (currentUserData != null) {
      return currentUserData;
    } else {
      currentUserData = await _pref.then((value) => value.getString(SessionConstants.userData));
      return currentUserData;
    }
  }

  static Future<UserModelData?> getUserDataModel() async {
    if (currentUserData != null) {
      LoginModel? userDataModel = LoginModel.fromJson(json.decode(currentUserData!));
      return userDataModel.data;
    } else {
      currentUserData = await _pref.then((value) => value.getString(SessionConstants.userData));
      if (currentUserData == null) {
        return null;
      } else {
        LoginModel? userDataModel = LoginModel.fromJson(json.decode(currentUserData!));
        return userDataModel.data;
      }
    }
  }

  static Future<void> setHelplineNumber(String number) async {
    setString(SessionConstants.helplineNumber, number);
    log("Helpline number saved: $number");
  }

  static Future<String?> getHelplineNumber() async {
    return await getString(SessionConstants.helplineNumber);
  }

  // static void setTempToken(String stringValue) {
  //   _pref.then((value) => value.setString(SessionConstants.tempAuthToken, stringValue));
  // }

  static void setAuthToken(String stringValue) {
    _pref.then((value) => value.setString(SessionConstants.authToken, stringValue));
  }

  static Future<String?> getAuthToken() async {
    return await _pref.then((value) => value.getString(SessionConstants.authToken));
  }

  static void setDeviceToken(String stringValue) {
    _pref.then((value) => value.setString(SessionConstants.deviceToken, stringValue));
  }

  static Future<String?> getDeviceToken() async {
    return await _pref.then((value) => value.getString(SessionConstants.deviceToken));
  }

  static void setLocale(String locale) {
    // secureStorage.write(key: Strings.CURRENT_LOCALE, value: locale, aOptions: _getAndroidOptions(), iOptions: options);

    _pref.then((value) => value.setString(SessionConstants.currentLocal, locale));
  }

  static Future<String?> getLocale() {
    // return secureStorage.read(key: Strings.CURRENT_LOCALE, aOptions: _getAndroidOptions(), iOptions: options);

    return _pref.then((value) => value.getString(SessionConstants.currentLocal));
  }

  static void setBool(String key, bool boolValue) {
    _pref.then((value) => value.setBool(key, boolValue));
  }

  static Future<bool> getBool(String key) async {
    return await _pref.then((value) => value.getBool(key) ?? false);
  }

  static void setString(String key, String stringValue) {
    _pref.then((value) => value.setString(key, stringValue));
  }

  static Future<String?> getString(String key) async {
    return await _pref.then((value) => value.getString(key));
  }

  static void setInt(String key, int intValue) {
    _pref.then((value) => value.setInt(key, intValue));
  }

  static Future<int?> getInt(String key) async {
    return await _pref.then((value) => value.getInt(key));
  }

  static void setDouble(String key, double doubleValue) {
    _pref.then((value) => value.setDouble(key, doubleValue));
  }

  static Future<double?> getDouble(String key) async {
    return await _pref.then((value) => value.getDouble(key));
  }

  static resetData() {
    currentTripsData = null;
    currentCalendarTripsData = null;
    currentUserData = null;
    activeDoctorData = null;
    userVersionType = 0;
  }

  static clearSharedPrefs() async {
    resetData();
    // dbHelper.clearAllDbTable();

    /// Getting important Values
    bool rememberMe = await getBool(SessionConstants.isRememberMe);
    bool isIntroDone = await getBool(SessionConstants.isIntroDone);
    bool isTutorial1Done = await getBool(SessionConstants.isTutorial1Done);
    bool isTutorial2Done = await getBool(SessionConstants.isTutorial2Done);
    bool isTutorial3Done = await getBool(SessionConstants.isTutorial3Done);
    bool isTutorial4Done = await getBool(SessionConstants.isTutorial4Done);
    bool isTutorial5Done = await getBool(SessionConstants.isTutorial5Done);
    bool isTutorialAllDone = await getBool(SessionConstants.isTutorialAllDone);

    String? rememberCoEmail = await getString(SessionConstants.rememberCoEmail) ?? "";
    String? rememberCoPassword = await getString(SessionConstants.rememberCoPassword) ?? "";

    String? rememberExEmail = await getString(SessionConstants.rememberExEmail) ?? "";
    String? rememberExPassword = await getString(SessionConstants.rememberExPassword) ?? "";

    /// Clearing Shared Preferences
    _pref.then((value) => {value.clear()});

    /// Setting important values
    setBool(SessionConstants.isIntroDone, isIntroDone);
    setBool(SessionConstants.isRememberMe, rememberMe);
    setString(SessionConstants.rememberCoEmail, rememberCoEmail);
    setString(SessionConstants.rememberCoPassword, rememberCoPassword);
    setString(SessionConstants.rememberExEmail, rememberExEmail);
    setString(SessionConstants.rememberExPassword, rememberExPassword);
    setBool(SessionConstants.isTutorial1Done, isTutorial1Done);
    setBool(SessionConstants.isTutorial2Done, isTutorial2Done);
    setBool(SessionConstants.isTutorial3Done, isTutorial3Done);
    setBool(SessionConstants.isTutorial4Done, isTutorial4Done);
    setBool(SessionConstants.isTutorial5Done, isTutorial5Done);
    setBool(SessionConstants.isTutorialAllDone, isTutorialAllDone);
  }
}

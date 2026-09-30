import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:bookfast_customer/utils/app_loader_dialog.dart';
import 'package:bookfast_customer/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_lib;
import '../../handlers/session_handler/session_manager.dart';

import '../../ui/dialogs/common_alert_dialog.dart';
import '../../ui/screens/auth_screens/phone_number_screen.dart';
import '../../utils/app_functions.dart';
import '../../utils/app_strings.dart';
import 'logging_interceptor.dart';

class ApiHandler {
  static ApiHandler apiProvider = ApiHandler();
  static BaseOptions options = BaseOptions(receiveTimeout: const Duration(seconds: 180), connectTimeout: const Duration(seconds: 180));
  final Dio _dio = Dio(options);

  ApiProvider() {
    _dio.interceptors.add(LoggingInterceptor());
    // remove this after ssl certificate expiration issue is resolved
    /* (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;
      return client;
    };*/
  }

  Future<dynamic> post(
      {required String endPoint,
      Map<String, dynamic>? data,
      bool addAuthorization = true,
      bool showLoader = true,
      bool showErrorMessage = true}) async {
    if (showLoader) {
      AppLoaderDialog.showLoadingDialog();
    }
    try {
      Map<String, dynamic> headers = {
        "my-deviceos": Platform.isIOS ? "ios" : "android",

      };

      if (addAuthorization) {
        String? token = await SessionManager.getAuthToken();
        if ((token ?? "").isNotEmpty) {
          headers['Authorization'] = "Bearer $token";
        }
      }

      var headerOptions = Options(contentType: Headers.jsonContentType, headers: headers);

      printLog("api:-   $endPoint map $data $headers");
      Response response = await _dio.post(endPoint, data: data, options: headerOptions);
      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }
      printLog("api_url:-   ${response.data}");

      /*if (response.data['token'] != null) {
        // Save the token in SharedPreferences using SessionManager
        SessionManager.setAuthToken(response.data['token']);
        log("Token saved: ${response.data['token']}");
      }*/

      return response.data;
    } /*on DioException catch (ex) {
      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }
      if (ex.response != null) {
        if (ex.response!.statusCode == 401) {
          if (ex.response!.data != null) {
            return ex.response!.data;
          }
        }
      }

      print("under dio error ${ex.message}");
      // print("under dio error ${ex.message}");
      print("under dio error ${ex.error}");
      print("under dio error ${ex.response!.statusCode}");
      print("under dio error ${ex.response!.data}");

      CommonWidgets.snackBar(ex.toString(), isError: true);

      return {"success": 0, "message": "Something went wrong"};

      // var model = checkDioError(ex);
      // return model;
    } */
    catch (error, stacktrace) {
      print("under post request catch error ${error}");

      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }

      if (error is DioError) {
        if (showLoader) {
          AppLoaderDialog.hideLoadingDialog();
        }
        if (error.response != null) {
          if (error.response!.statusCode == 401 || error.response!.statusCode == 403) {
            showSessionExpiredDialog();
            return {"success": 0, "message": "Something went wrong"};
          } else if (error.response!.statusCode == 400 || error.response!.statusCode == 404 || error.response!.statusCode == 500) {
            if (error.response!.data != null) {
              return error.response!.data;
            }
          }
        }
      }

      if (showErrorMessage) {
        CommonWidgets.snackBar("Something went wrong. Please check your internet connection.", isError: true);
        // CommonWidgets.snackBar("$endPoint\n" + error.toString(), isError: true);
      }
      return {"success": 0, "message": "Something went wrong"};

      // var model = ApiErrorModel.fromJson((error as dynamic).response.data);
      // return model;
    }
  }

  Future<dynamic> multipartPost({
    required String endPoint,
    required FormData formData,
    bool addAuthorization = true,
    bool showLoader = true,
    bool showErrorMessage = true,
    /*required Options options*/
  }) async {
    if (showLoader) {
      AppLoaderDialog.showLoadingDialog();
    }
    try {
      Map<String, dynamic> headers = {
        "Content-Type": "multipart/form-data",
        "my-deviceos": Platform.isIOS ? "ios" : "android",

      };

      if (addAuthorization) {
        String? token = await SessionManager.getAuthToken();
        if ((token ?? "").isNotEmpty) {
          headers['Authorization'] = "Bearer $token";
        }
      }

      var headerOptions = Options(contentType: "multipart/form-data", headers: headers);

      printLog("api_url:-   ${endPoint} ${formData.fields}${formData.files} headers $headers");

      Response response = await _dio.post(endPoint, data: formData, options: headerOptions);
      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }
      printLog("api_url:-   ${response.data}");

      return response.data;
    } /*on DioException catch (ex) {
      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }
      if (ex.response != null) {
        if (ex.response!.statusCode == 401) {
          if (ex.response!.data != null) {
            return ex.response!.data;
          }
        }
      }

      print("under dio error ${ex.message}");
      // print("under dio error ${ex.message}");
      print("under dio error ${ex.error}");
      print("under dio error ${ex.response!.statusCode}");
      print("under dio error ${ex.response!.data}");

      CommonWidgets.snackBar(ex.toString(), isError: true);

      return {"success": 0, "message": "Something went wrong"};

      // var model = checkDioError(ex);
      // return model;
    } */
    catch (error, stacktrace) {
      print("under multipartPost request catch error ${error}");

      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }

      if (error is DioError) {
        if (showLoader) {
          AppLoaderDialog.hideLoadingDialog();
        }
        if (error.response != null) {
          if (error.response!.statusCode == 401 || error.response!.statusCode == 403) {
            showSessionExpiredDialog();
            return {"success": 0, "message": "Something went wrong"};
          } else if (error.response!.statusCode == 400 || error.response!.statusCode == 404 || error.response!.statusCode == 500) {
            if (error.response!.data != null) {
              return error.response!.data;
            }
          }
        }
      }
      if (showErrorMessage) {
        CommonWidgets.snackBar("Something went wrong. Please check your internet connection.", isError: true);

        // CommonWidgets.snackBar("$endPoint\n" + error.toString(), isError: true);
      }
      return {"success": 0, "message": "Something went wrong"};

      // var model = ApiErrorModel.fromJson((error as dynamic).response.data);
      // return model;
    }
  }

  Future<dynamic> multipartPut(
      {required String endPoint,
      required FormData formData,
      bool addAuthorization = true,
      bool showLoader = true,
      bool showErrorMessage = true,
      required Options options}) async {
    if (showLoader) {
      AppLoaderDialog.showLoadingDialog();
    }
    try {
      Map<String, dynamic> headers = {
        "Content-Type": "multipart/form-data",
        "my-deviceos": Platform.isIOS ? "ios" : "android",

      };

      if (addAuthorization) {
        String? token = await SessionManager.getAuthToken();
        if ((token ?? "").isNotEmpty) {
          headers['Authorization'] = "Bearer $token";
        }
      }

      var headerOptions = Options(contentType: "multipart/form-data", headers: headers);

      printLog("api_url:-   ${endPoint} ${formData.fields}${formData.files} headers $headers");

      Response response = await _dio.put(endPoint, data: formData, options: headerOptions);
      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }
      printLog("api_url:-   ${response.data}");

      return response.data;
    } /*on DioException catch (ex) {
      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }
      if (ex.response != null) {
        if (ex.response!.statusCode == 401) {
          if (ex.response!.data != null) {
            return ex.response!.data;
          }
        }
      }

      print("under dio error ${ex.message}");
      // print("under dio error ${ex.message}");
      print("under dio error ${ex.error}");
      print("under dio error ${ex.response!.statusCode}");
      print("under dio error ${ex.response!.data}");

      CommonWidgets.snackBar(ex.toString(), isError: true);

      return {"success": 0, "message": "Something went wrong"};

      // var model = checkDioError(ex);
      // return model;
    } */
    catch (error, stacktrace) {
      print("under multipartPost request catch error ${error}");

      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }

      if (error is DioError) {
        if (showLoader) {
          AppLoaderDialog.hideLoadingDialog();
        }
        if (error.response != null) {
          if (error.response!.statusCode == 401 || error.response!.statusCode == 403) {
            showSessionExpiredDialog();
            return {"success": 0, "message": "Something went wrong"};
          } else if (error.response!.statusCode == 400 || error.response!.statusCode == 404 || error.response!.statusCode == 500) {
            if (error.response!.data != null) {
              return error.response!.data;
            }
          }
        }
      }
      if (showErrorMessage) {
        CommonWidgets.snackBar("Something went wrong. Please check your internet connection.", isError: true);

        // CommonWidgets.snackBar("$endPoint\n" + error.toString(), isError: true);
      }
      return {"success": 0, "message": "Something went wrong"};

      // var model = ApiErrorModel.fromJson((error as dynamic).response.data);
      // return model;
    }
  }

  Future<dynamic> get({
    required String endPoint,
    bool addAuthorization = true,
    bool showLoader = true,
    bool showErrorMessage = true,
  }) async {
    if (showLoader) {
      AppLoaderDialog.showLoadingDialog();
    }
    try {
      Map<String, dynamic> headers = {
        "my-deviceos": Platform.isIOS ? "ios" : "android",
      };
      if (addAuthorization) {
        String? token = await SessionManager.getAuthToken();
        if ((token ?? "").isNotEmpty) {
          headers['Authorization'] = "Bearer $token";
        }
      }

      var headerOptions = Options(contentType: Headers.jsonContentType, headers: headers);

      printLog("api_url:-   $endPoint  headers $headers");
      Response response = await _dio.get(endPoint, options: headerOptions);
      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }

      printLog("api_url:-   ${response.data}");

      return response.data;
    } /* on DioException catch (ex) {
      print("under dio error ${ex.message}");
      print("under catch error ${ex}");

      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }

      if (ex.response != null) {
        if (ex.response!.statusCode == 401) {
          if (ex.response!.data != null) {
            return ex.response!.data;
          }
        }
      }
      CommonWidgets.snackBar(ex.toString(), isError: true);

      return {"success": 0, "message": "Something went wrong"};

      // var model = checkDioError(ex);
      // return model;
    } */
    catch (error, stacktrace) {
      print("under catch error ${error}");

      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }

      if (error is DioError) {
        if (showLoader) {
          AppLoaderDialog.hideLoadingDialog();
        }
        if (error.response != null) {
          if (error.response!.statusCode == 401 || error.response!.statusCode == 403) {
            showSessionExpiredDialog();
            return {"success": 0, "message": "Something went wrong"};
          } else if (error.response!.statusCode == 400 || error.response!.statusCode == 404 || error.response!.statusCode == 500) {
            if (error.response!.data != null) {
              return error.response!.data;
            }
          }
        }
      }

      if (showErrorMessage) {
        CommonWidgets.snackBar("Something went wrong. Please check your internet connection.", isError: true);

        // CommonWidgets.snackBar("$endPoint\n" + error.toString(), isError: true);
      }
      return {"success": 0, "message": "Something went wrong"};

      // var model = ApiErrorModel.fromJson((error as dynamic).response.data);
      // return model;
    }
  }

  Future<dynamic> put(
      {required String endPoint,
      Map<String, dynamic>? data,
      bool addAuthorization = true,
      bool showLoader = true,
      bool showErrorMessage = true}) async {
    if (showLoader) {
      AppLoaderDialog.showLoadingDialog();
    }
    try {
      Map<String, dynamic> headers = {
        "my-deviceos": Platform.isIOS ? "ios" : "android",

      };

      if (addAuthorization) {
        String? token = await SessionManager.getAuthToken();
        if ((token ?? "").isNotEmpty) {
          headers['Authorization'] = "Bearer $token";
        }
      }

      var headerOptions = Options(contentType: Headers.jsonContentType, headers: headers);

      printLog("api:-   $endPoint map $data $headers");
      Response response = await _dio.put(endPoint, data: data, options: headerOptions);
      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }
      printLog("api_url:-   ${response.data}");

      return response.data;
    } /*on DioException catch (ex) {
      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }
      if (ex.response != null) {
        if (ex.response!.statusCode == 401) {
          if (ex.response!.data != null) {
            return ex.response!.data;
          }
        }
      }

      print("under dio error ${ex.message}");
      // print("under dio error ${ex.message}");
      print("under dio error ${ex.error}");
      print("under dio error ${ex.response!.statusCode}");
      print("under dio error ${ex.response!.data}");

      CommonWidgets.snackBar(ex.toString(), isError: true);

      return {"success": 0, "message": "Something went wrong"};

      // var model = checkDioError(ex);
      // return model;
    } */
    catch (error, stacktrace) {
      print("under post request catch error ${error}");

      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }

      if (error is DioError) {
        if (showLoader) {
          AppLoaderDialog.hideLoadingDialog();
        }
        if (error.response != null) {
          if (error.response!.statusCode == 401 || error.response!.statusCode == 403) {
            showSessionExpiredDialog();
            return {"success": 0, "message": "Something went wrong"};
          } else if (error.response!.statusCode == 400 || error.response!.statusCode == 404 || error.response!.statusCode == 500) {
            if (error.response!.data != null) {
              return error.response!.data;
            }
          }
        }
      }

      if (showErrorMessage) {
        CommonWidgets.snackBar("Something went wrong. Please check your internet connection.", isError: true);
        // CommonWidgets.snackBar("$endPoint\n" + error.toString(), isError: true);
      }
      return {"success": 0, "message": "Something went wrong"};

      // var model = ApiErrorModel.fromJson((error as dynamic).response.data);
      // return model;
    }
  }

  Future<dynamic> delete({
    required String endPoint,
    bool addAuthorization = true,
    bool showLoader = true,
    bool showErrorMessage = true,
  }) async {
    if (showLoader) {
      AppLoaderDialog.showLoadingDialog();
    }
    try {
      Map<String, dynamic> headers = {
        "my-deviceos": Platform.isIOS ? "ios" : "android",

      };
      if (addAuthorization) {
        String? token = await SessionManager.getAuthToken();
        if ((token ?? "").isNotEmpty) {
          headers['Authorization'] = "Bearer $token";
        }
      }
      var headerOptions = Options(
        contentType: Headers.jsonContentType,
        headers: headers,
      );

      printLog("api_url:-   $endPoint  headers $headers");
      Response response = await _dio.delete(endPoint, options: headerOptions);
      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }

      printLog("api_url:- ${response.data}");

      return response.data;
    } catch (error, stacktrace) {
      print("under delete request catch error ${error}");

      if (showLoader) {
        AppLoaderDialog.hideLoadingDialog();
      }

      if (error is DioError) {
        if (showLoader) {
          AppLoaderDialog.hideLoadingDialog();
        }
        if (error.response != null) {
          if (error.response!.statusCode == 401 || error.response!.statusCode == 403) {
            showSessionExpiredDialog();
            return {"success": 0, "message": "Something went wrong"};
          } else if (error.response!.statusCode == 400 || error.response!.statusCode == 404 || error.response!.statusCode == 500) {
            if (error.response!.data != null) {
              return error.response!.data;
            }
          }
        }
      }

      if (showErrorMessage) {
        CommonWidgets.snackBar("Something went wrong. Please check your internet connection.", isError: true);
      }
      return {"success": 0, "message": "Something went wrong"};
    }
  }

  void showSessionExpiredDialog() {
    AppFunctions.openDialog(
        CommonAlertDialog(
            description: AppStrings.strSessionExpiredLoginAgain,
            barrierDismissible:false,
            okButtonText: AppStrings.strLogin,
            okCallback: () {
              navigateToLogin();
            }),
        barrierDismissible: false);
  }

  static navigateToLogin() {
    SessionManager.clearSharedPrefs();
    Navigator.pushAndRemoveUntil(
        get_lib.Get.overlayContext!, MaterialPageRoute(builder: (BuildContext context) => const PhoneNumberScreen()), (route) => false);
  }

  printLog(String value) {
     // print(value);
     log(value);
  }
}

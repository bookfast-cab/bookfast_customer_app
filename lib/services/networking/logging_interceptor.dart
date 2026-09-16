import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class LoggingInterceptor extends Interceptor {
  int _maxCharactersPerLine = 200;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handle) {
    // //debugPrint("--> ${options.method} ${options.path}");
    // //debugPrint("Content type: ${options.contentType}");
    //debugPrint("DATA: ${options.data.toString()}");
    //
    //debugPrint("<-- END HTTP");
    return super.onRequest(options, handle);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // print("<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");
    String responseAsString = response.data.toString();
    if (responseAsString.length > _maxCharactersPerLine) {
      int iterations =
          (responseAsString.length / _maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * _maxCharactersPerLine + _maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        // //debugPrint(
        //   responseAsString.substring(i * _maxCharactersPerLine, endingIndex));
      }
    } else {
      print(response.data);
    }
    ////print("<-- END HTTP");

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("<-- Error -->");
    print(err.error);
    print(err.message);
    return super.onError(err, handler);
  }
}

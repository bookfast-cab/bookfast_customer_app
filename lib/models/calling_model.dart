// To parse this JSON data, do
//
//     final callingModel = callingModelFromJson(jsonString);

import 'dart:convert';

CallingModel callingModelFromJson(String str) => CallingModel.fromJson(json.decode(str));

String callingModelToJson(CallingModel data) => json.encode(data.toJson());

class CallingModel {
  bool? success;
  String? message;
  CallingModelData? data;

  CallingModel({
    this.success,
    this.message,
    this.data,
  });

  factory CallingModel.fromJson(Map<String, dynamic> json) => CallingModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : CallingModelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class CallingModelData {
  String? channelName;
  String? token;

  CallingModelData({
    this.channelName,
    this.token,
  });

  factory CallingModelData.fromJson(Map<String, dynamic> json) => CallingModelData(
    channelName: json["channelName"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "channelName": channelName,
    "token": token,
  };
}

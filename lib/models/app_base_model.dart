// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

AppBaseModel appBaseModelFromJson(String str) => AppBaseModel.fromJson(json.decode(str));

String appBaseModelToJson(AppBaseModel data) => json.encode(data.toJson());

class AppBaseModel {
  bool? success;
  String? message;

  AppBaseModel({
    this.success,
    this.message,
  });

  factory AppBaseModel.fromJson(Map<String, dynamic> json) => AppBaseModel(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}

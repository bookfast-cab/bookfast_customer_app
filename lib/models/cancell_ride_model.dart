// To parse this JSON data, do
//
//     final bookingRideModel = bookingRideModelFromJson(jsonString);

import 'dart:convert';

CancelRideModel bookingRideModelFromJson(String str) => CancelRideModel.fromJson(json.decode(str));

String bookingRideModelToJson(CancelRideModel data) => json.encode(data.toJson());

class CancelRideModel {
  int? success;
  String? message;
  List<CancelRideData>? data;

  CancelRideModel({
    this.success,
    this.message,
    this.data,
  });

  factory CancelRideModel.fromJson(Map<String, dynamic> json) => CancelRideModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<CancelRideData>.from(json["data"]!.map((x) => CancelRideData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CancelRideData {
  int? reasonId;
  UserType? userType;
  String? reason;

  CancelRideData({
    this.reasonId,
    this.userType,
    this.reason,
  });

  factory CancelRideData.fromJson(Map<String, dynamic> json) => CancelRideData(
    reasonId: json["reasonId"],
    userType: userTypeValues.map[json["userType"]]!,
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "reasonId": reasonId,
    "userType": userTypeValues.reverse[userType],
    "reason": reason,
  };
}

enum UserType {
  CUSTOMER
}

final userTypeValues = EnumValues({
  "customer": UserType.CUSTOMER
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
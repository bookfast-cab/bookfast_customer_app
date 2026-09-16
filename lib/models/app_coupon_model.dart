// To parse this JSON data, do
//
//     final applyCouponModel = applyCouponModelFromJson(jsonString);

import 'dart:convert';

ApplyCouponModel applyCouponModelFromJson(String str) => ApplyCouponModel.fromJson(json.decode(str));

String applyCouponModelToJson(ApplyCouponModel data) => json.encode(data.toJson());

class ApplyCouponModel {
  bool? success;
  String? message;
  ApplyCouponData? data;

  ApplyCouponModel({
    this.success,
    this.message,
    this.data,
  });

  factory ApplyCouponModel.fromJson(Map<String, dynamic> json) => ApplyCouponModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : ApplyCouponData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ApplyCouponData {
  String? id;
  String? senderId;
  dynamic receiverEmail;
  dynamic receiverCountryCode;
  dynamic receiverPhoneNumber;
  dynamic receiverId;
  bool? isUsed;
  String? referralCode;
  String? discountType;
  int? discount;
  DateTime? dataCreatedAt;
  DateTime? dataUpdatedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  ApplyCouponData({
    this.id,
    this.senderId,
    this.receiverEmail,
    this.receiverCountryCode,
    this.receiverPhoneNumber,
    this.receiverId,
    this.isUsed,
    this.referralCode,
    this.discountType,
    this.discount,
    this.dataCreatedAt,
    this.dataUpdatedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ApplyCouponData.fromJson(Map<String, dynamic> json) => ApplyCouponData(
    id: json["id"],
    senderId: json["sender_id"],
    receiverEmail: json["receiver_email"],
    receiverCountryCode: json["receiver_country_code"],
    receiverPhoneNumber: json["receiver_phone_number"],
    receiverId: json["receiver_id"],
    isUsed: json["is_used"],
    referralCode: json["referral_code"],
    discountType: json["discount_type"],
    discount: json["discount"],
    dataCreatedAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    dataUpdatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender_id": senderId,
    "receiver_email": receiverEmail,
    "receiver_country_code": receiverCountryCode,
    "receiver_phone_number": receiverPhoneNumber,
    "receiver_id": receiverId,
    "is_used": isUsed,
    "referral_code": referralCode,
    "discount_type": discountType,
    "discount": discount,
    "created_at": dataCreatedAt?.toIso8601String(),
    "updated_at": dataUpdatedAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

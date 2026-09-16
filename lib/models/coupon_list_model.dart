// To parse this JSON data, do
//
//     final selectedCitiesModel = selectedCitiesModelFromJson(jsonString);

import 'dart:convert';

CouponListModel selectedCitiesModelFromJson(String str) => CouponListModel.fromJson(json.decode(str));

String selectedCitiesModelToJson(CouponListModel data) => json.encode(data.toJson());

class CouponListModel {
   String? message;
   bool? success;
   List<CouponListData>? data;

  CouponListModel({
     this.message,
     this.success,
     this.data,
  });

  factory CouponListModel.fromJson(Map<String, dynamic> json) => CouponListModel(
    message: json["message"],
    success: json["success"],
    data: List<CouponListData>.from(json["data"].map((x) => CouponListData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "success": success,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CouponListData {
   int? couponId;
   String? code;
   String? discountType;
   String? discountValue;
   String? minRideAmount;
   String? maxDiscount;
   DateTime? validFrom;
   DateTime? validTo;
   String? status;
   bool? alreadyApplied;

  CouponListData({
     this.couponId,
     this.code,
     this.discountType,
     this.discountValue,
     this.minRideAmount,
     this.maxDiscount,
     this.validFrom,
     this.validTo,
     this.status,
    this.alreadyApplied
  });

  factory CouponListData.fromJson(Map<String, dynamic> json) => CouponListData(
    couponId: json["coupon_id"],
    code: json["code"],
    discountType: json["discount_type"],
    discountValue: json["discount_value"],
    minRideAmount: json["min_ride_amount"],
    maxDiscount: json["max_discount"],
    validFrom: DateTime.parse(json["valid_from"]),
    validTo: DateTime.parse(json["valid_to"]),
    status: json["status"],
    alreadyApplied: json["alreadyApplied"],
  );

  Map<String, dynamic> toJson() => {
    "coupon_id": couponId,
    "code": code,
    "discount_type": discountType,
    "discount_value": discountValue,
    "min_ride_amount": minRideAmount,
    "max_discount": maxDiscount,
    "valid_from": validFrom?.toIso8601String(),
    "valid_to": validTo?.toIso8601String(),
    "status": status,
    "alreadyApplied": alreadyApplied,
  };
}
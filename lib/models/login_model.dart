// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool? success;
  String? message;
  String? accessToken;
  String? token;
  UserModelData? data;
  bool? isNewCustomer;


  LoginModel({
    this.success,
    this.message,
    this.accessToken,
    this.token,
    this.data,
    this.isNewCustomer,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    success: json["success"]is bool ? json["success"] : (json["success"] == 1),
    message: json["message"],
    accessToken: json["access_token"],
    token: json["token"],
    data: json["data"] == null ? null : UserModelData.fromJson(json["data"]),
    isNewCustomer: json["isNewCustomer"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "access_token": accessToken,
    "token": token,
    "data": data?.toJson(),
    "isNewCustomer": isNewCustomer,
  };
}

class UserModelData {
  int? id;
  String? firstName;
  String? lastName;
  int? countryId;
  int? currency;
  String? countryCode;
  String? phoneNumber;
  String? phoneWithCode;
  dynamic email;
  String? profilePicture;
  int? status;
  int? wallet;
  dynamic gender;
  String? referralCode;
  dynamic referedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic city;
  int? isPremium;
  ActivePlanData? activePlanData;


  UserModelData({
    this.id,
    this.firstName,
    this.lastName,
    this.countryId,
    this.currency,
    this.countryCode,
    this.phoneNumber,
    this.phoneWithCode,
    this.email,
    this.profilePicture,
    this.status,
    this.wallet,
    this.gender,
    this.referralCode,
    this.referedBy,
    this.createdAt,
    this.updatedAt,
    this.city,
    this.isPremium,
    this.activePlanData,

  });

  factory UserModelData.fromJson(Map<String, dynamic> json) => UserModelData(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    countryId: json["country_id"],
    currency: json["currency"],
    countryCode: json["country_code"],
    phoneNumber: json["phone_number"],
    phoneWithCode: json["phone_with_code"],
    email: json["email"],
    profilePicture: json["profile_picture"],
    status: json["status"],
    wallet: json["wallet"],
    gender: json["gender"],
    referralCode: json["referral_code"],
    referedBy: json["refered_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    city: json["city"],
    isPremium: json["is_premium"],
    activePlanData: json["active_plan"] == null ? null : ActivePlanData.fromJson(json["active_plan"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "country_id": countryId,
    "currency": currency,
    "country_code": countryCode,
    "phone_number": phoneNumber,
    "phone_with_code": phoneWithCode,
    "email": email,
    "profile_picture": profilePicture,
    "status": status,
    "wallet": wallet,
    "gender": gender,
    "referral_code": referralCode,
    "refered_by": referedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "city": city,
    "is_premium": isPremium,
    "active_plan": activePlanData?.toJson(),

  };
}

class ActivePlanData {
  int? id;
  int? userId;
  int? status;
  String? currency;
  dynamic price;
  String? token;
  String? planType;
  String? deviceType;
  String? planResponse;
  DateTime? createdAt;
  DateTime? startDate;
  DateTime? expiryDate;
  DateTime? updatedAt;

  ActivePlanData({
    this.id,
    this.userId,
    this.status,
    this.currency,
    this.price,
    this.token,
    this.planType,
    this.deviceType,
    this.planResponse,
    this.startDate,
    this.expiryDate,
    this.createdAt,
    this.updatedAt,
  });

  factory ActivePlanData.fromJson(Map<String, dynamic> json) => ActivePlanData(
    id: json["id"],
    userId: json["user_id"],
    status: json["status"],
    currency: json["currency"],
    price: json["price"],
    token: json["token"],
    planType: json["plan_type"],
    deviceType: json["device_type"],
    planResponse: json["plan_response"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    expiryDate: json["expiry_date"] == null ? null : DateTime.parse(json["expiry_date"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "status": status,
    "currency": currency,
    "price": price,
    "token": token,
    "plan_type": planType,
    "device_type": deviceType,
    "plan_response": planResponse,
    "start_date": startDate?.toIso8601String(),
    "expiry_date": expiryDate?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
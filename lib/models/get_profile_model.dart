// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  bool? success;
  ProfileData? data;

  ProfileModel({
    this.success,
    this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    success: json["success"],
    data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class ProfileData {
  int? id;
  String? firstName;
  String? lastName;
  int? countryId;
  int? currency;
  String? countryCode;
  String? phoneNumber;
  String? phoneWithCode;
  String? email;
  String? profilePicture;
  int? status;
  int? wallet;
  dynamic gender;
  String? referralCode;
  dynamic referedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic city;
  String? fcmToken;

  ProfileData({
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
    this.fcmToken,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
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
    fcmToken: json["fcm_token"],
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
    "fcm_token": fcmToken,
  };
}

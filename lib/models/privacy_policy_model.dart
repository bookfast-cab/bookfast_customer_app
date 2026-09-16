// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

PrivacyPolicyModel profileModelFromJson(String str) => PrivacyPolicyModel.fromJson(json.decode(str));

String profileModelToJson(PrivacyPolicyModel data) => json.encode(data.toJson());

class PrivacyPolicyModel {
  int? success;
  List<PrivacyPolicyData>? data;

  PrivacyPolicyModel({
    this.success,
    this.data,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) => PrivacyPolicyModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<PrivacyPolicyData>.from(json["data"]!.map((x) => PrivacyPolicyData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PrivacyPolicyData {
  int? id;
  int? countryId;
  String? slug;
  String? title;
  String? description;
  String? titleAr;
  String? descriptionAr;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? userTypeId;

  PrivacyPolicyData({
    this.id,
    this.countryId,
    this.slug,
    this.title,
    this.description,
    this.titleAr,
    this.descriptionAr,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userTypeId,
  });

  factory PrivacyPolicyData.fromJson(Map<String, dynamic> json) => PrivacyPolicyData(
    id: json["id"],
    countryId: json["country_id"],
    slug: json["slug"],
    title: json["title"],
    description: json["description"],
    titleAr: json["title_ar"],
    descriptionAr: json["description_ar"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    userTypeId: json["user_type_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_id": countryId,
    "slug": slug,
    "title": title,
    "description": description,
    "title_ar": titleAr,
    "description_ar": descriptionAr,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user_type_id": userTypeId,
  };
}
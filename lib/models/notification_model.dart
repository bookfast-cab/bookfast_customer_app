// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

NotificationModel profileModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String profileModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  int? success;
  String? message;
  List<dynamic>? data;
  Pagination? pagination;

  NotificationModel({
    this.success,
    this.message,
    this.data,
    this.pagination,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    "pagination": pagination?.toJson(),
  };
}

class Pagination {
  int? page;
  int? limit;
  int? totalRecords;
  int? totalPages;

  Pagination({
    this.page,
    this.limit,
    this.totalRecords,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"],
    limit: json["limit"],
    totalRecords: json["totalRecords"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "totalRecords": totalRecords,
    "totalPages": totalPages,
  };
}
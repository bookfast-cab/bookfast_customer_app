// To parse this JSON data, do
//
//     final dashboardDataModel = dashboardDataModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

DashboardModel dashboardDataModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

String dashboardDataModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  int? success;
  String? message;
  DashBoardData? data;

  DashboardModel({
    this.success,
    this.message,
    this.data,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    success: json["success"],
    message: json["message"].toString(),
    data: json["data"] == null ? null : DashBoardData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}


class PromotionalBannerData {
  int? id;
  String? title;
  String? imageUrl;
  String? type;
  String? link;

  PromotionalBannerData({this.id, this.title, this.imageUrl, this.type, this.link});

  factory PromotionalBannerData.fromJson(Map<String, dynamic> json) => PromotionalBannerData(
    id: json["id"],
    title: json["title"],
    imageUrl: json["image_url"],
    type: json["type"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image_url": imageUrl,
    "type": type,
    "link": link,
  };
}

class DashBoardData {
  AppUpdate? appUpdate;
  ActiveTrip? activeTrip;
  String? helplineNumber;
  List<NearbyDriver>? nearbyDrivers;
  List<PromotionalBannerData>? promotionalBanners;
  DashBoardData({
    this.appUpdate,
    this.activeTrip,
    this.helplineNumber,
    this.nearbyDrivers,
    this.promotionalBanners
  });

  factory DashBoardData.fromJson(Map<String, dynamic> json) => DashBoardData(
    appUpdate: json["appUpdate"] == null ? null : AppUpdate.fromJson(json["appUpdate"]),
    activeTrip: json["activeTrip"] == null ? null : ActiveTrip.fromJson(json["activeTrip"]),
    helplineNumber: json["helpline_number"],
    nearbyDrivers: json["nearbyDrivers"] == null ? [] : List<NearbyDriver>.from(json["nearbyDrivers"]!.map((x) => NearbyDriver.fromJson(x))),
    promotionalBanners: json["promotionalBanners"] == null ? [] : List<PromotionalBannerData>.from(json["promotionalBanners"]!.map((x) => PromotionalBannerData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "appUpdate": appUpdate?.toJson(),
    "activeTrip": activeTrip?.toJson(),
    "helpline_number": helplineNumber,
    "nearbyDrivers": nearbyDrivers == null ? [] : List<dynamic>.from(nearbyDrivers!.map((x) => x.toJson())),
    "promotionalBanners": promotionalBanners == null ? [] : List<dynamic>.from(promotionalBanners!.map((x) => x.toJson())),
  };
}

class ActiveTrip {
  int? id;
  String? tripId;
  dynamic countryId;
  int? customerId;
  int? tripType;
  int? tripSubType;
  dynamic bookingType;
  dynamic packageId;
  int? driverId;
  int? isScheduled;
  DateTime? pickupDate;
  dynamic startTime;
  dynamic endTime;
  String? pickupAddress;
  dynamic actualPickupAddress;
  dynamic actualPickupLat;
  dynamic actualPickupLng;
  String? pickupLat;
  String? pickupLng;
  String? dropAddress;
  dynamic actualDropAddress;
  dynamic actualDropLat;
  dynamic actualDropLng;
  String? dropLat;
  String? dropLng;
  dynamic zone;
  String? distance;
  int? vehicleType;
  dynamic paymentMethod;
  String? perMinCharge;
  double? total;
  int? driverAllowance;
  double? subTotal;
  int? discount;
  dynamic tax;
  int? tollTax;
  dynamic promoCode;
  int? tip;
  int? otp;
  int? isMultipleDrops;
  int? isSubscriptionTrip;
  int? status;
  dynamic cancelledBy;
  dynamic cancelledReason;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? surge;
  dynamic totalTime;
  DateTime? rideAcceptedTime;
  String? atPoint;
  String? pickupDistance;
  String? driverEarning;
  String? companyAmount;
  String? cashCollection;
  String? paymentId;
  String? waitingCharge;
  String? extraKmCharge;
  String? extraTimeCharge;
  dynamic outstationPackageId;
  dynamic pendingAmount;

  ActiveTrip({
    this.id,
    this.tripId,
    this.countryId,
    this.customerId,
    this.tripType,
    this.tripSubType,
    this.bookingType,
    this.packageId,
    this.driverId,
    this.isScheduled,
    this.pickupDate,
    this.startTime,
    this.endTime,
    this.pickupAddress,
    this.actualPickupAddress,
    this.actualPickupLat,
    this.actualPickupLng,
    this.pickupLat,
    this.pickupLng,
    this.dropAddress,
    this.actualDropAddress,
    this.actualDropLat,
    this.actualDropLng,
    this.dropLat,
    this.dropLng,
    this.zone,
    this.distance,
    this.vehicleType,
    this.paymentMethod,
    this.perMinCharge,
    this.total,
    this.driverAllowance,
    this.subTotal,
    this.discount,
    this.tax,
    this.tollTax,
    this.promoCode,
    this.tip,
    this.otp,
    this.isMultipleDrops,
    this.isSubscriptionTrip,
    this.status,
    this.cancelledBy,
    this.cancelledReason,
    this.createdAt,
    this.updatedAt,
    this.surge,
    this.totalTime,
    this.rideAcceptedTime,
    this.atPoint,
    this.pickupDistance,
    this.driverEarning,
    this.companyAmount,
    this.cashCollection,
    this.paymentId,
    this.waitingCharge,
    this.extraKmCharge,
    this.extraTimeCharge,
    this.outstationPackageId,
    this.pendingAmount,
  });

  factory ActiveTrip.fromJson(Map<String, dynamic> json) => ActiveTrip(
    id: json["id"],
    tripId: json["trip_id"],
    countryId: json["country_id"],
    customerId: json["customer_id"],
    tripType: json["trip_type"],
    tripSubType: json["trip_sub_type"],
    bookingType: json["booking_type"],
    packageId: json["package_id"],
    driverId: json["driver_id"],
    isScheduled: json["isScheduled"],
    pickupDate: _parseDate(json["pickup_date"]),
    // pickupDate: json["pickup_date"] == null
    //     ? null
    //     : DateTime.tryParse(json["pickup_date"]) ??
    //     DateFormat("dd-MM-yyyy HH:mm:ss").parse(json["pickup_date"]),
    startTime: json["start_time"],
    endTime: json["end_time"],
    pickupAddress: json["pickup_address"],
    actualPickupAddress: json["actual_pickup_address"],
    actualPickupLat: json["actual_pickup_lat"],
    actualPickupLng: json["actual_pickup_lng"],
    pickupLat: json["pickup_lat"],
    pickupLng: json["pickup_lng"],
    dropAddress: json["drop_address"],
    actualDropAddress: json["actual_drop_address"],
    actualDropLat: json["actual_drop_lat"],
    actualDropLng: json["actual_drop_lng"],
    dropLat: json["drop_lat"],
    dropLng: json["drop_lng"],
    zone: json["zone"],
    distance: json["distance"],
    vehicleType: json["vehicle_type"],
    paymentMethod: json["payment_method"],
    perMinCharge: json["per_min_charge"],
    total: json["total"]?.toDouble(),
    driverAllowance: json["driver_allowance"],
    subTotal: json["sub_total"]?.toDouble(),
    discount: json["discount"],
    tax: json["tax"],
    tollTax: json["tollTax"],
    promoCode: json["promo_code"],
    tip: json["tip"],
    otp: json["otp"],
    isMultipleDrops: json["is_multiple_drops"],
    isSubscriptionTrip: json["is_subscription_trip"],
    status: json["status"],
    cancelledBy: json["cancelledBy"],
    cancelledReason: json["cancelledReason"],
    createdAt: _parseDate(json["created_at"]),
    updatedAt: _parseDate(json["updated_at"]),
    // createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"]) ??
    //     DateFormat("dd-MM-yyyy HH:mm:ss").parse(json["created_at"]),
    //     //: DateTime.parse(json["created_at"]),
    // updatedAt: json["updated_at"] == null ? null : DateTime.tryParse(json["updated_at"]) ??
    //     DateFormat("dd-MM-yyyy HH:mm:ss").parse(json["updated_at"]),
    //     //: DateTime.parse(json["updated_at"]),
    surge: json["surge"],
    totalTime: json["total_time"],
    rideAcceptedTime: _parseDate(json["ride_accepted_time"]),
    // rideAcceptedTime: json["ride_accepted_time"] == null ? null  : DateTime.tryParse(json["ride_accepted_time"]) ??
    //     DateFormat("dd-MM-yyyy HH:mm:ss").parse(json["ride_accepted_time"]),
    //     //: DateTime.parse(json["ride_accepted_time"]),
    atPoint: json["at_point"],
    pickupDistance: json["pickup_distance"],
    driverEarning: json["driver_earning"],
    companyAmount: json["company_amount"],
    cashCollection: json["cash_collection"],
    paymentId: json["payment_id"],
    waitingCharge: json["waiting_charge"],
    extraKmCharge: json["extra_km_charge"],
    extraTimeCharge: json["extra_time_charge"],
    outstationPackageId: json["outstationPackageId"],
    pendingAmount: json["pendingAmount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "trip_id": tripId,
    "country_id": countryId,
    "customer_id": customerId,
    "trip_type": tripType,
    "trip_sub_type": tripSubType,
    "booking_type": bookingType,
    "package_id": packageId,
    "driver_id": driverId,
    "isScheduled": isScheduled,
    "pickup_date": pickupDate?.toIso8601String(),
    "start_time": startTime,
    "end_time": endTime,
    "pickup_address": pickupAddress,
    "actual_pickup_address": actualPickupAddress,
    "actual_pickup_lat": actualPickupLat,
    "actual_pickup_lng": actualPickupLng,
    "pickup_lat": pickupLat,
    "pickup_lng": pickupLng,
    "drop_address": dropAddress,
    "actual_drop_address": actualDropAddress,
    "actual_drop_lat": actualDropLat,
    "actual_drop_lng": actualDropLng,
    "drop_lat": dropLat,
    "drop_lng": dropLng,
    "zone": zone,
    "distance": distance,
    "vehicle_type": vehicleType,
    "payment_method": paymentMethod,
    "per_min_charge": perMinCharge,
    "total": total,
    "driver_allowance": driverAllowance,
    "sub_total": subTotal,
    "discount": discount,
    "tax": tax,
    "tollTax": tollTax,
    "promo_code": promoCode,
    "tip": tip,
    "otp": otp,
    "is_multiple_drops": isMultipleDrops,
    "is_subscription_trip": isSubscriptionTrip,
    "status": status,
    "cancelledBy": cancelledBy,
    "cancelledReason": cancelledReason,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "surge": surge,
    "total_time": totalTime,
    "ride_accepted_time": rideAcceptedTime?.toIso8601String(),
    "at_point": atPoint,
    "pickup_distance": pickupDistance,
    "driver_earning": driverEarning,
    "company_amount": companyAmount,
    "cash_collection": cashCollection,
    "payment_id": paymentId,
    "waiting_charge": waitingCharge,
    "extra_km_charge": extraKmCharge,
    "extra_time_charge": extraTimeCharge,
    "outstationPackageId": outstationPackageId,
    "pendingAmount": pendingAmount,
  };
}

class AppUpdate {
  int? id;
  String? appType;
  bool? forceUpdate;
  String? versionCode;
  int? versionNumber;
  String? deviceType;
  DateTime? createdAt;
  DateTime? updatedAt;

  AppUpdate({
    this.id,
    this.appType,
    this.forceUpdate,
    this.versionCode,
    this.versionNumber,
    this.deviceType,
    this.createdAt,
    this.updatedAt,
  });

  factory AppUpdate.fromJson(Map<String, dynamic> json) => AppUpdate(
    id: json["id"],
    appType: json["appType"],
    forceUpdate: json["forceUpdate"],
    versionCode: json["versionCode"],
    versionNumber: json["versionNumber"],
    deviceType: json["deviceType"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "appType": appType,
    "forceUpdate": forceUpdate,
    "versionCode": versionCode,
    "versionNumber": versionNumber,
    "deviceType": deviceType,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class NearbyDriver {
  int? id;
  double? latitude;
  double? longitude;

  NearbyDriver({
    this.id,
    this.latitude,
    this.longitude,
  });

  factory NearbyDriver.fromJson(Map<String, dynamic> json) => NearbyDriver(
    id: json["id"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
  };
}

DateTime? _parseDate(dynamic dateStr) {
  if (dateStr == null || dateStr.toString().isEmpty) return null;

  try {
    return DateTime.parse(dateStr.toString());
  } catch (_) {
    try {
      return DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateStr.toString());
    } catch (_) {
      return null;
    }
  }
}

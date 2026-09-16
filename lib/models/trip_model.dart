// To parse this JSON data, do
//
//     final tripModel = tripModelFromJson(jsonString);

import 'dart:convert';

TripModel tripModelFromJson(String str) => TripModel.fromJson(json.decode(str));

String tripModelToJson(TripModel data) => json.encode(data.toJson());

class TripModel {
  int? success;
  String? message;
  TripData? data;

  TripModel({
    this.success,
    this.message,
    this.data,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : TripData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class TripData {
  int? id;
  dynamic tripId;
  dynamic countryId;
  int? customerId;
  int? tripType;
  int? tripSubType;
  dynamic bookingType;
  dynamic packageId;
  dynamic driverId;
  dynamic pickupDate;
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
  double? subTotal;
  int? discount;
  double? tax;
  dynamic promoCode;
  int? tip;
  dynamic otp;
  int? isMultipleDrops;
  int? isSubscriptionTrip;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? surge;
  dynamic totalTime;
  String? rideAcceptedTime;
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
  dynamic driver;

  TripData({
    this.id,
    this.tripId,
    this.countryId,
    this.customerId,
    this.tripType,
    this.tripSubType,
    this.bookingType,
    this.packageId,
    this.driverId,
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
    this.subTotal,
    this.discount,
    this.tax,
    this.promoCode,
    this.tip,
    this.otp,
    this.isMultipleDrops,
    this.isSubscriptionTrip,
    this.status,
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
    this.driver,
  });

  factory TripData.fromJson(Map<String, dynamic> json) => TripData(
    id: json["id"],
    tripId: json["trip_id"],
    countryId: json["country_id"],
    customerId: json["customer_id"],
    tripType: json["trip_type"],
    tripSubType: json["trip_sub_type"],
    bookingType: json["booking_type"],
    packageId: json["package_id"],
    driverId: json["driver_id"],
    pickupDate: json["pickup_date"],
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
    subTotal: json["sub_total"]?.toDouble(),
    discount: json["discount"],
    tax: json["tax"]?.toDouble(),
    promoCode: json["promo_code"],
    tip: json["tip"],
    otp: json["otp"],
    isMultipleDrops: json["is_multiple_drops"],
    isSubscriptionTrip: json["is_subscription_trip"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    surge: json["surge"],
    totalTime: json["total_time"],
    rideAcceptedTime: json["ride_accepted_time"],
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
    driver: json["driver"],
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
    "pickup_date": pickupDate,
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
    "sub_total": subTotal,
    "discount": discount,
    "tax": tax,
    "promo_code": promoCode,
    "tip": tip,
    "otp": otp,
    "is_multiple_drops": isMultipleDrops,
    "is_subscription_trip": isSubscriptionTrip,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "surge": surge,
    "total_time": totalTime,
    "ride_accepted_time": rideAcceptedTime,
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
    "driver": driver,
  };
}
// To parse this JSON data, do
//
//     final bookingRideModel = bookingRideModelFromJson(jsonString);

import 'dart:convert';

BookingRideModel bookingRideModelFromJson(String str) => BookingRideModel.fromJson(json.decode(str));

String bookingRideModelToJson(BookingRideModel data) => json.encode(data.toJson());

class BookingRideModel {
  int? success;
  String? message;
  BookingRideData? data;
  Coupon? coupon;

  BookingRideModel({
    this.success,
    this.message,
    this.data,
    this.coupon,
  });

  factory BookingRideModel.fromJson(Map<String, dynamic> json) => BookingRideModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : BookingRideData.fromJson(json["data"]),
        coupon: json["coupon"] == null ? null : Coupon.fromJson(json["coupon"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "coupon": coupon?.toJson(),
      };
}

class Coupon {
  Coupon();
  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon();
  Map<String, dynamic> toJson() => {};
}

class BookingRideData {
  CouponModel? couponData;
  dynamic additionalFare;
  dynamic baseFare;
  dynamic discount;
  dynamic fare;
  dynamic km;
  dynamic outstationPackageId;
  dynamic pricePerKm;
  dynamic surge;
  dynamic tax;
  dynamic totalFare;
  dynamic tripType;
  dynamic driverAllowance;
  dynamic pickAddress;
  dynamic id;
  dynamic tripId;
  dynamic countryId;
  dynamic customerId;
  dynamic tripSubType;
  dynamic bookingType;
  dynamic packageId;
  dynamic driverId;
//  dynamic pickupDate;
  dynamic startTime;
  dynamic endTime;
  dynamic pickupAddress;
  dynamic actualPickupAddress;
  dynamic actualPickupLat;
  dynamic actualPickupLng;
  dynamic pickupLat;
  dynamic pickupLng;
  dynamic dropAddress;
  dynamic actualDropAddress;
  dynamic actualDropLat;
  dynamic actualDropLng;
  dynamic dropLat;
  dynamic dropLng;
  dynamic zone;
  dynamic distance;
  dynamic vehicleType;
  dynamic paymentMethod;
  dynamic perMinCharge;
  dynamic total;
  dynamic subTotal;
  dynamic promoCode;
  dynamic tip;
  dynamic otp;
  dynamic isMultipleDrops;
  dynamic isSubscriptionTrip;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic totalTime;
  dynamic rideAcceptedTime;
  dynamic atPoint;
  dynamic pickupDistance;
  dynamic driverEarning;
  dynamic companyAmount;
  dynamic cashCollection;
  dynamic paymentId;
  dynamic waitingCharge;
  dynamic extraKmCharge;
  dynamic extraTimeCharge;
  dynamic pendingAmount;
  dynamic driver;
  dynamic isScheduled;
  dynamic tollTax;
  DateTime? returnPickupDate;
  dynamic returnPickupTime;
  DateTime? pickupDate;
  dynamic pickupTime;
  Gst? gst;
  dynamic extraHourCharges;
  DateTime? actualReturnDateTime;
  ExtraChargesBreakdown? extraChargesBreakdown;

  BookingRideData(
      {this.couponData,
      this.additionalFare,
      this.baseFare,
      this.discount,
      this.fare,
      this.km,
      this.outstationPackageId,
      this.pricePerKm,
      this.surge,
      this.tax,
      this.totalFare,
      this.tripType,
      this.driverAllowance,
      this.pickAddress,
      this.id,
      this.tripId,
      this.countryId,
      this.customerId,
      this.tripSubType,
      this.bookingType,
      this.packageId,
      this.driverId,
      //   this.pickupDate,
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
      this.promoCode,
      this.tip,
      this.otp,
      this.isMultipleDrops,
      this.isSubscriptionTrip,
      this.status,
      this.createdAt,
      this.updatedAt,
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
      this.pendingAmount,
      this.driver,
      this.isScheduled,
      this.tollTax,
      this.returnPickupTime,
      this.returnPickupDate,
      this.pickupDate,
      this.pickupTime,
      this.gst,
      this.extraHourCharges,
      this.actualReturnDateTime,
      this.extraChargesBreakdown});

  factory BookingRideData.fromJson(Map<String, dynamic> json) => BookingRideData(
        couponData: json["couponData"] == null ? null : CouponModel.fromJson(json["couponData"]),
        additionalFare: json["additional_fare"]?.toDouble(),
        baseFare: json["base_fare"],
        discount: json["discount"],
        fare: json["fare"]?.toDouble(),
        km: json["km"]?.toDouble(),
        outstationPackageId: json["outstationPackageId"],
        pricePerKm: json["price_per_km"],
        surge: json["surge"],
        tax: json["tax"]?.toDouble(),
        totalFare: json["total_fare"]?.toDouble(),
        tripType: json["trip_type"],
        driverAllowance: json["driverAllowance"],
        pickAddress: json["pickAddress"],
        id: json["id"],
        tripId: json["trip_id"],
        countryId: json["country_id"],
        customerId: json["customer_id"],
        tripSubType: json["trip_sub_type"],
        bookingType: json["booking_type"],
        packageId: json["package_id"],
        driverId: json["driver_id"],
        //    pickupDate: json["pickup_date"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        pickupAddress: json["pickup_address"],
        actualPickupAddress: json["actual_pickup_address"],
        actualPickupLat: json["actual_pickup_lat"],
        actualPickupLng: json["actual_pickup_lng"],
        pickupLat: json["pickup_lat"].toString(),
        pickupLng: json["pickup_lng"].toString(),
        dropAddress: json["drop_address"],
        actualDropAddress: json["actual_drop_address"],
        actualDropLat: json["actual_drop_lat"],
        actualDropLng: json["actual_drop_lng"],
        dropLat: json["drop_lat"].toString(),
        dropLng: json["drop_lng"].toString(),
        zone: json["zone"],
        distance: json["distance"].toString(),
        vehicleType: json["vehicle_type"],
        paymentMethod: json["payment_method"],
        perMinCharge: json["per_min_charge"],
        total: json["total"] == null ? null : json["total"]?.toString(),
        subTotal: json["sub_total"] == null ? null : json["sub_total"]?.toDouble(),
        promoCode: json["promo_code"],
        tip: json["tip"],
        otp: json["otp"],
        isMultipleDrops: json["is_multiple_drops"],
        isSubscriptionTrip: json["is_subscription_trip"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
        pendingAmount: json["pendingAmount"],
        driver: json["driver"],
        isScheduled: json["isScheduled"],
        tollTax: json["tollTax"],
        returnPickupDate: safeDate(json["returnPickupDate"]),
        returnPickupTime: json["returnPickupTime"],
        pickupDate: safeDate(json["pickupDate"]),
        pickupTime: json["pickupTime"],
        gst: json["gst"] == null ? null : Gst.fromJson(json["gst"]),
        extraHourCharges: json["extra_hour_charges"],

        actualReturnDateTime: json["actual_return_date_time"] == null ? null : DateTime.parse(json["actual_return_date_time"]),
        extraChargesBreakdown:
            json["extra_charges_breakdown"] == null ? null : ExtraChargesBreakdown.fromJson(json["extra_charges_breakdown"]),
      );

  Map<String, dynamic> toJson() => {
        "couponData": couponData?.toJson(),
        "additional_fare": additionalFare,
        "base_fare": baseFare,
        "discount": discount,
        "fare": fare,
        "km": km,
        "outstationPackageId": outstationPackageId,
        "price_per_km": pricePerKm,
        "surge": surge,
        "tax": tax,
        "total_fare": totalFare,
        "trip_type": tripType,
        "driverAllowance": driverAllowance,
        "pickAddress": pickAddress,
        "id": id,
        "trip_id": tripId,
        "country_id": countryId,
        "customer_id": customerId,
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
        "promo_code": promoCode,
        "tip": tip,
        "otp": otp,
        "is_multiple_drops": isMultipleDrops,
        "is_subscription_trip": isSubscriptionTrip,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
        "pendingAmount": pendingAmount,
        "driver": driver,
        "isScheduled": isScheduled,
        "tollTax": tollTax,
        "returnPickupDate": returnPickupDate,
        "returnPickupTime": returnPickupTime,
        "pickupDate": pickupDate,
        "pickupTime": pickupTime,
        "gst": gst?.toJson(),
        "extra_hour_charges": extraHourCharges,
        "actual_return_date_time": actualReturnDateTime!.toIso8601String(),
        "extra_charges_breakdown": extraChargesBreakdown?.toJson(),
      };
}

class ExtraChargesBreakdown {
  double? extraHours;
  double? totalTravelingHours;
  double? totalTripHours;
  int? extraHourRate;

  ExtraChargesBreakdown({
    this.extraHours,
    this.totalTravelingHours,
    this.totalTripHours,
    this.extraHourRate,
  });

  factory ExtraChargesBreakdown.fromJson(Map<String, dynamic> json) => ExtraChargesBreakdown(
        extraHours: json["extra_hours"]?.toDouble(),
        totalTravelingHours: json["total_traveling_hours"]?.toDouble(),
        totalTripHours: json["total_trip_hours"]?.toDouble(),
        extraHourRate: json["extra_hour_rate"],
      );

  Map<String, dynamic> toJson() => {
        "extra_hours": extraHours,
        "total_traveling_hours": totalTravelingHours,
        "total_trip_hours": totalTripHours,
        "extra_hour_rate": extraHourRate,
      };
}

class CouponModel {
  bool? isCouponApplicable;
  String? message;
  CouponAllData? coupon;

  CouponModel({
    this.isCouponApplicable,
    this.message,
    this.coupon,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        isCouponApplicable: json["isCouponApplicable"],
        message: json["message"],
        coupon: json["coupon"] == null ? null : CouponAllData.fromJson(json["coupon"]),
      );

  Map<String, dynamic> toJson() => {
        "isCouponApplicable": isCouponApplicable,
        "message": message,
        "coupon": coupon?.toJson(),
      };
}

class CouponAllData {
  int? couponId;
  String? code;
  String? discountType;
  String? discountValue;
  String? minRideAmount;
  String? maxDiscount;
  DateTime? validFrom;
  DateTime? validTo;
  String? status;

  CouponAllData({
    this.couponId,
    this.code,
    this.discountType,
    this.discountValue,
    this.minRideAmount,
    this.maxDiscount,
    this.validFrom,
    this.validTo,
    this.status,
  });

  factory CouponAllData.fromJson(Map<String, dynamic> json) => CouponAllData(
        couponId: json["coupon_id"],
        code: json["code"],
        discountType: json["discount_type"],
        discountValue: json["discount_value"],
        minRideAmount: json["min_ride_amount"],
        maxDiscount: json["max_discount"],
        validFrom: json["valid_from"] == null ? null : DateTime.parse(json["valid_from"]),
        validTo: json["valid_to"] == null ? null : DateTime.parse(json["valid_to"]),
        status: json["status"],
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
      };
}

class Gst {
  String? title;
  double? amount;

  Gst({
    this.title,
    this.amount,
  });

  factory Gst.fromJson(Map<String, dynamic> json) => Gst(
        title: json["title"],
        amount: json["amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "amount": amount,
      };
}

DateTime? safeDate(dynamic value) {
  if (value == null) return null;

  final v = value.toString().trim();

  if (v.isEmpty || v == "null") return null;

  return DateTime.tryParse(v);
}

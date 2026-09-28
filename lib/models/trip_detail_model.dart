// To parse this JSON data, do
//
//     final tripDetailModel = tripDetailModelFromJson(jsonString);

import 'dart:convert';

TripDetailModel tripDetailModelFromJson(String str) => TripDetailModel.fromJson(json.decode(str));

String tripDetailModelToJson(TripDetailModel data) => json.encode(data.toJson());

class TripDetailModel {
  int? success;
  String? message;
  TripDetailData? data;

  TripDetailModel({
    this.success,
    this.message,
    this.data,
  });

  factory TripDetailModel.fromJson(Map<String, dynamic> json) => TripDetailModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : TripDetailData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class TripDetailData {
  int? id;
  String? tripId;
  dynamic countryId;
  int? customerId;
  int? tripType;
  int? tripSubType;
  dynamic bookingType;
  int? packageId;
  int? driverId;
  int? isScheduled;
  DateTime? pickupDate;
  DateTime? returnDateTime;
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
  dynamic total;
  dynamic driverAllowance;
  dynamic subTotal;
  dynamic discount;
  dynamic tax;
  dynamic tollTax;
  String? promoCode;
  dynamic tip;
  dynamic otp;
  int? isMultipleDrops;
  int? isSubscriptionTrip;
  int? status;
  dynamic cancelledBy;
  dynamic cancelledReason;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? surge;
  dynamic totalTime;
  String? rideAcceptedTime;
  String? atPoint;
  String? pickupDistance;
  dynamic driverEarning;
  dynamic companyAmount;
  String? cashCollection;
  String? paymentId;
  String? waitingCharge;
  String? extraKmCharge;
  String? extraTimeCharge;
  dynamic outstationPackageId;
  dynamic pendingAmount;
  int? paymentReceived;
  PaymentDetail? paymentDetail;
  int? amountGivenToDriver;
  dynamic driverPaymentMethod;
  int? remainingAmountFromDriver;
  int? createdbyadmin;
  DriverData? driver;

  TripDetailData({
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
    this.returnDateTime,
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
    this.paymentReceived,
    this.paymentDetail,
    this.amountGivenToDriver,
    this.driverPaymentMethod,
    this.remainingAmountFromDriver,
    this.createdbyadmin,
    this.driver,
  });

  factory TripDetailData.fromJson(Map<String, dynamic> json) => TripDetailData(
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
    pickupDate: json["pickup_date"] == null ? null : DateTime.parse(json["pickup_date"]),
    returnDateTime: json["return_date_time"] == null ? null : DateTime.parse(json["return_date_time"]),

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
    total: json["total"],
    driverAllowance: json["driver_allowance"],
    subTotal: json["sub_total"],
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
    paymentReceived: json["paymentReceived"],
    paymentDetail: json["paymentDetail"] == null ? null : PaymentDetail.fromJson(json["paymentDetail"]),
    amountGivenToDriver: json["amountGivenToDriver"],
    driverPaymentMethod: json["driverPaymentMethod"],
    remainingAmountFromDriver: (json["remainingAmountFromDriver"] as num?)?.toInt(),
    createdbyadmin: json["createdbyadmin"],
    driver: json["driver"] == null ? null : DriverData.fromJson(json["driver"]),
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
    "return_date_time": returnDateTime?.toIso8601String(),

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
    "paymentReceived": paymentReceived,
    "paymentDetail": paymentDetail?.toJson(),
    "amountGivenToDriver": amountGivenToDriver,
    "driverPaymentMethod": driverPaymentMethod,
    "remainingAmountFromDriver": remainingAmountFromDriver,
    "createdbyadmin": createdbyadmin,
    "driver": driver?.toJson(),
  };
}
class PaymentDetail {
  double? km;
  double? tax;
  int? surge;
  int? discount;
  int? tollTax;
  int? baseFare;
  double? subTotal;
  String? totalFare;
  int? pricePerKm;
  double? additionalFare;
  int? nightAllowance;
  int? driverAllowance;
  DateTime? returnPickupDate;
  String? returnPickupTime;

  PaymentDetail({
    this.km,
    this.tax,
    this.surge,
    this.discount,
    this.tollTax,
    this.baseFare,
    this.subTotal,
    this.totalFare,
    this.pricePerKm,
    this.additionalFare,
    this.nightAllowance,
    this.driverAllowance,
    this.returnPickupDate,
    this.returnPickupTime,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
    km: json["km"]?.toDouble(),
    tax: json["tax"]?.toDouble(),
    surge: json["surge"],
    discount: json["discount"],
    tollTax: json["toll_tax"],
    baseFare: json["base_fare"],
    subTotal: json["sub_total"]?.toDouble(),
    totalFare: json["total_fare"],
    pricePerKm: json["price_per_km"],
    additionalFare: json["additional_fare"]?.toDouble(),
    nightAllowance: json["night_allowance"],
    driverAllowance: json["driver_allowance"],
    returnPickupDate: json["return_pickup_date"] == null ? null : DateTime.parse(json["return_pickup_date"]),
    returnPickupTime: json["return_pickup_time"],
  );

  Map<String, dynamic> toJson() => {
    "km": km,
    "tax": tax,
    "surge": surge,
    "discount": discount,
    "toll_tax": tollTax,
    "base_fare": baseFare,
    "sub_total": subTotal,
    "total_fare": totalFare,
    "price_per_km": pricePerKm,
    "additional_fare": additionalFare,
    "night_allowance": nightAllowance,
    "driver_allowance": driverAllowance,
    "return_pickup_date": "${returnPickupDate!.year.toString().padLeft(4, '0')}-${returnPickupDate!.month.toString().padLeft(2, '0')}-${returnPickupDate!.day.toString().padLeft(2, '0')}",
    "return_pickup_time": returnPickupTime,
  };
}

class DriverData {
  int? id;
  int? countryId;
  String? countryCode;
  String? phoneWithCode;
  String? phoneNumber;
  String? email;
  String? gender;
  dynamic dateOfBirth;
  dynamic address;
  dynamic currency;
  dynamic wallet;
  double? latitude;
  double? longitude;
  dynamic coordinates;
  int? driverHiringStatus;
  int? outstationBookingStatus;
  int? localBookingStatus;
  String? driverName;
  String? drivingLicenseNumber;
  String? vehicleRcNo;
  dynamic driverMobileNo;
  String? ownerName;
  String? ownerMobileNo;
  // int? cabAttachmentCity;
  int? cabCategory;
  String? remarks;
  String? driverProfile;
  int? profileApproved;
  int? profileCompleted;
  dynamic rejectedReason;
  String? referralCode;
  dynamic referedBy;
  String? fcmToken;
  DateTime? updatedAt;
  DateTime? createdAt;
  DateTime? lastLocationUpdateAt;
  int? docsCount;

  DriverData({
    this.id,
    this.countryId,
    this.countryCode,
    this.phoneWithCode,
    this.phoneNumber,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.currency,
    this.wallet,
    this.latitude,
    this.longitude,
    this.coordinates,
    this.driverHiringStatus,
    this.outstationBookingStatus,
    this.localBookingStatus,
    this.driverName,
    this.drivingLicenseNumber,
    this.vehicleRcNo,
    this.driverMobileNo,
    this.ownerName,
    this.ownerMobileNo,
    // this.cabAttachmentCity,
    this.cabCategory,
    this.remarks,
    this.driverProfile,
    this.profileApproved,
    this.profileCompleted,
    this.rejectedReason,
    this.referralCode,
    this.referedBy,
    this.fcmToken,
    this.updatedAt,
    this.createdAt,
    this.lastLocationUpdateAt,
    this.docsCount,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) => DriverData(
    id: json["id"],
    countryId: json["country_id"],
    countryCode: json["country_code"],
    phoneWithCode: json["phone_with_code"],
    phoneNumber: json["phone_number"],
    email: json["email"],
    gender: json["gender"],
    dateOfBirth: json["date_of_birth"],
    address: json["address"],
    currency: json["currency"],
    wallet: json["wallet"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    coordinates: json["coordinates"],
    driverHiringStatus: json["driver_hiring_status"],
    outstationBookingStatus: json["outstation_booking_status"],
    localBookingStatus: json["local_booking_status"],
    driverName: json["driverName"],
    drivingLicenseNumber: json["drivingLicenseNumber"],
    vehicleRcNo: json["vehicleRcNo"],
    driverMobileNo: json["driverMobileNo"],
    ownerName: json["ownerName"],
    ownerMobileNo: json["ownerMobileNo"],
    // cabAttachmentCity: json["cabAttachmentCity"],
    cabCategory: json["cabCategory"],
    remarks: json["remarks"],
    driverProfile: json["driverProfile"],
    profileApproved: json["profileApproved"],
    profileCompleted: json["profileCompleted"],
    rejectedReason: json["rejected_reason"],
    referralCode: json["referral_code"],
    referedBy: json["refered_by"],
    fcmToken: json["fcm_token"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    lastLocationUpdateAt: json["lastLocationUpdateAt"] == null ? null : DateTime.parse(json["lastLocationUpdateAt"]),
    docsCount: json["docsCount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_id": countryId,
    "country_code": countryCode,
    "phone_with_code": phoneWithCode,
    "phone_number": phoneNumber,
    "email": email,
    "gender": gender,
    "date_of_birth": dateOfBirth,
    "address": address,
    "currency": currency,
    "wallet": wallet,
    "latitude": latitude,
    "longitude": longitude,
    "coordinates": coordinates,
    "driver_hiring_status": driverHiringStatus,
    "outstation_booking_status": outstationBookingStatus,
    "local_booking_status": localBookingStatus,
    "driverName": driverName,
    "drivingLicenseNumber": drivingLicenseNumber,
    "vehicleRcNo": vehicleRcNo,
    "driverMobileNo": driverMobileNo,
    "ownerName": ownerName,
    "ownerMobileNo": ownerMobileNo,
    // "cabAttachmentCity": cabAttachmentCity,
    "cabCategory": cabCategory,
    "remarks": remarks,
    "driverProfile": driverProfile,
    "profileApproved": profileApproved,
    "profileCompleted": profileCompleted,
    "rejected_reason": rejectedReason,
    "referral_code": referralCode,
    "refered_by": referedBy,
    "fcm_token": fcmToken,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "lastLocationUpdateAt": lastLocationUpdateAt?.toIso8601String(),
    "docsCount": docsCount,
  };
}


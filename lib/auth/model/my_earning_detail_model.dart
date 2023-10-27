// To parse this JSON data, do
//
//     final myEarningDetailDataModel = myEarningDetailDataModelFromJson(jsonString);

import 'dart:convert';

MyEarningDetailDataModel myEarningDetailDataModelFromJson(String str) => MyEarningDetailDataModel.fromJson(json.decode(str));

String myEarningDetailDataModelToJson(MyEarningDetailDataModel data) => json.encode(data.toJson());

class MyEarningDetailDataModel {
  bool? status;
  String? message;
  Data? data;

  MyEarningDetailDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory MyEarningDetailDataModel.fromJson(Map<String, dynamic> json) => MyEarningDetailDataModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? userName;
  String? userMobile;
  String? price;
  String? paymentId;
  String? paymentType;
  int? orderId;
  String? serviceCategoryTitle;
  String? serviceDescription;
  String? serviceWhatincludes;
  String? paymentStatus;
  int? slotId;
  String? slotName;
  DateTime? bookingDate;
  String? bookingId;
  String? isWalletApplied;
  int? tipamount;
  int? walletamount;
  int? addressId;
  int? otp;
  int? pincode;
  String? staffType;
  String? reason;
  String? status;
  DateTime? date;

  Data({
    this.id,
    this.userName,
    this.userMobile,
    this.price,
    this.paymentId,
    this.paymentType,
    this.orderId,
    this.serviceCategoryTitle,
    this.serviceDescription,
    this.serviceWhatincludes,
    this.paymentStatus,
    this.slotId,
    this.slotName,
    this.bookingDate,
    this.bookingId,
    this.isWalletApplied,
    this.tipamount,
    this.walletamount,
    this.addressId,
    this.otp,
    this.pincode,
    this.staffType,
    this.reason,
    this.status,
    this.date,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userName: json["user_name"],
    userMobile: json["user_mobile"],
    price: json["price"],
    paymentId: json["payment_id"],
    paymentType: json["paymentType"],
    orderId: json["orderId"],
    serviceCategoryTitle: json["service_category_title"],
    serviceDescription: json["service_description"],
    serviceWhatincludes: json["service_whatincludes"],
    paymentStatus: json["payment_status"],
    slotId: json["slot_id"],
    slotName: json["slot_name"],
    bookingDate: json["booking_date"] == null ? null : DateTime.parse(json["booking_date"]),
    bookingId: json["booking_id"],
    isWalletApplied: json["isWalletApplied"],
    tipamount: json["tipamount"],
    walletamount: json["walletamount"],
    addressId: json["address_id"],
    otp: json["otp"],
    pincode: json["pincode"],
    staffType: json["staff_type"],
    reason: json["reason"],
    status: json["status"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_name": userName,
    "user_mobile": userMobile,
    "price": price,
    "payment_id": paymentId,
    "paymentType": paymentType,
    "orderId": orderId,
    "service_category_title": serviceCategoryTitle,
    "service_description": serviceDescription,
    "service_whatincludes": serviceWhatincludes,
    "payment_status": paymentStatus,
    "slot_id": slotId,
    "slot_name": slotName,
    "booking_date": "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
    "booking_id": bookingId,
    "isWalletApplied": isWalletApplied,
    "tipamount": tipamount,
    "walletamount": walletamount,
    "address_id": addressId,
    "otp": otp,
    "pincode": pincode,
    "staff_type": staffType,
    "reason": reason,
    "status": status,
    "date": date?.toIso8601String(),
  };
}

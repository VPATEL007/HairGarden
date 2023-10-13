// To parse this JSON data, do
//
//     final bookingDetailDataModel = bookingDetailDataModelFromJson(jsonString);

import 'dart:convert';

BookingDetailDataModel bookingDetailDataModelFromJson(String str) => BookingDetailDataModel.fromJson(json.decode(str));

String bookingDetailDataModelToJson(BookingDetailDataModel data) => json.encode(data.toJson());

class BookingDetailDataModel {
  final bool? status;
  final String? message;
  final List<Datum>? data;

  BookingDetailDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory BookingDetailDataModel.fromJson(Map<String, dynamic> json) => BookingDetailDataModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final String? customerName;
  final String? firstName;
  final String? lastName;
  final dynamic buildingName;
  final dynamic location;
  final dynamic pincode;
  final String? bookId;
  final dynamic orderId;
  final String? timing;
  final String? status;
  final DateTime? bookingDate;
  final String? paymentType;
  final String? paymentStatus;
  final String? amount;

  Datum({
    this.customerName,
    this.firstName,
    this.lastName,
    this.buildingName,
    this.location,
    this.pincode,
    this.bookId,
    this.orderId,
    this.timing,
    this.status,
    this.bookingDate,
    this.paymentType,
    this.paymentStatus,
    this.amount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    customerName: json["customer_name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    buildingName: json["building_name"],
    location: json["location"],
    pincode: json["pincode"],
    bookId: json["bookID"],
    orderId: json["orderID"],
    timing: json["timing"],
    status: json["status"],
    bookingDate: json["booking_date"] == null ? null : DateTime.parse(json["booking_date"]),
    paymentType: json["paymentType"],
    paymentStatus: json["payment_status"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "customer_name": customerName,
    "first_name": firstName,
    "last_name": lastName,
    "building_name": buildingName,
    "location": location,
    "pincode": pincode,
    "bookID": bookId,
    "orderID": orderId,
    "timing": timing,
    "status": status,
    "booking_date": "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
    "paymentType": paymentType,
    "payment_status": paymentStatus,
    "amount": amount,
  };
}

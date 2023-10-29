// To parse this JSON data, do
//
//     final allBookingModel = allBookingModelFromJson(jsonString);

import 'dart:convert';

AllBookingModel allBookingModelFromJson(String str) =>
    AllBookingModel.fromJson(json.decode(str));

String allBookingModelToJson(AllBookingModel data) =>
    json.encode(data.toJson());

class AllBookingModel {
  final bool? status;
  final String? message;
  final List<Datum>? data;

  AllBookingModel({
    this.status,
    this.message,
    this.data,
  });

  factory AllBookingModel.fromJson(Map<String, dynamic> json) =>
      AllBookingModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final String? id;
  final dynamic orderId;
  final Customer? customer;
  final String? paymentType;
  final String? paymentId;
  final String? paymentStatus;
  final String? price;
  final String? slotName;
  final DateTime? bookingDate;
  final String? bookingId;
  final dynamic pincode;
  final String? status;
  final List<dynamic>? itemList;

  Datum({
    this.id,
    this.orderId,
    this.customer,
    this.paymentType,
    this.paymentId,
    this.paymentStatus,
    this.price,
    this.slotName,
    this.bookingDate,
    this.bookingId,
    this.pincode,
    this.status,
    this.itemList,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"].toString(),
        orderId: json["orderId"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        paymentType: json["paymentType"],
        paymentId: json["payment_id"],
        paymentStatus: json["payment_status"],
        price: json["price"],
        slotName: json["slot_name"],
        bookingDate: json["booking_date"] == null
            ? null
            : DateTime.parse(json["booking_date"]),
        bookingId: json["booking_id"],
        pincode: json["pincode"],
        status: json["status"],
        itemList: json["itemList"] == null
            ? []
            : List<dynamic>.from(json["itemList"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "customer": customer?.toJson(),
        "paymentType": paymentType,
        "payment_id": paymentId,
        "payment_status": paymentStatus,
        "price": price,
        "slot_name": slotName,
        "booking_date":
            "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
        "booking_id": bookingId,
        "pincode": pincode,
        "status": status,
        "itemList":
            itemList == null ? [] : List<dynamic>.from(itemList!.map((x) => x)),
      };
}

class Customer {
  final String? firstName;
  final String? lastName;
  final dynamic profile;
  final String? mobile;
  final dynamic address;

  Customer({
    this.firstName,
    this.lastName,
    this.profile,
    this.mobile,
    this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        firstName: json["first_name"],
        lastName: json["last_name"],
        profile: json["profile"],
        mobile: json["mobile"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "profile": profile,
        "mobile": mobile,
        "address": address,
      };
}

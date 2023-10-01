// To parse this JSON data, do
//
//     final allAvailableCoupon = allAvailableCouponFromJson(jsonString);

import 'dart:convert';

AllAvailableCoupon allAvailableCouponFromJson(String str) => AllAvailableCoupon.fromJson(json.decode(str));

String allAvailableCouponToJson(AllAvailableCoupon data) => json.encode(data.toJson());

class AllAvailableCoupon {
  bool? status;
  String? message;
  List<Datum>? data;

  AllAvailableCoupon({
    this.status,
    this.message,
    this.data,
  });

  factory AllAvailableCoupon.fromJson(Map<String, dynamic> json) => AllAvailableCoupon(
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
  int? id;
  String? offerAmount;
  String? offerCashbook;
  String? status;

  Datum({
    this.id,
    this.offerAmount,
    this.offerCashbook,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    offerAmount: json["offer_amount"],
    offerCashbook: json["offer_cashbook"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "offer_amount": offerAmount,
    "offer_cashbook": offerCashbook,
    "status": status,
  };
}

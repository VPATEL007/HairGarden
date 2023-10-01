// To parse this JSON data, do
//
//     final couponModel = couponModelFromJson(jsonString);

import 'dart:convert';

CouponModel couponModelFromJson(String str) => CouponModel.fromJson(json.decode(str));

String couponModelToJson(CouponModel data) => json.encode(data.toJson());

class CouponModel {
  final bool? status;
  final String? message;
  final List<Datum>? data;

  CouponModel({
    this.status,
    this.message,
    this.data,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
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
  final String? id;
  final String? coupanCode;
  final String? amount;
  final String? description;
  final DateTime? startDate;
  final DateTime? expiryDate;
  final String? useLimit;
  final String? assign;
  final String? users;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;

  Datum({
    this.id,
    this.coupanCode,
    this.amount,
    this.description,
    this.startDate,
    this.expiryDate,
    this.useLimit,
    this.assign,
    this.users,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"].toString(),
    coupanCode: json["coupan_code"],
    amount: json["amount"].toString(),
    description: json["description"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    expiryDate: json["expiry_date"] == null ? null : DateTime.parse(json["expiry_date"]),
    useLimit: json["use_limit"],
    assign: json["assign"],
    users: json["users"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "coupan_code": coupanCode,
    "amount": amount,
    "description": description,
    "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "expiry_date": "${expiryDate!.year.toString().padLeft(4, '0')}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}",
    "use_limit": useLimit,
    "assign": assign,
    "users": users,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
  };
}

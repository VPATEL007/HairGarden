// To parse this JSON data, do
//
//     final myEarningDataModel = myEarningDataModelFromJson(jsonString);

import 'dart:convert';

MyEarningDataModel myEarningDataModelFromJson(String str) => MyEarningDataModel.fromJson(json.decode(str));

String myEarningDataModelToJson(MyEarningDataModel data) => json.encode(data.toJson());

class MyEarningDataModel {
  final bool? status;
  final String? message;
  final int? totalEarning;
  final List<Datum>? data;

  MyEarningDataModel({
    this.status,
    this.message,
    this.totalEarning,
    this.data,
  });

  factory MyEarningDataModel.fromJson(Map<String, dynamic> json) => MyEarningDataModel(
    status: json["status"],
    message: json["message"],
    totalEarning: json["total_earning"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "total_earning": totalEarning,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final String? id;
  final String? userName;
  final String? userMobile;
  final String? price;
  final String? bookingDate;

  Datum({
    this.id,
    this.userName,
    this.userMobile,
    this.price,
    this.bookingDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"].toString(),
    userName: json["user_name"],
    userMobile: json["user_mobile"],
    price: json["price"],
    bookingDate: json["booking_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_name": userName,
    "user_mobile": userMobile,
    "price": price,
    "booking_date": bookingDate,
  };
}
